module sample_compress_tb ();

parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;

reg clk = 0;
reg rst_n = 0;
reg[DATA_BITS*CHANNEL-1:0] data_in;
reg[CHANNEL-1:0] chn_mask;
wire[DATA_BITS*CHANNEL-1:0] data_compressed, data_original;
wire[CHANNEL-1:0] bitmap_diff;

always #5 clk = ~clk;

initial begin 
    repeat(5) @(negedge clk);
    rst_n = 1;
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

sample_compress #(
    .CHANNEL(CHANNEL),
    .DATA_BITS(DATA_BITS)
)dut(
    .clk            (clk),
    .rst_n          (rst_n),
    .data_in        (data_in),
    .data_compressed(data_compressed),
    .diff_bitset    (bitmap_diff),
    .data_original  (data_original)
);

reg[DATA_BITS*CHANNEL-1:0] data_uncompressed;
reg[DATA_BITS*CHANNEL-1:0] tmp;
reg correct;
integer j;
always @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        data_uncompressed = 0;
        correct = 0;
    end else begin 
        tmp = data_compressed;
        for (j = CHANNEL-1; j >= 0; j=j-1) begin
            if(bitmap_diff[j])begin
                data_uncompressed[DATA_BITS*j +: DATA_BITS] = tmp[DATA_BITS-1:0];
                tmp = tmp >> DATA_BITS;
            end
        end
        correct = (data_uncompressed==data_original);
    end
end

endmodule
