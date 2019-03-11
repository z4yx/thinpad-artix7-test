// (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:sampler:1.1
// IP Revision: 1

(* X_CORE_INFO = "sampler,Vivado 2017.1" *)
(* CHECK_LICENSE_TYPE = "sampler_0,sampler,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module sampler_0 (
  clkout1_p,
  clkout1_n,
  dataout1_p,
  dataout1_n,
  ref_50M_clk,
  sample_clk,
  start_sample,
  stop_sample,
  data_in
);

output wire clkout1_p;
output wire clkout1_n;
output wire [3 : 0] dataout1_p;
output wire [3 : 0] dataout1_n;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 txmit_ref_clk CLK, xilinx.com:signal:clock:1.0 ref_50M_clk CLK" *)
input wire ref_50M_clk;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 sample_clk CLK" *)
input wire sample_clk;
input wire start_sample;
input wire stop_sample;
input wire [255 : 0] data_in;

  sampler #(
    .CHANNEL(16),
    .DATA_BITS(16)
  ) inst (
    .clkout1_p(clkout1_p),
    .clkout1_n(clkout1_n),
    .dataout1_p(dataout1_p),
    .dataout1_n(dataout1_n),
    .ref_50M_clk(ref_50M_clk),
    .sample_clk(sample_clk),
    .start_sample(start_sample),
    .stop_sample(stop_sample),
    .data_in(data_in)
  );
endmodule
