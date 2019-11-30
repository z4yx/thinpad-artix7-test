`timescale 1ps/1ps
module sample_tb ();

parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;

reg clk = 0, clk_ser = 0, clk200 = 0;
reg rst_n = 0;
reg[DATA_BITS*CHANNEL-1:0] data_in, data_in_last;
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
reg data_chang_en = 0;
reg match;

wire[DATA_BITS*CHANNEL-1:0] comparison_data;
wire[DATA_BITS*CHANNEL-1:0] received_data;
reg [DATA_BITS*CHANNEL-1:0] received_data_store;
wire                        received_update;
wire rx_pixel_clk;

always #50000 clk = ~clk; //20MHz

always #10000 clk_ser = ~clk_ser; //50MHz

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
    repeat(200)@(negedge clk);
    data_chang_en = 1;
end

integer i;
integer rand_lbits;
reg[CHANNEL-1:0] rand_mask;
always @(posedge clk or negedge rst_n) begin : proc_data_in
    if(~rst_n) begin
        chn_mask <= 0;
        data_in <= 0;
        data_in_last <= 0;
        rand_mask <= 0;
        rand_lbits <= 0;
    end else if(data_chang_en) begin
        rand_mask <= (1<<($urandom()%(CHANNEL+1)))-1;
        rand_lbits <= $urandom()%(CHANNEL-1)+1;
        chn_mask <= (rand_mask>>rand_lbits) | (rand_mask<<(CHANNEL - rand_lbits));
        data_in_last <= data_in;
        for(i=0;i<CHANNEL;i=i+1) begin 
            if(chn_mask[i])
                data_in[i*DATA_BITS +: DATA_BITS] <= $urandom();
        end
    end
end

sampler_0 la(
    .sample_clk    (clk),
    .ref_50M_clk(clk_ser),
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

la_receiver_0 recv(
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

wire data_changing = data_in != data_in_last;
wire recv_data_changing = received_update && received_data_store != received_data;

xpm_fifo_async #(
    .CDC_SYNC_STAGES(2),       // DECIMAL
    .FIFO_MEMORY_TYPE("auto"), // String
    .FIFO_READ_LATENCY(0),     // DECIMAL
    .FIFO_WRITE_DEPTH(256),   // DECIMAL
    .FULL_RESET_VALUE(0),      // DECIMAL
    .READ_DATA_WIDTH(256),      // DECIMAL
    .READ_MODE("fwft"),         // String
    .RELATED_CLOCKS(0),        // DECIMAL
    .USE_ADV_FEATURES("0000"), // String
    .WRITE_DATA_WIDTH(256)     // DECIMAL
) test_data_store (
    .dout(comparison_data),         // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                    // when reading the FIFO.
    .empty(),                       // 1-bit output: Empty Flag: When asserted, this signal indicates that the
                                    // FIFO is empty. Read requests are ignored when the FIFO is empty,
                                    // initiating a read while empty is not destructive to the FIFO.
    .full(),                        // 1-bit output: Full Flag: When asserted, this signal indicates that the
                                    // FIFO is full. Write requests are ignored when the FIFO is full,
                                    // initiating a write when the FIFO is full is not destructive to the
                                    // contents of the FIFO.
    .din(data_in),                  // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                    // writing the FIFO.
    .rd_clk(rx_pixel_clk),          // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
                                    // running clock.
    .rd_en(recv_data_changing),        // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                    // signal causes data (on dout) to be read from the FIFO. Must be held
                                    // active-low when rd_rst_busy is active high.
    .rst(~rst_n),                   // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                    // unstable at the time of applying reset, but reset must be released only
                                    // after the clock(s) is/are stable.
    .wr_clk(clk),                   // 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                    // free running clock.
    .wr_en(data_changing)         // 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                    // signal causes data (on din) to be written to the FIFO. Must be held
                                    // active-low when rst or wr_rst_busy is active high.
);

always_ff @(posedge rx_pixel_clk or negedge rst_n) begin
    if(~rst_n) begin
        match <= 0;
    end else if(recv_data_changing) begin
        match <= comparison_data == received_data;
    end
end

always_ff @(posedge rx_pixel_clk or negedge rst_n) begin : proc_match
    if(~rst_n) begin
        received_data_store <= 0;
    end else if(received_update) begin
        received_data_store <= received_data;
    end
end

endmodule
