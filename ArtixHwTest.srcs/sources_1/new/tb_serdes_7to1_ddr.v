`timescale 1 ps / 1ps

module tb_serdes_7to1_ddr () ;

reg         clk200 ;
reg         pixelclock_p ;
wire        clkout1_p ;
wire        clkout1_n ;
reg         reset ;
wire    [3:0]   dataout1_p ;
wire    [3:0]   dataout1_n ;
wire        match ;

initial clk200 = 0 ;
initial pixelclock_p = 0 ;

always #(2500) clk200 = ~clk200 ;

always #(5714) pixelclock_p = ~pixelclock_p ;

initial
begin
reset = 1'b1 ;
#150000
reset = 1'b0;
end

serdes_7to1_ddr_tx_top #(
    .CLKIN_PERIOD(11.428)
)tx(
    .clkint             (pixelclock_p),  
    .reset              (reset),
    .clkout1_p          (clkout1_p),  
    .clkout1_n          (clkout1_n),
    .dataout1_p         (dataout1_p), 
    .dataout1_n         (dataout1_n)) ;
                                        
serdes_7to1_ddr_rx_top rx(                  
    .reset              (reset),
    .refclkin           (clk200),
    .clkin1_p           (clkout1_p),
    .clkin1_n           (clkout1_n),    
    .datain1_p          (dataout1_p),   
    .datain1_n          (dataout1_n),   
    .dummy              (match)) ;

endmodule


