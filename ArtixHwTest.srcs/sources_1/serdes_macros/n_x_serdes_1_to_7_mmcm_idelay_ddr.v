//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012-2015 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor: Xilinx
// \   \   \/    Version: 1.2
//  \   \        Filename: n_x_serdes_1_to_7_mmcm_idelay_ddr.v
//  /   /        Date Last Modified:  20JAN2015
// /___/   /\    Date Created: 5MAR2010
// \   \  /  \
//  \___\/\___\
// 
//Device: 	7 Series
//Purpose:  	Wrapper for multiple 1 to 7 receiver clock and data receiver using one MMCM for clock multiplication
//
//Reference:	XAPP585
//    
//Revision History:
//    Rev 1.0 - First created (nicks)
//    Rev 1.1 - rxclk_d4 output added
//    Rev 1.2 - master and slaves gearbox sync added, updated format
//
//////////////////////////////////////////////////////////////////////////////
//
//  Disclaimer: 
//
//		This disclaimer is not a license and does not grant any rights to the materials 
//              distributed herewith. Except as otherwise provided in a valid license issued to you 
//              by Xilinx, and to the maximum extent permitted by applicable law: 
//              (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, 
//              AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
//              INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
//              FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract 
//              or tort, including negligence, or under any other theory of liability) for any loss or damage 
//              of any kind or nature related to, arising under or in connection with these materials, 
//              including for any direct, or any indirect, special, incidental, or consequential loss 
//              or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered 
//              as a result of any action brought by a third party) even if such damage or loss was 
//              reasonably foreseeable or Xilinx had been advised of the possibility of the same.
//
//  Critical Applications:
//
//		Xilinx products are not designed or intended to be fail-safe, or for use in any application 
//		requiring fail-safe performance, such as life-support or safety devices or systems, 
//		Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
//		or any other applications that could lead to death, personal injury, or severe property or 
//		environmental damage (individually and collectively, "Critical Applications"). Customer assumes 
//		the sole risk and liability of any use of Xilinx products in Critical Applications, subject only 
//		to applicable laws and regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module n_x_serdes_1_to_7_mmcm_idelay_ddr (clkin_p, clkin_n, datain_p, datain_n, enable_phase_detector, rxclk, rxclk_d4, idelay_rdy, reset, pixel_clk, enable_monitor, 
                                          rx_mmcm_lckdps, rx_mmcm_lckd, rx_mmcm_lckdpsbs, clk_data, rx_data, status, debug, dcd_correct, bit_rate_value, bit_time_value, m_delay_1hot, eye_info) ;

parameter integer 	N = 8 ;				// Set the number of channels
parameter integer 	D = 6 ;   			// Parameter to set the number of data lines per channel
parameter integer      	MMCM_MODE = 1 ;   		// Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
parameter real 	  	CLKIN_PERIOD = 6.000 ;		// clock period (ns) of input clock on clkin_p
parameter real      	REF_FREQ = 200.0 ;   		// Parameter to set reference frequency used by idelay controller
parameter 		HIGH_PERFORMANCE_MODE = "FALSE";// Parameter to set HIGH_PERFORMANCE_MODE of input delays to reduce jitter
parameter         	DIFF_TERM = "FALSE" ; 		// Parameter to enable internal differential termination
parameter         	SAMPL_CLOCK = "BUFIO" ;   	// Parameter to set sampling clock buffer type, BUFIO, BUF_H, BUF_G
parameter         	INTER_CLOCK = "BUF_R" ;      	// Parameter to set intermediate clock buffer type, BUFR, BUF_H, BUF_G
parameter         	PIXEL_CLOCK = "BUF_G" ;       	// Parameter to set pixel clock buffer type, BUF_R, BUF_H, BUF_G
parameter         	USE_PLL = "FALSE" ;          	// Parameter to enable PLL use rather than MMCM use, overides SAMPL_CLOCK and INTER_CLOCK to be both BUFH
parameter         	DATA_FORMAT = "PER_CLOCK" ;     // Parameter Used to determine method for mapping input parallel word to output serial words
                                       	
input 	[N-1:0]		clkin_p ;			// Input from LVDS clock receiver pin
input 	[N-1:0]		clkin_n ;			// Input from LVDS clock receiver pin
input 	[N*D-1:0]	datain_p ;			// Input from LVDS clock data pins
input 	[N*D-1:0]	datain_n ;			// Input from LVDS clock data pins
input 			enable_phase_detector ;		// Enables the phase detector logic when high
input			enable_monitor ;		// Enable monitoring function
input 			reset ;				// Reset line
input			idelay_rdy ;			// input delays are ready
output 			rxclk ;				// Global/BUFIO rx clock network
output 			rxclk_d4 ;			// Global/BUFIO rx clock network
output 			pixel_clk ;			// Global/Regional clock output
output 			rx_mmcm_lckd ; 			// MMCM locked, synchronous to rxclk_d4
output 			rx_mmcm_lckdps ; 		// MMCM locked and phase shifting finished, synchronous to rxclk_d4
output 	[N-1:0]		rx_mmcm_lckdpsbs ; 		// MMCM locked and phase shifting finished and bitslipping finished, synchronous to pixel_clk
output 	[7*N-1:0]	clk_data ;	 		// Clock Data
output 	[N*D*7-1:0]	rx_data ;	 		// Received Data
output 	[(10*D+6)*N-1:0]debug ;	 			// debug info
output 	[6:0]		status ;	 		// clock status
input			dcd_correct ;			// '0' = square, '1' = assume 10% DCD
input 	[15:0]		bit_rate_value ;	 	// Bit rate in Mbps, for example 16'h0585
output	[4:0]		bit_time_value ;		// Calculated bit time value for slave devices
output	[32*D*N-1:0]	m_delay_1hot ;			// Master delay control value as a one-hot vector
output	[32*D*N-1:0]	eye_info ;			// eye info

