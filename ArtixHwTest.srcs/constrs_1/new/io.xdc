create_clock -period 20.000 -name clk -add [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN D18 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports rst_in]
set_property PACKAGE_PIN F22 [get_ports rst_in]
set_property IOSTANDARD LVCMOS33 [get_ports txd]
set_property IOSTANDARD LVCMOS33 [get_ports rxd]
set_property PACKAGE_PIN L19 [get_ports txd]
set_property PACKAGE_PIN K21 [get_ports rxd]

set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {step_btn[0]}]
set_property -dict {PACKAGE_PIN E25 IOSTANDARD LVCMOS33} [get_ports {step_btn[1]}]
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS33} [get_ports {step_btn[2]}]
set_property -dict {PACKAGE_PIN E23 IOSTANDARD LVCMOS33} [get_ports {step_btn[3]}]

set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports step_clk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets step_clk_IBUF]

set_property -dict {PACKAGE_PIN L8 IOSTANDARD LVCMOS33} [get_ports uart_wrn]
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports uart_rdn]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports uart_tbre]
set_property -dict {PACKAGE_PIN L7 IOSTANDARD LVCMOS33} [get_ports uart_tsre]
set_property -dict {PACKAGE_PIN L4 IOSTANDARD LVCMOS33} [get_ports uart_dataready]

#SERDES
set_property -dict {PACKAGE_PIN P20 IOSTANDARD TMDS_33} [get_ports clkout1_p]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD TMDS_33} [get_ports clkout1_n]
set_property -dict {PACKAGE_PIN K22 IOSTANDARD TMDS_33} [get_ports {dataout1_p[0]}]
set_property -dict {PACKAGE_PIN K23 IOSTANDARD TMDS_33} [get_ports {dataout1_n[0]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD TMDS_33} [get_ports {dataout1_p[1]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD TMDS_33} [get_ports {dataout1_n[1]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD TMDS_33} [get_ports {dataout1_p[2]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD TMDS_33} [get_ports {dataout1_n[2]}]
set_property -dict {PACKAGE_PIN J24 IOSTANDARD TMDS_33} [get_ports {dataout1_p[3]}]
set_property -dict {PACKAGE_PIN H24 IOSTANDARD TMDS_33} [get_ports {dataout1_n[3]}]

#Digital Video
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports video_clk]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {video_pixel[7]}]
set_property -dict {PACKAGE_PIN N21 IOSTANDARD LVCMOS33} [get_ports {video_pixel[6]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports {video_pixel[5]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {video_pixel[4]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {video_pixel[3]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {video_pixel[2]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {video_pixel[1]}]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {video_pixel[0]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports video_hsync]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports video_vsync]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports video_de]


set_property -dict {PACKAGE_PIN F24 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[0]}]
set_property -dict {PACKAGE_PIN G24 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[1]}]
set_property -dict {PACKAGE_PIN L24 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[2]}]
set_property -dict {PACKAGE_PIN L23 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[3]}]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[4]}]
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[5]}]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[6]}]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[7]}]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[8]}]
set_property -dict {PACKAGE_PIN H23 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[9]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[10]}]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[11]}]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[12]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[13]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[14]}]
set_property -dict {PACKAGE_PIN M24 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[15]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[16]}]
set_property -dict {PACKAGE_PIN N23 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[17]}]
set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[18]}]
set_property -dict {PACKAGE_PIN P23 IOSTANDARD LVCMOS33} [get_ports {base_ram_addr[19]}]
set_property -dict {PACKAGE_PIN M26 IOSTANDARD LVCMOS33} [get_ports {base_ram_be_n[0]}]
set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS33} [get_ports {base_ram_be_n[1]}]
set_property -dict {PACKAGE_PIN D26 IOSTANDARD LVCMOS33} [get_ports {base_ram_be_n[2]}]
set_property -dict {PACKAGE_PIN D25 IOSTANDARD LVCMOS33} [get_ports {base_ram_be_n[3]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[0]}]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[1]}]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[2]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[3]}]
set_property -dict {PACKAGE_PIN M25 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[4]}]
set_property -dict {PACKAGE_PIN N26 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[5]}]
set_property -dict {PACKAGE_PIN P26 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[6]}]
set_property -dict {PACKAGE_PIN P25 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[7]}]
set_property -dict {PACKAGE_PIN J23 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[8]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[9]}]
set_property -dict {PACKAGE_PIN E26 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[10]}]
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[11]}]
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[12]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[13]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[14]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[15]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[16]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[17]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[18]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[19]}]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[20]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[21]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[22]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[23]}]
set_property -dict {PACKAGE_PIN K26 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[24]}]
set_property -dict {PACKAGE_PIN K25 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[25]}]
set_property -dict {PACKAGE_PIN J26 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[26]}]
set_property -dict {PACKAGE_PIN J25 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[27]}]
set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[28]}]
set_property -dict {PACKAGE_PIN G26 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[29]}]
set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[30]}]
set_property -dict {PACKAGE_PIN F25 IOSTANDARD LVCMOS33} [get_ports {base_ram_data[31]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports base_ram_ce_n]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports base_ram_oe_n]
set_property -dict {PACKAGE_PIN P24 IOSTANDARD LVCMOS33} [get_ports base_ram_we_n]

