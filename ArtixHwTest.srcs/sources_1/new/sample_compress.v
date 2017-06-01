module sample_compress (
/*autoport*/
//output
            data_compressed,
            diff_bitset,
            data_original,
//input
            clk,
            rst_n,
            data_in);

parameter integer CHANNEL = 8;
parameter integer DATA_BITS = 16;

input wire clk;    // Clock
input wire rst_n;  // Asynchronous reset active low
// input wire keyframe;
input wire[DATA_BITS*CHANNEL-1:0] data_in;
output wire[DATA_BITS*CHANNEL-1:0] data_compressed;
output wire[CHANNEL-1:0] diff_bitset;
output wire[DATA_BITS*CHANNEL-1:0] data_original;

wire[DATA_BITS*CHANNEL-1:0] data_pipeline[0:CHANNEL], data_reduced_pipeline[0:CHANNEL];
wire[CHANNEL-1:0] diff_pipeline[0:CHANNEL];


reg keyframe_next;
reg[DATA_BITS*CHANNEL-1:0] data_store;
reg[CHANNEL-1:0] data_diff;
wire[CHANNEL-1:0] const0 = 0;
wire[CHANNEL-1:0] cmp_result;

always @(posedge clk or negedge rst_n) begin : proc_kf
    if(~rst_n) begin
        keyframe_next <= 1;
    // end else if(keyframe) begin
    //     keyframe_next <= 1;
    end else begin 
        keyframe_next <= 0;
    end
end

genvar j;
generate
    for (j = 0; j < CHANNEL; j=j+1) begin
        assign cmp_result[j] = 
            data_in[DATA_BITS*(j+1)-1:DATA_BITS*j] != data_store[DATA_BITS*(j+1)-1:DATA_BITS*j];
    end
endgenerate

always @(posedge clk or negedge rst_n) begin : proc_cmp
    if(~rst_n) begin
        data_diff <= 0;
    end else if(keyframe_next) begin
        data_diff <= ~const0;
    end else begin 
        data_diff <= cmp_result;
    end
end

always @(posedge clk) begin
    data_store <= data_in;
end

assign data_pipeline[0] = data_store;
assign data_reduced_pipeline[0] = 0;
assign diff_pipeline[0] = data_diff;

genvar i;
generate

    for (i = 0; i < CHANNEL; i=i+1) begin : gen_reduce
        data_reduction #(
            .OFFSET(i),
            .DATA_BITS(DATA_BITS),
            .CHANNEL(CHANNEL)
        )
        reduce(
            .clk           (clk),
            .rst_n         (rst_n),
            .data_diff_in   (diff_pipeline[i]),
            .data_diff_out  (diff_pipeline[i+1]),
            .data_in         (data_pipeline[i]),
            .data_out        (data_pipeline[i+1]),
            .data_reduced_in (data_reduced_pipeline[i]),
            .data_reduced_out(data_reduced_pipeline[i+1])
        );
    end
endgenerate

assign data_compressed = data_reduced_pipeline[CHANNEL];
assign diff_bitset = diff_pipeline[CHANNEL];
assign data_original = data_pipeline[CHANNEL];

endmodule

module data_reduction (
    /*autoport*/
    clk,    // Clock
    rst_n,  // Asynchronous reset active low
    
    data_diff_in,
    data_diff_out,
    data_in,
    data_out,
    data_reduced_in,
    data_reduced_out
);

parameter integer CHANNEL = 8;
parameter integer DATA_BITS = 16;
parameter integer OFFSET = 0;

input wire clk;
input wire rst_n;
input wire[CHANNEL-1:0] data_diff_in;
input wire[DATA_BITS*CHANNEL-1:0] data_in;
input wire[DATA_BITS*CHANNEL-1:0] data_reduced_in;
output reg[CHANNEL-1:0] data_diff_out;
output reg[DATA_BITS*CHANNEL-1:0] data_out;
output reg[DATA_BITS*CHANNEL-1:0] data_reduced_out;

always @(posedge clk or negedge rst_n) begin : proc_reduce
    if(~rst_n)
    begin 
        data_diff_out <= 0;
        data_out <= 0;
        data_reduced_out <= 0;
    end
    else
    begin
        data_diff_out <= data_diff_in;
        data_out <= data_in;
        if(data_diff_in[OFFSET])begin 
            data_reduced_out <= {data_reduced_in[DATA_BITS*(CHANNEL-1)-1:0], data_in[(OFFSET+1)*DATA_BITS-1:OFFSET*DATA_BITS]};
        end else begin 
            data_reduced_out <= data_reduced_in;
        end
    end
end


endmodule
