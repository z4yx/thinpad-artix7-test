`timescale 1ps/1ps
module sample_tb ();

parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;

reg clk = 0, clk_ser = 0;
reg rst_n = 0;
reg[DATA_BITS*CHANNEL-1:0] data_in;
reg[CHANNEL-1:0] chn_mask;
wire        clkout1_p ;
wire        clkout1_n ;
wire    [3:0]   dataout1_p ;
wire    [3:0]   dataout1_n ;
reg step_btn = 0;

always #50000 clk = ~clk; //20MHz

always #4348 clk_ser = ~clk_ser; //115MHz

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
        data_in<= 0;
    end else begin
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

// reg[DATA_BITS*CHANNEL-1:0] data_uncompressed;
// reg[DATA_BITS*CHANNEL-1:0] tmp;
// reg correct;
// integer j;
// always @(posedge clk or negedge rst_n) begin 
//     if(~rst_n) begin
//         data_uncompressed = 0;
//         correct = 0;
//     end else begin 
//         tmp = data_compressed;
//         for (j = CHANNEL-1; j >= 0; j=j-1) begin
//             if(bitmap_diff[j])begin
//                 data_uncompressed[DATA_BITS*j +: DATA_BITS] = tmp[DATA_BITS-1:0];
//                 tmp = tmp >> DATA_BITS;
//             end
//         end
//         correct = (data_uncompressed==data_original);
//     end
// end

endmodule
