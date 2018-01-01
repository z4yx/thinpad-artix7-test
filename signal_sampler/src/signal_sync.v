module signal_sync (
    clk,
    data_in,
    data_out
);

parameter DATA_WIDTH = 1;
parameter SYNC_CYCLE = 1;

input wire clk;
input wire [DATA_WIDTH-1:0] data_in;
output wire [DATA_WIDTH-1:0] data_out;

reg [DATA_WIDTH-1:0] data_buf[0:SYNC_CYCLE-1];

assign data_out = data_buf[SYNC_CYCLE-1];

integer i;
always @(posedge clk) begin : proc_sync
    begin
        for (i = 0; i < SYNC_CYCLE-1; i=i+1) begin : loop
            data_buf[i+1] <= data_buf[i];
        end
        data_buf[0] <= data_in;
    end
end

endmodule
