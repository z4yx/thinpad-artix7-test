module packet_decoder (
    input wire clk,    // Clock
    input wire rst_n,  // Asynchronous reset active low

    input wire[27:0] rxd,
    output wire[5:0] packet_type,
    output wire[47:0] payload,
    output reg valid
);

reg[27:0] packet_buf0, packet_buf1;
always @(posedge clk or negedge rst_n) begin : proc_packet
    if(~rst_n) begin
        packet_buf0 <= 0;
        packet_buf1 <= 0;
        valid <= 0;
    end else begin
        valid <= rxd[27];
        if(rxd[27])
            packet_buf1 <= rxd;
        else
            packet_buf0 <= rxd;
    end
end
assign {packet_type[5:3], payload[47:24]} = packet_buf0;
assign {packet_type[2:0], payload[23:0]} = packet_buf1;

endmodule