#LEDS
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[0]}]
set_property PACKAGE_PIN A17 [get_ports {gpio0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[1]}]
set_property PACKAGE_PIN G16 [get_ports {gpio0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[2]}]
set_property PACKAGE_PIN E16 [get_ports {gpio0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[3]}]
set_property PACKAGE_PIN H17 [get_ports {gpio0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[4]}]
set_property PACKAGE_PIN G17 [get_ports {gpio0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[5]}]
set_property PACKAGE_PIN F18 [get_ports {gpio0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[6]}]
set_property PACKAGE_PIN F19 [get_ports {gpio0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[7]}]
set_property PACKAGE_PIN F20 [get_ports {gpio0[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[8]}]
set_property PACKAGE_PIN C17 [get_ports {gpio0[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[9]}]
set_property PACKAGE_PIN F17 [get_ports {gpio0[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[10]}]
set_property PACKAGE_PIN B17 [get_ports {gpio0[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[11]}]
set_property PACKAGE_PIN D19 [get_ports {gpio0[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[12]}]
set_property PACKAGE_PIN A18 [get_ports {gpio0[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[13]}]
set_property PACKAGE_PIN A19 [get_ports {gpio0[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[14]}]
set_property PACKAGE_PIN E17 [get_ports {gpio0[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[15]}]
set_property PACKAGE_PIN E18 [get_ports {gpio0[15]}]

#DPY0
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[16]}]
set_property PACKAGE_PIN D16 [get_ports {gpio0[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[17]}]
set_property PACKAGE_PIN F15 [get_ports {gpio0[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[18]}]
set_property PACKAGE_PIN H15 [get_ports {gpio0[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[19]}]
set_property PACKAGE_PIN G15 [get_ports {gpio0[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[20]}]
set_property PACKAGE_PIN H16 [get_ports {gpio0[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[21]}]
set_property PACKAGE_PIN H14 [get_ports {gpio0[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[22]}]
set_property PACKAGE_PIN G19 [get_ports {gpio0[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[23]}]
set_property PACKAGE_PIN J8 [get_ports {gpio0[23]}]

#DPY2
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[24]}]
set_property PACKAGE_PIN H9 [get_ports {gpio0[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[25]}]
set_property PACKAGE_PIN G8 [get_ports {gpio0[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[26]}]
set_property PACKAGE_PIN G7 [get_ports {gpio0[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[27]}]
set_property PACKAGE_PIN G6 [get_ports {gpio0[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[28]}]
set_property PACKAGE_PIN D6 [get_ports {gpio0[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[29]}]
set_property PACKAGE_PIN E5 [get_ports {gpio0[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[30]}]
set_property PACKAGE_PIN F4 [get_ports {gpio0[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio0[31]}]
set_property PACKAGE_PIN G5 [get_ports {gpio0[31]}]

#DIP_SW
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[0]}]
set_property PACKAGE_PIN N3 [get_ports {gpio1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[1]}]
set_property PACKAGE_PIN N4 [get_ports {gpio1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[2]}]
set_property PACKAGE_PIN P3 [get_ports {gpio1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[3]}]
set_property PACKAGE_PIN P4 [get_ports {gpio1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[4]}]
set_property PACKAGE_PIN R5 [get_ports {gpio1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[5]}]
set_property PACKAGE_PIN T7 [get_ports {gpio1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[6]}]
set_property PACKAGE_PIN R8 [get_ports {gpio1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[7]}]
set_property PACKAGE_PIN T8 [get_ports {gpio1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[8]}]
set_property PACKAGE_PIN N2 [get_ports {gpio1[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[9]}]
set_property PACKAGE_PIN N1 [get_ports {gpio1[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[10]}]
set_property PACKAGE_PIN P1 [get_ports {gpio1[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[11]}]
set_property PACKAGE_PIN R2 [get_ports {gpio1[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[12]}]
set_property PACKAGE_PIN R1 [get_ports {gpio1[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[13]}]
set_property PACKAGE_PIN T2 [get_ports {gpio1[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[14]}]
set_property PACKAGE_PIN U1 [get_ports {gpio1[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[15]}]
set_property PACKAGE_PIN U2 [get_ports {gpio1[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[16]}]
set_property PACKAGE_PIN U6 [get_ports {gpio1[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[17]}]
set_property PACKAGE_PIN R6 [get_ports {gpio1[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[18]}]
set_property PACKAGE_PIN U5 [get_ports {gpio1[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[19]}]
set_property PACKAGE_PIN T5 [get_ports {gpio1[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[20]}]
set_property PACKAGE_PIN U4 [get_ports {gpio1[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[21]}]
set_property PACKAGE_PIN T4 [get_ports {gpio1[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[22]}]
set_property PACKAGE_PIN T3 [get_ports {gpio1[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[23]}]
set_property PACKAGE_PIN R3 [get_ports {gpio1[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[24]}]
set_property PACKAGE_PIN P5 [get_ports {gpio1[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[25]}]
set_property PACKAGE_PIN P6 [get_ports {gpio1[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[26]}]
set_property PACKAGE_PIN P8 [get_ports {gpio1[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[27]}]
set_property PACKAGE_PIN N8 [get_ports {gpio1[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[28]}]
set_property PACKAGE_PIN N6 [get_ports {gpio1[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[29]}]
set_property PACKAGE_PIN N7 [get_ports {gpio1[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[30]}]
set_property PACKAGE_PIN M7 [get_ports {gpio1[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio1[31]}]
set_property PACKAGE_PIN M5 [get_ports {gpio1[31]}]


set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[0]}]
set_property PACKAGE_PIN C26 [get_ports {flash_address[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[1]}]
set_property PACKAGE_PIN B26 [get_ports {flash_address[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[2]}]
set_property PACKAGE_PIN B25 [get_ports {flash_address[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[3]}]
set_property PACKAGE_PIN A25 [get_ports {flash_address[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[4]}]
set_property PACKAGE_PIN D24 [get_ports {flash_address[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[5]}]
set_property PACKAGE_PIN C24 [get_ports {flash_address[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[6]}]
set_property PACKAGE_PIN B24 [get_ports {flash_address[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[7]}]
set_property PACKAGE_PIN A24 [get_ports {flash_address[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[8]}]
set_property PACKAGE_PIN C23 [get_ports {flash_address[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[9]}]
set_property PACKAGE_PIN D23 [get_ports {flash_address[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[10]}]
set_property PACKAGE_PIN A23 [get_ports {flash_address[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[11]}]
set_property PACKAGE_PIN C21 [get_ports {flash_address[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[12]}]
set_property PACKAGE_PIN B21 [get_ports {flash_address[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[13]}]
set_property PACKAGE_PIN E22 [get_ports {flash_address[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[14]}]
set_property PACKAGE_PIN E21 [get_ports {flash_address[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[15]}]
set_property PACKAGE_PIN E20 [get_ports {flash_address[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[16]}]
set_property PACKAGE_PIN D21 [get_ports {flash_address[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[17]}]
set_property PACKAGE_PIN B20 [get_ports {flash_address[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[18]}]
set_property PACKAGE_PIN D20 [get_ports {flash_address[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[19]}]
set_property PACKAGE_PIN B19 [get_ports {flash_address[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[20]}]
set_property PACKAGE_PIN C19 [get_ports {flash_address[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_address[21]}]
set_property PACKAGE_PIN A20 [get_ports {flash_address[21]}]

set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[0]}]
set_property PACKAGE_PIN F8 [get_ports {flash_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[1]}]
set_property PACKAGE_PIN E6 [get_ports {flash_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[2]}]
set_property PACKAGE_PIN B5 [get_ports {flash_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[3]}]
set_property PACKAGE_PIN A4 [get_ports {flash_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[4]}]
set_property PACKAGE_PIN A3 [get_ports {flash_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[5]}]
set_property PACKAGE_PIN B2 [get_ports {flash_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[6]}]
set_property PACKAGE_PIN C2 [get_ports {flash_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[7]}]
set_property PACKAGE_PIN F2 [get_ports {flash_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[8]}]
set_property PACKAGE_PIN F7 [get_ports {flash_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[9]}]
set_property PACKAGE_PIN A5 [get_ports {flash_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[10]}]
set_property PACKAGE_PIN D5 [get_ports {flash_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[11]}]
set_property PACKAGE_PIN B4 [get_ports {flash_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[12]}]
set_property PACKAGE_PIN A2 [get_ports {flash_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[13]}]
set_property PACKAGE_PIN B1 [get_ports {flash_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[14]}]
set_property PACKAGE_PIN G2 [get_ports {flash_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[15]}]
set_property PACKAGE_PIN E1 [get_ports {flash_data[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports flash_byte_n]
set_property PACKAGE_PIN G9 [get_ports flash_byte_n]
set_property IOSTANDARD LVCMOS33 [get_ports flash_ce_n]
set_property PACKAGE_PIN A22 [get_ports flash_ce_n]
set_property IOSTANDARD LVCMOS33 [get_ports flash_oe_n]
set_property PACKAGE_PIN D1 [get_ports flash_oe_n]
set_property IOSTANDARD LVCMOS33 [get_ports flash_rp_n]
set_property PACKAGE_PIN C22 [get_ports flash_rp_n]
set_property IOSTANDARD LVCMOS33 [get_ports flash_vpen]
set_property PACKAGE_PIN B22 [get_ports flash_vpen]
set_property IOSTANDARD LVCMOS33 [get_ports flash_we_n]
set_property PACKAGE_PIN C1 [get_ports flash_we_n]

set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[0]}]
set_property PACKAGE_PIN Y21 [get_ports {ext_ram_addr[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[1]}]
set_property PACKAGE_PIN Y26 [get_ports {ext_ram_addr[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[2]}]
set_property PACKAGE_PIN AA25 [get_ports {ext_ram_addr[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[3]}]
set_property PACKAGE_PIN Y22 [get_ports {ext_ram_addr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[4]}]
set_property PACKAGE_PIN Y23 [get_ports {ext_ram_addr[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[5]}]
set_property PACKAGE_PIN T18 [get_ports {ext_ram_addr[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[6]}]
set_property PACKAGE_PIN T23 [get_ports {ext_ram_addr[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[7]}]
set_property PACKAGE_PIN T24 [get_ports {ext_ram_addr[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[8]}]
set_property PACKAGE_PIN U19 [get_ports {ext_ram_addr[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[9]}]
set_property PACKAGE_PIN V24 [get_ports {ext_ram_addr[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[10]}]
set_property PACKAGE_PIN W26 [get_ports {ext_ram_addr[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[11]}]
set_property PACKAGE_PIN W24 [get_ports {ext_ram_addr[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[12]}]
set_property PACKAGE_PIN Y25 [get_ports {ext_ram_addr[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[13]}]
set_property PACKAGE_PIN W23 [get_ports {ext_ram_addr[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[14]}]
set_property PACKAGE_PIN W21 [get_ports {ext_ram_addr[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[15]}]
set_property PACKAGE_PIN V14 [get_ports {ext_ram_addr[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[16]}]
set_property PACKAGE_PIN U14 [get_ports {ext_ram_addr[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[17]}]
set_property PACKAGE_PIN T14 [get_ports {ext_ram_addr[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[18]}]
set_property PACKAGE_PIN U15 [get_ports {ext_ram_addr[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[19]}]
set_property PACKAGE_PIN T15 [get_ports {ext_ram_addr[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_be_n[0]}]
set_property PACKAGE_PIN U26 [get_ports {ext_ram_be_n[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_be_n[1]}]
set_property PACKAGE_PIN T25 [get_ports {ext_ram_be_n[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_be_n[2]}]
set_property PACKAGE_PIN R17 [get_ports {ext_ram_be_n[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_be_n[3]}]
set_property PACKAGE_PIN R21 [get_ports {ext_ram_be_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[0]}]
set_property PACKAGE_PIN W20 [get_ports {ext_ram_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[1]}]
set_property PACKAGE_PIN W19 [get_ports {ext_ram_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[2]}]
set_property PACKAGE_PIN V19 [get_ports {ext_ram_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[3]}]
set_property PACKAGE_PIN W18 [get_ports {ext_ram_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[4]}]
set_property PACKAGE_PIN V18 [get_ports {ext_ram_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[5]}]
set_property PACKAGE_PIN T17 [get_ports {ext_ram_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[6]}]
set_property PACKAGE_PIN V16 [get_ports {ext_ram_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[7]}]
set_property PACKAGE_PIN V17 [get_ports {ext_ram_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[8]}]
set_property PACKAGE_PIN V22 [get_ports {ext_ram_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[9]}]
set_property PACKAGE_PIN W25 [get_ports {ext_ram_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[10]}]
set_property PACKAGE_PIN V23 [get_ports {ext_ram_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[11]}]
set_property PACKAGE_PIN V21 [get_ports {ext_ram_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[12]}]
set_property PACKAGE_PIN U22 [get_ports {ext_ram_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[13]}]
set_property PACKAGE_PIN V26 [get_ports {ext_ram_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[14]}]
set_property PACKAGE_PIN U21 [get_ports {ext_ram_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[15]}]
set_property PACKAGE_PIN U25 [get_ports {ext_ram_data[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[16]}]
set_property PACKAGE_PIN AC24 [get_ports {ext_ram_data[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[17]}]
set_property PACKAGE_PIN AC26 [get_ports {ext_ram_data[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[18]}]
set_property PACKAGE_PIN AB25 [get_ports {ext_ram_data[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[19]}]
set_property PACKAGE_PIN AB24 [get_ports {ext_ram_data[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[20]}]
set_property PACKAGE_PIN AA22 [get_ports {ext_ram_data[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[21]}]
set_property PACKAGE_PIN AA24 [get_ports {ext_ram_data[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[22]}]
set_property PACKAGE_PIN AB26 [get_ports {ext_ram_data[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[23]}]
set_property PACKAGE_PIN AA23 [get_ports {ext_ram_data[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[24]}]
set_property PACKAGE_PIN R25 [get_ports {ext_ram_data[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[25]}]
set_property PACKAGE_PIN R23 [get_ports {ext_ram_data[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[26]}]
set_property PACKAGE_PIN R26 [get_ports {ext_ram_data[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[27]}]
set_property PACKAGE_PIN U20 [get_ports {ext_ram_data[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[28]}]
set_property PACKAGE_PIN T22 [get_ports {ext_ram_data[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[29]}]
set_property PACKAGE_PIN R22 [get_ports {ext_ram_data[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[30]}]
set_property PACKAGE_PIN T20 [get_ports {ext_ram_data[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[31]}]
set_property PACKAGE_PIN R14 [get_ports {ext_ram_data[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports ext_ram_ce_n]
set_property PACKAGE_PIN Y20 [get_ports ext_ram_ce_n]
set_property IOSTANDARD LVCMOS33 [get_ports ext_ram_oe_n]
set_property PACKAGE_PIN U24 [get_ports ext_ram_oe_n]
set_property IOSTANDARD LVCMOS33 [get_ports ext_ram_we_n]
set_property PACKAGE_PIN U16 [get_ports ext_ram_we_n]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
# set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list pll_inst/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list sample_uart_dataready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list sample_uart_rdn]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list sample_uart_tbre]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list sample_uart_tsre]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list sample_uart_wrn]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_test]
