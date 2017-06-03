// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
// Date        : Sun Jun  4 00:10:02 2017
// Host        : skyworks running 64-bit Ubuntu 16.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/skyworks/ArtixHwTest/ArtixHwTest.srcs/sources_1/ip/la_receiver_0/la_receiver_0_stub.v
// Design      : la_receiver_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "la_receiver,Vivado 2016.4" *)
module la_receiver_0(acq_data_out, acq_data_valid, 
  raw_signal_result, raw_signal_update, lock_level, rx_pixel_clk, reset, refclkin, clkin1_p, 
  clkin1_n, datain1_p, datain1_n)
/* synthesis syn_black_box black_box_pad_pin="acq_data_out[47:0],acq_data_valid,raw_signal_result[255:0],raw_signal_update,lock_level[2:0],rx_pixel_clk,reset,refclkin,clkin1_p,clkin1_n,datain1_p[3:0],datain1_n[3:0]" */;
  output [47:0]acq_data_out;
  output acq_data_valid;
  output [255:0]raw_signal_result;
  output raw_signal_update;
  output [2:0]lock_level;
  output rx_pixel_clk;
  input reset;
  input refclkin;
  input clkin1_p;
  input clkin1_n;
  input [3:0]datain1_p;
  input [3:0]datain1_n;
endmodule
