`timescale 1ns / 1ps
/*
GPIO  BANK   PIN

11 14P34 N19
0 14N34 N20
10 19P V14
1 19N V15
2 5P U20
4 5N V20
7 23P34 R18
3 23N34 T18
9 23P Y13
8 23N AA13
5 6P V18
6 20P V13

11 14P P20
0 14N P21
10 18P K22
1 18N K23
2 8P M20
4 8N L20
7 6P M16
3 6N M17
9 16P J24
8 16N H24
5 IO25 L19
6 12P K21

*/

module top(
    input [31:0] gpio1,
    output [31:0] gpio0,
    input clk,
    input rst_in,
    input step_btn,
    output txd,
    input rxd,
    output         clkout1_p,  clkout1_n,          // lvds channel 1 clock output
    output  [3:0]   dataout1_p, dataout1_n         // lvds channel 1 data outputs
    );
    
reg[23:0] counter;
wire clk_ser, locked;
assign txd = rxd;

clk_wiz_0  inclk
(
// Clock out ports
    .clk_out1(clk_ser),
// Status and control signals
    .reset(rst_in),
    .locked(locked),
// Clock in ports
    .clk_in1(clk)
);

reg [255:0] testdata_in;
reg [1:0] start_sample;
sampler la(
    .sample_clk    (clk),
    .txmit_ref_clk(clk_ser),
    .clkout1_p (clkout1_p),
    .clkout1_n (clkout1_n),
    .dataout1_p(dataout1_p),
    .dataout1_n(dataout1_n),
    .start_sample  (start_sample[1]),
    .stop_sample  (0),
    .data_in       (testdata_in)
);
always@(posedge clk or posedge rst_in) begin 
    if(rst_in) start_sample <= 0;
    else start_sample <= {start_sample[0], step_btn};
end
always@(posedge clk or posedge rst_in) begin 
    if(rst_in) testdata_in <= 256'h1;
    else testdata_in <= {testdata_in[254:0], testdata_in[255]};
end

always@(posedge clk or posedge rst_in) begin
    if(rst_in)counter<=0;
    else counter<= counter+1;
end

genvar i;
generate
    for(i=0;i<32;i=i+1) begin : as
        assign gpio0[i] = gpio1[i]^counter[23];
    end
endgenerate
    
endmodule
