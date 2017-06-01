module sampler (
/*autoport*/
//output
            clkout1_p,
            clkout1_n,
            dataout1_p,
            dataout1_n,
//input
            txmit_ref_clk,
            sample_clk,
            start_sample,
            stop_sample,
            data_in);


parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;

input wire txmit_ref_clk;

input wire sample_clk;
input wire start_sample;
input wire stop_sample;
input wire[DATA_BITS*CHANNEL-1:0] data_in;

output wire        clkout1_p ;
output wire        clkout1_n ;
output wire    [3:0]   dataout1_p ;
output wire    [3:0]   dataout1_n ;

reg[2:0] state;
wire running, bos;
wire sample_clk_rstn;
wire[DATA_BITS*CHANNEL-1:0] data_compressed;
wire[CHANNEL-1:0] diff_bitset;

wire tx_clock;
wire tx_clock_rst_n;
wire[27:0] tx_data;

rstctrl ctrl(
    .clk      (sample_clk),
    .rst_in_n (tx_clock_rst_n),
    .rst_out_n(sample_clk_rstn)
);

sample_compress #(.CHANNEL(CHANNEL), .DATA_BITS(DATA_BITS))
compressor(
    .clk            (sample_clk),
    .rst_n          (running),
    .data_in        (data_in),
    .data_compressed(data_compressed),
    .diff_bitset    (diff_bitset)
);
      
packetizer packetizer_inst(
    .sample_clk     (sample_clk),
    .tx_clock       (tx_clock),
    .tx_clock_rst_n (tx_clock_rst_n),
    .begin_of_sample(bos),
    .data_compressed(data_compressed),
    .diff_bitset    (diff_bitset),
    .sample_running (running),
    .out_data       (tx_data)
);

serdes_7to1_ddr_tx_top #(
    .CLKIN_PERIOD(8.69565)
)tx(
    .clkint             (txmit_ref_clk),  
    .reset              (reset),
    .txd1              (tx_data),
    .tx_pixel_clk      (tx_clock), //output from module
    .tx_pixel_clk_rst_n(tx_clock_rst_n), //output from module
    .clkout1_p          (clkout1_p),  
    .clkout1_n          (clkout1_n),
    .dataout1_p         (dataout1_p), 
    .dataout1_n         (dataout1_n)) ;

assign running = (state == 2);
assign bos = (state == 1);

reg[10:0] init_wait_timer; //wait for 2048 cycles after start-up
reg init_timer_done,init_timer_hold;
(* ASYNC_REG = "TRUE" *) reg[1:0] init_timer_sync;

always @(posedge tx_clock or negedge tx_clock_rst_n) begin : proc_init_wait_timer
    if(~tx_clock_rst_n)begin
        init_wait_timer <= 0;
        init_timer_hold <= 0;
        init_timer_done <= 0;
    end else begin
        if(init_timer_done) init_timer_hold <= 1;
        init_timer_done <= &init_wait_timer;
        init_wait_timer <= init_wait_timer+1;
    end
end

always @(posedge sample_clk or negedge sample_clk_rstn) begin : proc_state
    if(~sample_clk_rstn) begin
        state <= 0;
        init_timer_sync <= 0;
    end else begin
        init_timer_sync <= {init_timer_sync[0], init_timer_hold};
        case (state)
            0: begin 
                if(start_sample)
                    state <= 1;
            end
            1: begin 
                if(stop_sample)
                    state <= 0;
                else if(init_timer_sync[1])
                    state <= 2;
            end
            2: begin 
                if(stop_sample)
                    state <= 0;
            end
            default : begin
                state <= 0;
            end 
        endcase
    end
end

endmodule