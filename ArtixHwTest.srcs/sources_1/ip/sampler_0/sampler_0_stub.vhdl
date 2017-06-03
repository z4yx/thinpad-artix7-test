-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
-- Date        : Sat Jun  3 23:56:27 2017
-- Host        : skyworks running 64-bit Ubuntu 16.04.2 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/skyworks/ArtixHwTest/ArtixHwTest.srcs/sources_1/ip/sampler_0/sampler_0_stub.vhdl
-- Design      : sampler_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg676-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sampler_0 is
  Port ( 
    clkout1_p : out STD_LOGIC;
    clkout1_n : out STD_LOGIC;
    dataout1_p : out STD_LOGIC_VECTOR ( 3 downto 0 );
    dataout1_n : out STD_LOGIC_VECTOR ( 3 downto 0 );
    txmit_ref_clk : in STD_LOGIC;
    sample_clk : in STD_LOGIC;
    start_sample : in STD_LOGIC;
    stop_sample : in STD_LOGIC;
    data_in : in STD_LOGIC_VECTOR ( 255 downto 0 )
  );

end sampler_0;

architecture stub of sampler_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clkout1_p,clkout1_n,dataout1_p[3:0],dataout1_n[3:0],txmit_ref_clk,sample_clk,start_sample,stop_sample,data_in[255:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "sampler,Vivado 2016.4";
begin
end;
