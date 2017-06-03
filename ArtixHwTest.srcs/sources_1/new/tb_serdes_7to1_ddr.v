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

always #(10000) pixelclock_p = ~pixelclock_p ; //50MHz

initial
begin
reset = 1'b1 ;
#150000
reset = 1'b0;
end

/*'walking one' Data generation for testing, user logic will go here*/
reg[22:0] prbs;
reg[27:0] txd1;
wire tx_pixel_clk, tx_pixel_clk_rst_n;
always @ (posedge tx_pixel_clk or negedge tx_pixel_clk_rst_n) begin
    if (tx_pixel_clk_rst_n == 1'b0) begin
        prbs <= 23'b1;
        txd1 <= {5'h12,prbs} ;
    end else begin
        prbs <= {prbs[21:0],prbs[22]^prbs[17]};
        txd1 <= {5'h12,prbs} ;
    end 
end

serdes_7to1_ddr_tx_top tx(
    .clkint             (pixelclock_p),  
    .reset              (reset),
    .txd1              (txd1),
    .tx_pixel_clk      (tx_pixel_clk),
    .tx_pixel_clk_rst_n(tx_pixel_clk_rst_n),
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
    .datain1_n          (dataout1_n)) ;

assign match = rx.dummy;

endmodule


