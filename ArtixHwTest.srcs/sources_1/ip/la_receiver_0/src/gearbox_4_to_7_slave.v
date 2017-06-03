//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2012-2015 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
//////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor: Xilinx
// \   \   \/    Version: 1.2
//  \   \        Filename: gearbox_4_to_7_slave.v
//  /   /        Date Last Modified:  21JAN2015
// /___/   /\    Date Created: 30SEP2010
// \   \  /  \
//  \___\/\___\
// 
//Device: 	7 Series
//Purpose:  	multiple 4 to 7 bit gearbox
//
//Reference:	XAPP585
//    
//Revision History:
//    Rev 1.0 - First created (nicks)
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

module gearbox_4_to_7_slave (input_clock, output_clock, datain, reset, jog, dataout) ;

parameter integer 		D = 8 ;   		// Parameter to set the number of data lines  

input				input_clock ;		// high speed clock input
input				output_clock ;		// low speed clock input
input		[D*4-1:0]	datain ;		// data inputs
input		[1:0]		reset ;			// Reset line
input				jog ;			// jog input, slips by 4 bits
output	reg	[D*7-1:0]	dataout ;		// data outputs
					
reg	[3:0]		read_addra ;			
reg	[3:0]		read_addrb ;			
reg	[3:0]		read_addrc ;			
reg	[3:0]		write_addr ;			
wire	[D*4-1:0]	ramouta ; 			
wire	[D*4-1:0]	ramoutb ;			
wire	[D*4-1:0]	ramoutc ;			
reg	[1:0]		mux ;		
wire	[D*4-1:0]	dummy ;			
reg			jog_int ;	

genvar i ;

always @ (posedge input_clock) begin				// Gearbox input - 4 bit data at input clock frequency
	if (reset[0] == 1'b1) begin
		write_addr <= 4'h0 ;
	end 
	else begin
		if (write_addr == 4'hD) begin
			write_addr <= 4'h0 ;
		end 
		else begin
			write_addr <= write_addr + 4'h1 ;
		end
	end
end

always @ (posedge output_clock) begin				// Gearbox output - 10 bit data at output clock frequency
	if (reset[1] == 1'b1) begin
		read_addra <= 4'h0 ;
		read_addrb <= 4'h1 ;
		read_addrc <= 4'h2 ;
		jog_int <= 1'b0 ;
	end
	else begin
		case (jog_int)
		1'b0 : begin
			case (read_addra)
			4'h0    : begin read_addra <= 4'h1 ; read_addrb <= 4'h2 ; read_addrc <= 4'h3 ; mux <= 2'h1 ; end
			4'h1    : begin read_addra <= 4'h3 ; read_addrb <= 4'h4 ; read_addrc <= 4'h5 ; mux <= 2'h2 ; end
			4'h3    : begin read_addra <= 4'h5 ; read_addrb <= 4'h6 ; read_addrc <= 4'h7 ; mux <= 2'h3 ; end
			4'h5    : begin read_addra <= 4'h7 ; read_addrb <= 4'h8 ; read_addrc <= 4'h9 ; mux <= 2'h0 ; end
			4'h7    : begin read_addra <= 4'h8 ; read_addrb <= 4'h9 ; read_addrc <= 4'hA ; mux <= 2'h1 ; end
			4'h8    : begin read_addra <= 4'hA ; read_addrb <= 4'hB ; read_addrc <= 4'hC ; mux <= 2'h2 ; end
			4'hA    : begin read_addra <= 4'hC ; read_addrb <= 4'hD ; read_addrc <= 4'hD ; mux <= 2'h3 ; jog_int <= jog ; end
			default : begin read_addra <= 4'h0 ; read_addrb <= 4'h1 ; read_addrc <= 4'h2 ; mux <= 2'h0 ; end
			endcase 
		end
		1'b1 : begin
			case (read_addra)
			4'h1    : begin read_addra <= 4'h2 ; read_addrb <= 4'h3 ; read_addrc <= 4'h4 ; mux <= 2'h1 ; end
			4'h2    : begin read_addra <= 4'h4 ; read_addrb <= 4'h5 ; read_addrc <= 4'h6 ; mux <= 2'h2 ; end
			4'h4    : begin read_addra <= 4'h6 ; read_addrb <= 4'h7 ; read_addrc <= 4'h8 ; mux <= 2'h3 ; end
			4'h6    : begin read_addra <= 4'h8 ; read_addrb <= 4'h9 ; read_addrc <= 4'hA ; mux <= 2'h0 ; end
			4'h8    : begin read_addra <= 4'h9 ; read_addrb <= 4'hA ; read_addrc <= 4'hB ; mux <= 2'h1 ; end
			4'h9    : begin read_addra <= 4'hB ; read_addrb <= 4'hC ; read_addrc <= 4'hD ; mux <= 2'h2 ; end
			4'hB    : begin read_addra <= 4'hD ; read_addrb <= 4'h0 ; read_addrc <= 4'h1 ; mux <= 2'h3 ; jog_int <= jog ; end
			default : begin read_addra <= 4'h1 ; read_addrb <= 4'h2 ; read_addrc <= 4'h3 ; mux <= 2'h0 ; end
			endcase 
		end
		endcase
	end
end

generate
for (i = 0 ; i <= D-1 ; i = i+1)
begin : loop0

always @ (posedge output_clock) begin
	case (mux)
	2'h0    : dataout[7*i+6:7*i] <= {                      ramoutb[4*i+2:4*i+0], ramouta[4*i+3:4*i+0]} ;
	2'h1    : dataout[7*i+6:7*i] <= {ramoutc[4*i+1:4*i+0], ramoutb[4*i+3:4*i+0], ramouta[4*i+3]} ;    
	2'h2    : dataout[7*i+6:7*i] <= {ramoutc[4*i+0],       ramoutb[4*i+3:4*i+0], ramouta[4*i+3:4*i+2]} ; 
	default : dataout[7*i+6:7*i] <= {                      ramoutb[4*i+3:4*i+0], ramouta[4*i+3:4*i+1]} ; 
	endcase 
end 

end
endgenerate 
			     	
// Data gearboxes

generate
for (i = 0 ; i <= D*2-1 ; i = i+1)
begin : loop2

RAM32M ram_inst ( 
	.DOA	(ramouta[2*i+1:2*i]), 
	.DOB	(ramoutb[2*i+1:2*i]),
	.DOC    (ramoutc[2*i+1:2*i]), 
	.DOD    (dummy[2*i+1:2*i]),
	.ADDRA	({1'b0, read_addra}), 
	.ADDRB	({1'b0, read_addrb}), 
	.ADDRC  ({1'b0, read_addrc}), 
	.ADDRD  ({1'b0, write_addr}),
	.DIA	(datain[2*i+1:2*i]), 
	.DIB	(datain[2*i+1:2*i]),
	.DIC    (datain[2*i+1:2*i]),
	.DID    (dummy[2*i+1:2*i]),
	.WE 	(1'b1), 
	.WCLK	(input_clock));

end
endgenerate 

endmodule
