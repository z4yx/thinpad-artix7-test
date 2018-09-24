`default_nettype none
module bridge (/*autoport*/
//output
         ad_o,
         ad_t,
         we_o_n,
         oe_o_n,
         addr_o,
         data_o,
         data_t,
//input
         clk,
         rst,
         we_i_n,
         oe_i_n,
         ale_i,
         ad_i,
         data_i);
input wire clk;
input wire rst;

input wire we_i_n;
input wire oe_i_n;
input wire ale_i;
input wire [23:0] ad_i;
output reg [23:0] ad_o;
output reg [23:0] ad_t;

output reg we_o_n = 1;
output reg oe_o_n = 1;
output reg [22:0] addr_o;
input wire [15:0] data_i;
output reg [15:0] data_o;
output reg [15:0] data_t;

(*mark_debug="true"*) wire ale_i_sync, we_sync, oe_sync;
(*mark_debug="true"*) wire [23:0] ad_sync;
reg [23:0] ad_last;

signal_sync #(.DATA_WIDTH(24)) s_ad(
    .clk     (clk),
    .data_in (ad_i),
    .data_out(ad_sync));

signal_sync s_we(
    .clk     (clk),
    .data_in (we_i_n),
    .data_out(we_sync));

signal_sync s_oe(
    .clk     (clk),
    .data_in (oe_i_n),
    .data_out(oe_sync));

signal_sync s_ale(
    .clk     (clk),
    .data_in (ale_i),
    .data_out(ale_i_sync));

reg addr_inc, we_last, oe_last, ale_last;
reg we_fall, oe_fall;
reg we_rise, oe_rise;
reg [22:0] addr_temp;

always @(*) begin : proc_trans
    we_fall <= we_last & ~we_sync;
    oe_fall <= oe_last & ~oe_sync;
    we_rise <= ~we_last & we_sync;
    oe_rise <= ~oe_last & oe_sync;
end

always @(posedge clk) begin : proc_last
    if(rst) begin
        oe_last <= 1;
        we_last <= 1;
        ale_last <= 1;
        ad_last <= 0;
    end else begin
        oe_last <= oe_sync;
        we_last <= we_sync;
        ale_last <= ale_i_sync;
        ad_last <= ad_sync;
    end
end

always @(posedge clk) begin : proc_addr
    if(rst) begin
        addr_inc <= 0;
        addr_temp <= 0;
    end else if(ale_last && we_rise) begin
        addr_temp <= ad_last[22:0];
        addr_inc <= ad_last[23];
    end else if(~ale_last && addr_inc && (we_rise || oe_rise))begin 
        addr_temp <= addr_temp + 1;
    end
end

always @(posedge clk) begin : proc_ctl
    if(rst) begin
        we_o_n <= 1;
        oe_o_n <= 1;
    end else begin
        we_o_n <= we_sync | ale_i_sync;
        oe_o_n <= oe_sync;
    end
end

always @(posedge clk) begin : proc_data
    data_o <= ad_sync[15:0];
    ad_o <= data_i;
    addr_o <= addr_temp;
end

integer i;
reg [15:0] data_t_dly;
always @(posedge clk) begin : proc_t
    if(rst) begin
        for (i = 0; i < 16; i=i+1) begin
            data_t[i] <= 1;
            data_t_dly[i] <= 1;
        end
        for (i = 0; i < 24; i=i+1) begin
            ad_t[i] <= 1;
        end
    end else begin
        for (i = 0; i < 16; i=i+1) begin
            ad_t[i] <= oe_sync | ~we_sync; //ADt=(OEn==1 || WEn==0)
        end
        for (i = 0; i < 24; i=i+1) begin
            data_t_dly[i] <= ~oe_sync | we_sync;
            data_t[i] <= data_t_dly[i];
        end
    end
end

endmodule
`default_nettype wire
