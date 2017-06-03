module uncompress_pipeline (
/*autoport*/
//output
            zip_out,
            bitset_out,
            unzip_out,
//input
            clk,
            rst_n,
            zip_in,
            bitset_in,
            unzip_in);
parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;
parameter integer INDEX = 0;

input wire clk;    // Clock
input wire rst_n;  // Asynchronous reset active low

input wire [CHANNEL*DATA_BITS-1:0] zip_in;
input wire [CHANNEL-1:0] bitset_in;
input wire [CHANNEL*DATA_BITS-1:0] unzip_in;

output reg [CHANNEL*DATA_BITS-1:0] zip_out;
output reg [CHANNEL-1:0] bitset_out;
output reg [CHANNEL*DATA_BITS-1:0] unzip_out;

always @(posedge clk or negedge rst_n) begin : proc_bitset_out
    if(~rst_n) begin
        bitset_out <= 0;
    end else begin
        bitset_out <= bitset_in;
        unzip_out <= unzip_in;
        if(bitset_in[INDEX])begin 
            unzip_out[INDEX*DATA_BITS +: DATA_BITS] <= zip_in[DATA_BITS-1:0];
            zip_out <= zip_in >> DATA_BITS;
        end else begin 
            zip_out <= zip_in;
        end
    end
end

endmodule