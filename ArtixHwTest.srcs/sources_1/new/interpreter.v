module interpreter (
/*autoport*/
//output
            data_out,
            data_update_out,
//input
            clk,
            rst_n,
            packet_type,
            payload,
            payload_valid);

parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;
parameter integer NUM_BUF_BLOCKS = 6; //ceil((CHANNEL*DATA_BITS+CHANNEL)/48)

`define PACKET_T_NOP 6'h2a
`define PACKET_T_FIRST 6'h11
`define PACKET_T_NEXT  6'h22
`define PACKET_T_LAST  6'h33

input clk;    // Clock
input rst_n;  // Asynchronous reset active low
input wire[5:0] packet_type;
input wire[47:0] payload;
input wire payload_valid;
output reg[DATA_BITS*CHANNEL-1:0] data_out;
output reg data_update_out;

reg [47:0] payload_buf[0:NUM_BUF_BLOCKS-1];
reg [2:0]  buf_idx;
reg [12:0] nop_count;
reg update;

always @(posedge clk or negedge rst_n) begin : proc_payload_buf
    if(~rst_n) begin
        buf_idx <= 0;
        nop_count <= 0;
        update <= 0;
    end else begin
        update <= 0;
        if(payload_valid)
            case (packet_type)
                `PACKET_T_NOP: begin
                    nop_count <= nop_count+1;
                end
                `PACKET_T_FIRST,
                `PACKET_T_NEXT: begin 
                    buf_idx <= buf_idx+1;
                    payload_buf[buf_idx] <= payload;
                end
                `PACKET_T_LAST: begin 
                    payload_buf[buf_idx] <= payload;
                    update <= 1;
                    buf_idx <= 0;
                end
                default : /* default */;
            endcase
    end
end

integer i;
reg [CHANNEL*DATA_BITS-1:0] flat_buf;
reg [CHANNEL-1:0] bitset_buf;
wire [CHANNEL*DATA_BITS-1:0] zip_pipeline[0:CHANNEL];
wire [CHANNEL*DATA_BITS-1:0] unzip_pipeline[0:CHANNEL];
wire [CHANNEL-1:0] bitset_pipeline[0:CHANNEL];
reg update_pipeline[0:CHANNEL];
always @(posedge clk or negedge rst_n) begin : proc_flat_buf
    if(~rst_n) begin
        bitset_buf <= 0;
    end else begin
        bitset_buf <= payload_buf[0][15:0];
        update_pipeline[CHANNEL] <= update;
        for (i = 0; i < CHANNEL; i=i+1) begin
            update_pipeline[i] <= update_pipeline[i+1];
            flat_buf[i*DATA_BITS +: DATA_BITS] <= payload_buf[(i+1)/3][(i+1)%3*16 +: 16];
        end
    end
end

assign zip_pipeline[CHANNEL] = flat_buf;
assign bitset_pipeline[CHANNEL] = bitset_buf;
genvar j;
generate
    for (j = CHANNEL-1; j >= 0; j=j-1) begin : gen_unzip
        uncompress_pipeline
        #(  .CHANNEL(CHANNEL),
            .DATA_BITS(DATA_BITS),
            .INDEX(j))
        pipeline(
            .clk(clk),
            .rst_n(rst_n),
            .zip_in(zip_pipeline[j+1]),
            .zip_out(zip_pipeline[j]),
            .unzip_in(unzip_pipeline[j+1]),
            .unzip_out(unzip_pipeline[j]),
            .bitset_in(bitset_pipeline[j+1]),
            .bitset_out(bitset_pipeline[j])
        );
    end
endgenerate

integer k;
always @(posedge clk or negedge rst_n) begin : proc_data_out
    if(~rst_n) begin
        data_update_out <= 0;
    end else if(update_pipeline[0]) begin
        data_update_out <= 1;
        for (k = 0; k < CHANNEL; k=k+1) begin
            if(bitset_pipeline[0][k])
                data_out[k*DATA_BITS +: DATA_BITS] <= unzip_pipeline[0][k*DATA_BITS +: DATA_BITS];
        end
    end else begin 
        data_update_out <= 0;
    end
end

endmodule