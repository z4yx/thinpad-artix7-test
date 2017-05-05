//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012-2015 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor: Xilinx
// \   \   \/    Version: 1.2
//  \   \        Filename: serdes_7_to_1_diff_sdr.v
//  /   /        Date Last Modified:  21JAN2015
// /___/   /\    Date Created: 2SEP2011
// \   \  /  \
//  \___\/\___\
// 
//Device: 	7-Series
//Purpose:  	D-bit generic SDR 7:1 transmitter module via 7:1 serdes mode
// 		Takes in 7*D bits of data and serialises this to D bits
// 		data is transmitted LSB first
//		Data formatting is set by the DATA_FORMAT parameter. 
//		PER_CLOCK (default) format transmits bits for 0, 1, 2 ... on the same transmitter clock edge
//		PER_CHANL format transmits bits for 0, 7, 14 .. on the same transmitter clock edge
//		Data inversion can be accomplished via the TX_SWAP_MASK 
//		parameter if required.
//		Also generates clock output
//
//Reference:	XAPP585.pdf
//    
//Revision History:
//    Rev 1.0 - First created (nicks)
//    Rev 1.1 - PER_CLOCK and PER_CHANL descriptions swapped
//    Rev 1.2 - Updated format (brandond)
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

module serdes_7_to_1_diff_sdr (txclk, reset, pixel_clk, datain, clk_pattern, dataout_p, dataout_n, clkout_p, clkout_n) ;

parameter integer 	D = 16 ;			// Set the number of outputs
parameter         	DATA_FORMAT = "PER_CLOCK" ;     // Parameter Used to determine method for mapping input parallel word to output serial words
                                        	
input 			txclk ;				// Tx Clock network
input 			reset ;				// Reset
input 			pixel_clk ;			// pixel rate clock
input 	[(D*7)-1:0]	datain ;  			// Data for output
input 	[6:0]		clk_pattern ;  			// clock pattern for output
output 	[D-1:0]		dataout_p ;			// output data
output 	[D-1:0]		dataout_n ;			// output data
output 			clkout_p ;			// output clock
output 			clkout_n ;			// output clock

wire	[D-1:0]		tx_data_out ;
wire	[D*7-1:0]	mdataina ;	
reg			reset_int ;	

parameter [D-1:0] TX_SWAP_MASK = 16'h0000 ;		// pinswap mask for output bits (0 = no swap (default), 1 = swap). Allows outputs to be connected the 'wrong way round' to ease PCB routing.

always @ (posedge pixel_clk or posedge reset) begin
if (reset == 1'b1) begin
	reset_int <= 1'b1 ;
end
else begin
	reset_int <= 1'b0 ;
end
end

genvar i ;
genvar j ;

generate
for (i = 0 ; i <= (D-1) ; i = i+1)
begin : loop0

OBUFDS io_data_out (
	.O    			(dataout_p[i]),
	.OB       		(dataout_n[i]),
	.I         		(tx_data_out[i]));

// re-arrange data bits for transmission and invert lines as given by the mask
// NOTE If pin inversion is required (non-zero SWAP MASK) then inverters will occur in fabric, as there are no inverters in the OSERDESE2
// This can be avoided by doing the inversion (if necessary) in the user logic

for (j = 0 ; j <= 6 ; j = j+1) begin : loop1
	if (DATA_FORMAT == "PER_CLOCK") begin
		assign mdataina[7*i+j] = datain[i+(D*j)] ^ TX_SWAP_MASK[i] ;
	end 
	else begin
		assign mdataina[7*i+j] = datain[7*i+j] ^ TX_SWAP_MASK[i] ;
	end
end

OSERDESE2 #(
	.DATA_WIDTH     	(7), 			// SERDES word width
	.TRISTATE_WIDTH     	(1), 
	.DATA_RATE_OQ      	("SDR"), 		// <SDR>, DDR
	.DATA_RATE_TQ      	("SDR"), 		// <SDR>, DDR
	.SERDES_MODE    	("MASTER"))  		// <DEFAULT>, MASTER, SLAVE
oserdes_m (
	.OQ       		(tx_data_out[i]),
	.OCE     		(1'b1),
	.CLK    		(txclk),
	.RST     		(reset_int),
	.CLKDIV  		(pixel_clk),
	.D8  			(1'b0),
	.D7  			(mdataina[(7*i)+6]),
	.D6  			(mdataina[(7*i)+5]),
	.D5  			(mdataina[(7*i)+4]),
	.D4  			(mdataina[(7*i)+3]),
	.D3  			(mdataina[(7*i)+2]),
	.D2  			(mdataina[(7*i)+1]),
	.D1  			(mdataina[(7*i)+0]),
	.TQ  			(),
	.T1 			(1'b0),
	.T2 			(1'b0),
	.T3 			(1'b0),
	.T4 			(1'b0),
	.TCE	 		(1'b1),
	.TBYTEIN		(1'b0),
	.TBYTEOUT		(),
	.OFB	 		(),
	.TFB	 		(),
	.SHIFTOUT1 		(),			
	.SHIFTOUT2 		(),			
	.SHIFTIN1 		(1'b0),	
	.SHIFTIN2 		(1'b0)) ;				

end
endgenerate

OBUFDS io_clk_out (
	.O    			(clkout_p),
	.OB       		(clkout_n),
	.I         		(tx_clk_out));

OSERDESE2 #(
	.DATA_WIDTH     	(7), 			// SERDES word width
	.TRISTATE_WIDTH     	(1), 
	.DATA_RATE_OQ      	("SDR"), 		// <SDR>, DDR
	.DATA_RATE_TQ      	("SDR"), 		// <SDR>, DDR
	.SERDES_MODE    	("MASTER"))  		// <DEFAULT>, MASTER, SLAVE
oserdes_cm (
	.OQ       		(tx_clk_out),
	.OCE     		(1'b1),
	.CLK    		(txclk),
	.RST     		(reset_int),
	.CLKDIV  		(pixel_clk),
	.D8  			(1'b0),
	.D7  			(clk_pattern[6]),
	.D6  			(clk_pattern[5]),
	.D5  			(clk_pattern[4]),
	.D4  			(clk_pattern[3]),
	.D3  			(clk_pattern[2]),
	.D2  			(clk_pattern[1]),
	.D1  			(clk_pattern[0]),
	.TQ  			(),
	.T1 			(1'b0),
	.T2 			(1'b0),
	.T3 			(1'b0),
	.T4 			(1'b0),
	.TCE	 		(1'b1),
	.TBYTEIN		(1'b0),
	.TBYTEOUT		(),
	.OFB	 		(),
	.TFB	 		(),
	.SHIFTOUT1 		(),			
	.SHIFTOUT2 		(),			
	.SHIFTIN1 		(1'b0),	
	.SHIFTIN2 		(1'b0)) ;	
	
endmodule
