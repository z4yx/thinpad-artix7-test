module sram_fill(
    input wire clk,
    input wire rst_n,

    inout wire[31:0] ram_data,  // SRAM 数据
    output wire[19:0] ram_addr, // SRAM 地址
    output reg[3:0] ram_be_n,  // SRAM 字节使能，低有效。如果不使用字节使能，请保持为0
    output reg ram_ce_n,       // SRAM 片选，低有效
    output reg ram_oe_n,       // SRAM 读使能，低有效
    output reg ram_we_n,       // SRAM 写使能，低有效

    output wire done
);

reg [31:0] wdata;
reg [20:0] addr_cnt;
reg [2:0] state;

assign ram_data = ram_oe_n ? wdata : 32'bz;
assign ram_addr = addr_cnt[0+:20];
assign done = addr_cnt[20];

always @(posedge clk, posedge rst_n) begin : lfsr
    if(~rst_n) begin
        wdata <= 32'h19260817;
    end else if(~done) begin
        wdata <= {wdata[0]^wdata[10]^wdata[30]^wdata[31], wdata[1+:31]};
    end
end

always @(posedge clk, posedge rst_n) begin
    if(~rst_n) begin
        addr_cnt <= 21'h0;
        state <= 3'h0;
        ram_be_n <= 4'h0;
        ram_ce_n <= 1'b0;
        ram_oe_n <= 1'b1;
        ram_we_n <= 1'b1;
    end else if(~done) begin
        case(state)
        3'h0: begin
            state <= 3'h1;
            ram_we_n <= 1'b0;
        end
        3'h1: begin
            state <= 3'h2;
            ram_we_n <= 1'b1;
        end
        3'h2: begin
            state <= 3'h0;
            addr_cnt <= addr_cnt+1;
        end
        endcase
    end
end

endmodule
