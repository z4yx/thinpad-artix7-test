// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
// Date        : Thu Jun  1 19:24:55 2017
// Host        : skyworks running 64-bit Ubuntu 16.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/skyworks/ArtixHwTest/ArtixHwTest.srcs/sources_1/ip/txmit_fifo/txmit_fifo_stub.v
// Design      : txmit_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_3,Vivado 2016.4" *)
module txmit_fifo(clk, rst, din, wr_en, rd_en, dout, full, empty, valid)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,din[55:0],wr_en,rd_en,dout[55:0],full,empty,valid" */;
  input clk;
  input rst;
  input [55:0]din;
  input wr_en;
  input rd_en;
  output [55:0]dout;
  output full;
  output empty;
  output valid;
endmodule
