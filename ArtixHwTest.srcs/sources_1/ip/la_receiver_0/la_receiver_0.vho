-- (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: user.org:user:la_receiver:1.4
-- IP Revision: 5

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT la_receiver_0
  PORT (
    acq_data_out : OUT STD_LOGIC_VECTOR(50 DOWNTO 0);
    acq_data_valid : OUT STD_LOGIC;
    raw_signal_result : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    raw_signal_update : OUT STD_LOGIC;
    lock_level : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    rx_pixel_clk : OUT STD_LOGIC;
    sampler_idle : OUT STD_LOGIC;
    reset : IN STD_LOGIC;
    refclkin : IN STD_LOGIC;
    clkin1_p : IN STD_LOGIC;
    clkin1_n : IN STD_LOGIC;
    datain1_p : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    datain1_n : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : la_receiver_0
  PORT MAP (
    acq_data_out => acq_data_out,
    acq_data_valid => acq_data_valid,
    raw_signal_result => raw_signal_result,
    raw_signal_update => raw_signal_update,
    lock_level => lock_level,
    rx_pixel_clk => rx_pixel_clk,
    sampler_idle => sampler_idle,
    reset => reset,
    refclkin => refclkin,
    clkin1_p => clkin1_p,
    clkin1_n => clkin1_n,
    datain1_p => datain1_p,
    datain1_n => datain1_n
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

