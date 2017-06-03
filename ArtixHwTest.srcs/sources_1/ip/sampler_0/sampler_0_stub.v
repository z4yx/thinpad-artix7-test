// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
// Date        : Sat Jun  3 23:56:27 2017
// Host        : skyworks running 64-bit Ubuntu 16.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/skyworks/ArtixHwTest/ArtixHwTest.srcs/sources_1/ip/sampler_0/sampler_0_stub.v
// Design      : sampler_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "sampler,Vivado 2016.4" *)
module sampler_0(clkout1_p, clkout1_n, dataout1_p, dataout1_n, 
  txmit_ref_clk, sample_clk, start_sample, stop_sample, data_in)
/* synthesis syn_black_box black_box_pad_pin="clkout1_p,clkout1_n,dataout1_p[3:0],dataout1_n[3:0],txmit_ref_clk,sample_clk,start_sample,stop_sample,data_in[255:0]" */;
  output clkout1_p;
  output clkout1_n;
  output [3:0]dataout1_p;
  output [3:0]dataout1_n;
  input txmit_ref_clk;
  input sample_clk;
  input start_sample;
  input stop_sample;
  input [255:0]data_in;
endmodule
