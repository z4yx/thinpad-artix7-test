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
    input clk_11M0592,
    input rst_in,
    
    input step_clk,
    input [3:0] step_btn,
    
    output txd,
    input rxd,
    
    //CPLD串口控制器信号
    output wire uart_rdn,         //读串口信号，低有效
    output wire uart_wrn,         //写串口信号，低有效
    input wire uart_dataready,    //串口数据准备好
    input wire uart_tbre,         //发送数据标志
    input wire uart_tsre,         //数据发送完毕标志
    
    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共享
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire base_ram_ce_n,       //BaseRAM片选，低有效
    output wire base_ram_oe_n,       //BaseRAM读使能，低有效
    output wire base_ram_we_n,       //BaseRAM写使能，低有效

    //Video output
    output wire[7:0] video_pixel,
    output wire video_hsync,
    output wire video_vsync,
    output wire video_clk,
    output wire video_de,

    output         clkout1_p,  clkout1_n,          // lvds channel 1 clock output
    output  [3:0]   dataout1_p, dataout1_n         // lvds channel 1 data outputs
    );

wire clk_test;

main_pll pll_inst
 (
  // Clock out ports
  .        clk_out1(clk_test),
  // Status and control signals
  .         reset(rst_in),
  .        locked(),
 // Clock in ports
  .         clk_in1(clk)
 );

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
    end
end

assign testdata_in = {rxd,uart_tsre, uart_tbre,uart_wrn, uart_dataready,uart_rdn, counter_slow,counter_manual,running1_auto,gpio1};
// assign gpio0[2:0] = {uart_tsre, uart_tbre, uart_dataready};

(* MARK_DEBUG = "TRUE" *)  reg sample_uart_tsre, sample_uart_tbre, sample_uart_wrn, sample_uart_rdn, sample_uart_dataready, sample_11M;
always @(posedge clk_test) begin // sampling @ 250MHz
    {sample_uart_tsre, sample_uart_tbre, sample_uart_wrn, sample_uart_rdn, sample_uart_dataready} <=
        {uart_tsre, uart_tbre, uart_wrn, uart_rdn, uart_dataready};
    sample_11M <= clk_11M0592;
end


//直连串口接收发送演示，从直连串口收到的数据再发送出去
wire [7:0] ext_uart_rx;
reg  [7:0] ext_uart_buffer, ext_uart_tx;
wire ext_uart_ready, ext_uart_busy;
reg ext_uart_start, ext_uart_avai;
wire clk_50M=clk;

async_receiver #(.ClkFrequency(50000000),.Baud(9600)) //接收模块，9600无检验位
    ext_uart_r(
        .clk(clk_50M),                       //外部时钟信号
        .RxD(rxd),                           //外部串行信号输入
        .RxD_data_ready(ext_uart_ready),  //数据接收到标志
        .RxD_clear(ext_uart_ready),       //清除接收标志
        .RxD_data(ext_uart_rx)             //接收到的一字节数据
    );
    
always @(posedge clk_50M) begin //接收到缓冲区ext_uart_buffer
    if(ext_uart_ready)begin
        ext_uart_buffer <= ext_uart_rx;
        ext_uart_avai <= 1;
    end else if(!ext_uart_busy && ext_uart_avai)begin 
        ext_uart_avai <= 0;
    end
end
always @(posedge clk_50M) begin //将缓冲区ext_uart_buffer发送出去
    if(!ext_uart_busy && ext_uart_avai)begin 
        ext_uart_tx <= ext_uart_buffer;
        ext_uart_start <= 1;
    end else begin 
        ext_uart_start <= 0;
    end
end

async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) //发送模块，9600无检验位
    ext_uart_t(
        .clk(clk_50M),                  //外部时钟信号
        .TxD(txd),                      //串行信号输出
        .TxD_busy(ext_uart_busy),       //发送器忙状态指示
        .TxD_start(ext_uart_start),    //开始发送信号
        .TxD_data(ext_uart_tx)        //待发送的数据
    );

//CPLD串口接收发送演示，从CPLD串口收到的数据再发送出去
reg[31:0] auto_read;
reg[7:0] cpld_recv;
assign uart_rdn = ~(~auto_read[2] & auto_read[1]);
assign uart_wrn = ~step_btn[3] & ~(~auto_read[3] & auto_read[2]);
always @(posedge clk) begin
    auto_read <= {auto_read[30:0],uart_dataready};
    if(auto_read[1])
        cpld_recv <= base_ram_data[7:0]; //show received data on segment display
end
assign base_ram_ce_n = 1;
assign base_ram_oe_n = 1;
assign base_ram_data[7:0] = uart_wrn ? 8'bzzzz_zzzz : cpld_recv;

// 7-Segment display decoder
wire [7:0] seg_content;
SEG7_LUT segL(.oSEG1({gpio0[16+:8]}), .iDIG(seg_content[3:0]));
SEG7_LUT segH(.oSEG1({gpio0[24+:8]}), .iDIG(seg_content[7:4]));
assign gpio0[0+:16] = step_btn[2] ? {12'h0, step_btn} : (gpio1[0+:16] ^ gpio1[16+:16]);
assign seg_content = step_btn[2] ? counter_manual[7:0] : cpld_recv;

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
