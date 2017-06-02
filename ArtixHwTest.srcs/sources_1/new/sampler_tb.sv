`timescale 1ps/1ps
module sample_tb ();

parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;

reg clk = 0, clk_ser = 0, clk200 = 0;
reg rst_n = 0;
reg[DATA_BITS*CHANNEL-1:0] data_in;
reg[CHANNEL-1:0] chn_mask;
wire        clkout1_p ;
wire        clkout1_n ;
wire    [3:0]   dataout1_p ;
wire    [3:0]   dataout1_n ;
wire        clkin1_p ;
wire        clkin1_n ;
wire    [3:0]   datain1_p ;
wire    [3:0]   datain1_n ;
reg step_btn = 0;
reg match;

wire[DATA_BITS*CHANNEL-1:0] comparison_data;
wire[DATA_BITS*CHANNEL-1:0] received_data;
wire                        received_update;
wire rx_pixel_clk;

always #50000 clk = ~clk; //20MHz

always #4348 clk_ser = ~clk_ser; //115MHz

always #2500 clk200 = ~clk200; //200MHz

initial begin 
    repeat(5) @(negedge clk);
    rst_n = 1;
end

initial begin 
    wait(rst_n==1'b1);
    repeat(100)@(negedge clk);
    step_btn = 1;
    @(negedge clk);
    step_btn = 0;
end

integer i;
always @(posedge clk or negedge rst_n) begin : proc_data_in
    if(~rst_n) begin
        chn_mask <= 0;
        data_in <= 0;
    end else begin
        if($random() < 1000)
            chn_mask <= 0;
        else
            chn_mask <= $random();
        for(i=0;i<CHANNEL;i=i+1) begin 
            if(chn_mask[i])
                data_in[i*DATA_BITS +: DATA_BITS] <= $random();
        end
    end
end

sampler la(
    .sample_clk    (clk),
    .txmit_ref_clk(clk_ser),
    .clkout1_p (clkout1_p),
    .clkout1_n (clkout1_n),
    .dataout1_p(dataout1_p),
    .dataout1_n(dataout1_n),
    .start_sample  (step_btn),
    .stop_sample  (0),
    .data_in       (data_in)
);

//skew on PCB
assign #1000 clkin1_p=clkout1_p;
assign #1000 clkin1_n=clkout1_n;
assign #1100 datain1_p[0]=dataout1_p[0];
assign #1100 datain1_n[0]=dataout1_n[0];
assign #1200 datain1_p[1]=dataout1_p[1];
assign #1200 datain1_n[1]=dataout1_n[1];
assign #800 datain1_p[2]=dataout1_p[2];
assign #800 datain1_n[2]=dataout1_n[2];
assign #700 datain1_p[3]=dataout1_p[3];
assign #700 datain1_n[3]=dataout1_n[3];

la_receiver recv(
    .reset            (~rst_n),
    .refclkin         (clk200),
    .clkin1_p           (clkin1_p),
    .clkin1_n           (clkin1_n),    
    .datain1_p          (datain1_p),   
    .datain1_n          (datain1_n),
    .rx_pixel_clk     (rx_pixel_clk),
    .raw_signal_result(received_data),
    .raw_signal_update(received_update)
);

fifo_for_tb test_data_store(
  .rst(~rst_n),
  .wr_clk(clk),
  .rd_clk(rx_pixel_clk),
  .din(data_in),
  .wr_en(la.running),
  .rd_en(received_update), //read ack
  .dout(comparison_data),
  .full(),
  .empty()
);

always_ff @(posedge rx_pixel_clk or negedge rst_n) begin : proc_match
    if(~rst_n) begin
        match <= 0;
    end else if(received_update) begin
        match <= comparison_data == received_data;
    end
end

endmodule
