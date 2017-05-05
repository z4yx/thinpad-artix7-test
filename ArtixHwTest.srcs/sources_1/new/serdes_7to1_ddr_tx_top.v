
`timescale 1ps/1ps

module serdes_7to1_ddr_tx_top (
input       clkint,          // pixel rate frequency generator clock input
input       reset,                  // reset (active high)
output      clkout1_p,  clkout1_n,          // lvds channel 1 clock output
output  [3:0]   dataout1_p, dataout1_n         // lvds channel 1 data outputs
) ;

// Parameters 

parameter integer     D = 4 ;
parameter integer     N = 1 ;
parameter real   CLKIN_PERIOD = 6.6;

// Parameter for clock generation

parameter [6:0] TX_CLK_GEN   = 7'b1100001 ;     // Transmit a constant to make a 3:4 clock, two ticks in advance of bit0 of the data word
//parameter [6:0] TX_CLK_GEN   = 7'b1100011 ;       // OR Transmit a constant to make a 4:3 clock, two ticks in advance of bit0 of the data word
                
reg     [D*7-1:0]  txd1 ;              
wire        tx_pixel_clk ;      
wire        tx_bufpll_lckd ;        
wire        tx_bufg_pll_x1 ;        
wire        txclk ;         
wire        txclk_div ;         
wire        not_tx_mmcm_lckd ;  
wire    [N-1:0]   clkout_p ;      
wire    [N-1:0]   clkout_n ;      
wire    [N*D-1:0]   dataout_p ;     
wire    [N*D-1:0]   dataout_n ;     
wire        tx_mmcm_lckd ;
    
// Clock Input

clock_generator_pll_7_to_1_diff_ddr #(
    .DIFF_TERM      ("TRUE"),
    .PIXEL_CLOCK        ("BUF_G"),
    .INTER_CLOCK        ("BUF_G"),
    .TX_CLOCK       ("BUF_G"),
    .USE_PLL        ("FALSE"),
    .MMCM_MODE      (1),                // Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
    .CLKIN_PERIOD       (CLKIN_PERIOD))
clkgen (                        
    .reset          (reset),
    .clkint         (clkint),
    .txclk          (txclk),
    .txclk_div      (txclk_div),
    .pixel_clk      (tx_pixel_clk),
    .status         (),
    .mmcm_lckd      (tx_mmcm_lckd)) ;

assign not_tx_mmcm_lckd = ~tx_mmcm_lckd ;

// Transmitter Logic for N D-bit channels

n_x_serdes_7_to_1_diff_ddr #(
    .D          (D),
    .N          (N),             
    .DATA_FORMAT        ("PER_CLOCK"))          // PER_CLOCK or PER_CHANL data formatting
dataout (                      
    .dataout_p          (dataout_p),
    .dataout_n          (dataout_n),
    .clkout_p       (clkout_p),
    .clkout_n       (clkout_n),
    .txclk          (txclk),
    .txclk_div          (txclk_div),
    .pixel_clk      (tx_pixel_clk),
    .reset          (not_tx_mmcm_lckd),
    .clk_pattern        (TX_CLK_GEN),           // Transmit a constant to make the clock
    .datain         (txdata));

// assign data to appropriate outputs

assign dataout1_p = dataout_p[D-1:0] ;    assign dataout1_n = dataout_n[D-1:0] ;
assign clkout1_p = clkout_p[0] ;    assign clkout1_n = clkout_n[0] ;
                                    

// 'walking one' Data generation for testing, user logic will go here

always @ (posedge tx_pixel_clk) begin
    if (tx_mmcm_lckd == 1'b0) begin
        txd1 <= 28'b00000000000000000000000000000000001 ;
    end else begin
        txd1 <= {txd1[26:0], txd1[27]} ;
    end 
end
        
endmodule