wire			rxclk_d4 ;
wire	[1:0]		gb_rst_out ;

serdes_1_to_7_mmcm_idelay_ddr #(
	.SAMPL_CLOCK		(SAMPL_CLOCK),
	.INTER_CLOCK		(INTER_CLOCK),
	.PIXEL_CLOCK		(PIXEL_CLOCK),
	.USE_PLL		(USE_PLL),
	.REF_FREQ		(REF_FREQ),
	.HIGH_PERFORMANCE_MODE 	(HIGH_PERFORMANCE_MODE),
      	.D			(D),				// Number of data lines
      	.CLKIN_PERIOD		(CLKIN_PERIOD),			// Set input clock period
      	.MMCM_MODE		(MMCM_MODE),			// Set mmcm vco, either 1 or 2
	.DIFF_TERM		(DIFF_TERM),
      	.DATA_FORMAT		(DATA_FORMAT))
rx0 (
	.clkin_p   		(clkin_p[0]),
	.clkin_n   		(clkin_n[0]),
	.datain_p     		(datain_p[D-1:0]),
	.datain_n     		(datain_n[D-1:0]),
	.enable_phase_detector	(enable_phase_detector),
	.enable_monitor		(enable_monitor),
	.rxclk    		(rxclk),
	.idelay_rdy		(idelay_rdy),
	.pixel_clk		(pixel_clk),
	.rxclk_d4		(rxclk_d4),
	.reset     		(reset),
	.rx_mmcm_lckd		(rx_mmcm_lckd),
	.rx_mmcm_lckdps		(rx_mmcm_lckdps),
	.rx_mmcm_lckdpsbs	(rx_mmcm_lckdpsbs[0]),
	.clk_data  		(clk_data[6:0]),
	.rx_data		(rx_data[7*D-1:0]),
	.dcd_correct		(dcd_correct),
	.bit_rate_value		(bit_rate_value),
	.bit_time_value		(bit_time_value),
	.del_mech		(del_mech), 
	.status			(status),
	.debug			(debug[10*D+5:0]),
	.rst_iserdes		(rst_iserdes),
	.gb_rst_out		(gb_rst_out),
	.m_delay_1hot		(m_delay_1hot[32*D-1:0]),
	.eye_info		(eye_info[32*D-1:0]));

genvar i ;
genvar j ;

generate
for (i = 1 ; i <= (N-1) ; i = i+1)
begin : loop0

serdes_1_to_7_slave_idelay_ddr #(
      	.D			(D),				// Number of data lines
	.REF_FREQ		(REF_FREQ),
	.HIGH_PERFORMANCE_MODE 	(HIGH_PERFORMANCE_MODE),
	.DIFF_TERM		(DIFF_TERM),
      	.DATA_FORMAT		(DATA_FORMAT))
rxn (
	.clkin_p   		(clkin_p[i]),
	.clkin_n   		(clkin_n[i]),
	.datain_p     		(datain_p[D*(i+1)-1:D*i]),
	.datain_n     		(datain_n[D*(i+1)-1:D*i]),
	.enable_phase_detector	(enable_phase_detector),
	.enable_monitor		(enable_monitor),
	.rxclk    		(rxclk),
	.idelay_rdy		(idelay_rdy),
	.pixel_clk		(pixel_clk),
	.rxclk_d4		(rxclk_d4),
	.reset     		(~rx_mmcm_lckdps),
	.bitslip_finished	(rx_mmcm_lckdpsbs[i]),
	.clk_data  		(clk_data[7*i+6:7*i]),
	.rx_data		(rx_data[(D*(i+1)*7)-1:D*i*7]),
	.bit_time_value		(bit_time_value),
	.del_mech		(del_mech), 
	.debug			(debug[(10*D+6)*(i+1)-1:(10*D+6)*i]),
	.rst_iserdes		(rst_iserdes),
	.gb_rst_in		(gb_rst_out),
	.m_delay_1hot		(m_delay_1hot[(32*D)*(i+1)-1:(32*D)*i]),
	.eye_info		(eye_info[(32*D)*(i+1)-1:(32*D)*i]));

end
endgenerate
endmodule
