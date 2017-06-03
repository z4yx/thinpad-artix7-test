-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
-- Date        : Sun Jun  4 00:10:02 2017
-- Host        : skyworks running 64-bit Ubuntu 16.04.2 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/skyworks/ArtixHwTest/ArtixHwTest.srcs/sources_1/ip/la_receiver_0/la_receiver_0_stub.vhdl
-- Design      : la_receiver_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg676-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity la_receiver_0 is
  Port ( 
    acq_data_out : out STD_LOGIC_VECTOR ( 47 downto 0 );
    acq_data_valid : out STD_LOGIC;
    raw_signal_result : out STD_LOGIC_VECTOR ( 255 downto 0 );
    raw_signal_update : out STD_LOGIC;
    lock_level : out STD_LOGIC_VECTOR ( 2 downto 0 );
    rx_pixel_clk : out STD_LOGIC;
    reset : in STD_LOGIC;
    refclkin : in STD_LOGIC;
    clkin1_p : in STD_LOGIC;
    clkin1_n : in STD_LOGIC;
    datain1_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
    datain1_n : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );

end la_receiver_0;

architecture stub of la_receiver_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "acq_data_out[47:0],acq_data_valid,raw_signal_result[255:0],raw_signal_update,lock_level[2:0],rx_pixel_clk,reset,refclkin,clkin1_p,clkin1_n,datain1_p[3:0],datain1_n[3:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "la_receiver,Vivado 2016.4";
begin
end;
