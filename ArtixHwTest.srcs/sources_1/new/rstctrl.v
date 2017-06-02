module rstctrl(/*autoport*/
//output
            rst_out_n,
//input
            clk,
            rst_in_n);

parameter integer CHAIN_LEN = 3;

input wire clk;
input wire rst_in_n;
output wire rst_out_n;

reg[CHAIN_LEN-1:0] shifter;
assign rst_out_n = shifter[CHAIN_LEN-1];
always @(posedge clk or negedge rst_in_n) begin
    if (!rst_in_n) begin
        shifter <= 0;
    end
    else begin
        shifter <= {shifter[CHAIN_LEN-2:0], 1'b1};
    end
end

endmodule