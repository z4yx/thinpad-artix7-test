module la_receiver (
/*autoport*/
//output
            acq_data_out,
            acq_data_valid,
            raw_signal_result,
            raw_signal_update,
            lock_level,
            rx_pixel_clk,
//input
            reset,
            refclkin,
            clkin1_p,
            clkin1_n,
            datain1_p,
            datain1_n);

parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;

input wire      reset;
input wire      refclkin;               // Reference clock for input delay control
input wire      clkin1_p,  clkin1_n;            // lvds channel 1 clock input
input wire[3:0] datain1_p, datain1_n;  

output wire[47:0] acq_data_out;
output wire acq_data_valid;

output wire[CHANNEL*DATA_BITS-1:0] raw_signal_result;
output wire raw_signal_update;

output wire[2:0]  lock_level;
output wire rx_pixel_clk;

wire[27:0] rxd1;
wire rst_n;
wire[5:0] acq_packet_type;

serdes_7to1_ddr_rx_top rx(                  
    .reset              (reset),
    .refclkin           (refclkin),
    .clkin1_p           (clkin1_p),
    .clkin1_n           (clkin1_n),    
    .datain1_p          (datain1_p),   
    .datain1_n          (datain1_n),   
    .rxd1        (rxd1),
    .rx_pixel_clk(rx_pixel_clk),
    .lock_clk (lock_level[0]),
    .lock_ps  (lock_level[1]),
    .lock_bs  (lock_level[2]));

rstctrl #(.CHAIN_LEN(16)) rx_reset(
    .clk      (rx_pixel_clk),
    .rst_in_n (lock_level[2]),
    .rst_out_n(rst_n));

packet_decoder decode(
    .clk        (rx_pixel_clk),
    .rst_n      (rst_n),
    .rxd        (rxd1),
    .packet_type(acq_packet_type),
    .payload    (acq_data_out),
    .valid      (acq_data_valid)
);

interpreter #(.CHANNEL(CHANNEL),.DATA_BITS(DATA_BITS)) data_interpreter(
    .clk        (rx_pixel_clk),
    .rst_n      (rst_n),
    .packet_type(acq_packet_type),
    .payload_valid(acq_data_valid),
    .payload    (acq_data_out),
    .data_update_out(raw_signal_update),
    .data_out   (raw_signal_result)
);

endmodule