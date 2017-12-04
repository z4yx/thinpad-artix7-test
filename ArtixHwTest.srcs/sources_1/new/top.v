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
    output reg [31:0] gpio0,
    input clk,
    input rst_in,
    input step_clk,
    input [1:0] step_btn,
    output txd,
    input rxd,
    
    //Video output
    output wire[7:0] video_pixel,
    output wire video_hsync,
    output wire video_vsync,
    output wire video_clk,
    output wire video_de,

    output         clkout1_p,  clkout1_n,          // lvds channel 1 clock output
    output  [3:0]   dataout1_p, dataout1_n         // lvds channel 1 data outputs
    );
    
//wire clk_ser, locked;
assign txd = rxd;

/*
clk_wiz_0  inclk
(
// Clock out ports
    .clk_out1(clk_ser),
// Status and control signals
    .reset(rst_in),
    .locked(locked),
// Clock in ports
    .clk_in1(clk)
);*/

wire [255:0] testdata_in;

sampler_0 la(
    .sample_clk    (clk),
    .ref_50M_clk   (clk),
    .clkout1_p (clkout1_p),
    .clkout1_n (clkout1_n),
    .dataout1_p(dataout1_p),
    .dataout1_n(dataout1_n),
    .start_sample  (step_btn[0]),
    .stop_sample   (step_btn[1]),
    .data_in       (testdata_in)
);

reg [31:0] running1_auto;
reg[23:0] counter, counter_slow, counter_manual;

always@(posedge clk or posedge rst_in) begin 
    if(rst_in) 
        running1_auto <= 'h1;
    else 
        running1_auto <= {running1_auto[30:0], running1_auto[31]};
end
always@(posedge step_clk or posedge rst_in) begin 
    if(rst_in) 
        counter_manual <= 'h0;
    else 
        counter_manual <= counter_manual+1;
end

always@(posedge clk or posedge rst_in) begin
    if(rst_in)begin
        counter<=0;
        counter_slow<=0;
    end else begin
        counter<= counter+1;
        counter_slow <= counter_slow + (&counter);
        gpio0 <= gpio1;
    end
end

assign testdata_in = {counter_slow,rxd,counter[23:1],running1_auto,counter_manual,gpio1};

//VGA display pattern generation
wire [2:0] red,green;
wire [1:0] blue;
wire [11:0] hdata, vdata, hdata_offset;
reg [11:0] vdata_old;
reg [4:0] offset;
assign video_pixel = {red,green,blue};
assign video_clk = clk;
assign hdata_offset = hdata - offset;
assign red = hdata_offset[9:8] == 2'b00 ? hdata_offset[7:5] : 0;
assign green = hdata_offset[9:8] == 2'b01 ? hdata_offset[7:5] : 0;
assign blue = hdata_offset[9:8] == 2'b10 ? hdata_offset[7:6] : 0;
always @(posedge clk) 
begin
    vdata_old <= vdata;
    if(vdata == 610 && vdata != vdata_old)
        offset <= offset+1;
end
vga #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
    .clk(clk),
    .hdata(hdata),
    .vdata(vdata),
    .hsync(video_hsync),
    .vsync(video_vsync),
    .data_enable(video_de)
);

endmodule
