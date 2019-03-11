//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012-2015 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor: Xilinx
// \   \   \/    Version: 1.2
//  \   \        Filename: n_x_serdes_7_to_1_diff_ddr.v
//  /   /        Date Last Modified:  21JAN2015
// /___/   /\    Date Created: 2SEP2011
// \   \  /  \
//  \___\/\___\
// 
//Device: 	7-Series
//Purpose:  	N channel wrapper for multiple 7:1 serdes channels
//
//Reference:	XAPP585
//    
//Revision History:
//    Rev 1.0 - First created (nicks)
//    Rev 1.2 - Updated format (brandond)
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

module n_x_serdes_7_to_1_diff_ddr (txclk, reset, pixel_clk, txclk_div, datain, clk_pattern, dataout_p, dataout_n, clkout_p, clkout_n) ;

parameter integer 	N = 8 ;				// Set the number of channels
parameter integer	D = 6 ;				// Set the number of outputs per channel
parameter         	DATA_FORMAT = "PER_CLOCK" ;   	// Parameter Used to determine method for mapping input parallel word to output serial words
                                       	
input 			txclk ;				// IO Clock network
input 			reset ;				// Reset
input 			pixel_clk ;			// clock at pixel rate
input			txclk_div ;			// 1/2 rate clock output for gearbox
input 	[(D*N*7)-1:0]	datain ;  			// Data for output
input 	[6:0]		clk_pattern ;  			// clock pattern for output
output 	[D*N-1:0]	dataout_p ;			// output data
output 	[D*N-1:0]	dataout_n ;			// output data
output 	[N-1:0]		clkout_p ;			// output clock
output 	[N-1:0]		clkout_n ;			// output clock

genvar i ;
genvar j ;

generate
for (i = 0 ; i <= (N-1) ; i = i+1)
begin : loop0

serdes_7_to_1_diff_ddr #(
      	.D			(D),
      	.DATA_FORMAT		(DATA_FORMAT))
dataout (
	.dataout_p  		(dataout_p[D*(i+1)-1:D*i]),
	.dataout_n  		(dataout_n[D*(i+1)-1:D*i]),
	.clkout_p  		(clkout_p[i]),
	.clkout_n  		(clkout_n[i]),
	.txclk    		(txclk),
	.pixel_clk    		(pixel_clk),
	.txclk_div    		(txclk_div),
	.reset   		(reset),
	.clk_pattern  		(clk_pattern),
	.datain  		(datain[(D*(i+1)*7)-1:D*i*7]));		
end
endgenerate		
endmodule
