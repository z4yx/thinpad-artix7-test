module transition_det (
    clk,
    rst_n,
    data_in,
    data_out,
    changed,
    changing
);

parameter DATA_WIDTH = 1;

input wire clk;
input wire rst_n;
input wire [DATA_WIDTH-1:0] data_in;
output reg [DATA_WIDTH-1:0] data_out;
output reg changed;
output reg changing;

reg [DATA_WIDTH-1:0] data_buf[0:1];

always @(posedge clk or negedge rst_n) begin : proc_changed
    if(~rst_n) begin
        changed <= 0;
        changing <= 0;
        data_out <= data_in;
        data_buf[1] <= data_in;
        data_buf[0] <= data_in;
    end else begin
        data_out <= data_buf[1];
        data_buf[1] <= data_buf[0];
        data_buf[0] <= data_in;
        changing <= (data_buf[1] != data_buf[0]);
        changed <= changing;
    end
end

endmodule