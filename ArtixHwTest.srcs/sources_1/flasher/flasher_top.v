`default_nettype none
module flasher_top (/*autoport*/
//inout
      gpio1,
      ext_ram_data,
      flash_data,
      rxd,
//output
      gpio0,
      ext_ram_addr,
      ext_ram_be_n,
      ext_ram_ce_n,
      ext_ram_oe_n,
      ext_ram_we_n,
      flash_address,
      flash_rp_n,
      flash_vpen,
      flash_oe_n,
      flash_ce_n,
      flash_byte_n,
      flash_we_n,
      txd,
//input
      clk);
input wire clk;
// input wire rst;

inout wire [31:0] gpio1;
output reg [31:0] gpio0;

input wire rxd;
output wire txd;
assign txd = rxd;

inout wire[31:0] ext_ram_data;
(* IOB = "true" *) reg [31:0]ext_ram_data_o, ext_ram_data_i, ext_ram_data_t;
(* IOB = "true" *) output reg[19:0] ext_ram_addr;
(* IOB = "true" *) output reg[3:0] ext_ram_be_n;
(* IOB = "true" *) output reg ext_ram_ce_n = 1'b1;
(* IOB = "true" *) output reg ext_ram_oe_n = 1'b1;
(* IOB = "true" *) output reg ext_ram_we_n = 1'b1;

/*
inout wire[31:0] base_ram_data;
output wire[19:0] base_ram_addr;
output wire[3:0] base_ram_be_n;
output wire base_ram_ce_n;
output wire base_ram_oe_n;
output wire base_ram_we_n;
*/

(* IOB = "true" *) output reg [21:0]flash_address;
inout wire [15:0]flash_data;
(* IOB = "true" *) reg [15:0]flash_data_o, flash_data_i, flash_data_t;
output wire flash_rp_n;
output wire flash_vpen;
(* IOB = "true" *) output reg flash_oe_n = 1;
(* IOB = "true" *) output reg flash_ce_n = 1;
output wire flash_byte_n;
(* IOB = "true" *) output reg flash_we_n = 1;

wire sysclk, pll_locked;
reg sysrst, sysrst_pipe;
reg [3:0] rst_cnt;

wire we_i_n;
wire oe_i_n;
wire ale_i;
wire [23:0] ad_i,ad_t,ad_o;

(*mark_debug="true"*) wire [22:0] internal_addr;
(*mark_debug="true"*) wire [15:0] internal_data_i,internal_data_o,internal_data_t;
(*mark_debug="true"*) wire we_o_n, oe_o_n;
wire higher_bank = internal_addr[0];

assign we_i_n = gpio1[31];
assign oe_i_n = gpio1[30];
assign ale_i = gpio1[29];

always @(posedge sysclk) begin : proc_extram
  begin
    ext_ram_data_o <= {internal_data_o,internal_data_o};
    ext_ram_data_i <= ext_ram_data;
    ext_ram_data_t <= {internal_data_t,internal_data_t};
    ext_ram_addr <= internal_addr[1 +: 20];
    ext_ram_ce_n <= internal_addr[22];
    //ext_ram_ce_n <= internal_addr[22] | ~internal_addr[21]; //active low, be careful
    ext_ram_be_n <= {~higher_bank,~higher_bank,higher_bank,higher_bank};
    ext_ram_oe_n <= oe_o_n;
    ext_ram_we_n <= we_o_n;
  end
end

/*
assign base_ram_addr = internal_addr[1 +: 20];
assign base_ram_ce_n = internal_addr[22] | internal_addr[21]; //active low, be careful
assign base_ram_be_n = {~higher_bank,~higher_bank,higher_bank,higher_bank};
assign base_ram_oe_n = oe_o_n;
assign base_ram_we_n = we_o_n;
*/

always @(posedge sysclk) begin : proc_flash
  begin
    flash_address <= internal_addr[0 +: 22];
    flash_data_o <= internal_data_o;
    flash_data_i <= flash_data;
    flash_data_t <= internal_data_t;
    flash_ce_n <= ~internal_addr[22];
    flash_oe_n <= oe_o_n;
    flash_we_n <= we_o_n;
  end
end

assign flash_rp_n = ~sysrst;
assign flash_byte_n = 1'b1;
assign flash_vpen = 1'b1;

assign internal_data_i = internal_addr[22] ? flash_data_i :
                        internal_addr[0] ? ext_ram_data_i[16 +: 16] :
                        ext_ram_data_i[0 +: 16];

genvar i;
generate
    for (i = 0; i < 24; i=i+1) begin : gen_ad
        assign gpio1[i] = ad_t[i] ? 1'bz : ad_o[i];
        assign ad_i[i] = gpio1[i];
    end
    for (i = 0; i < 16; i=i+1) begin : gen_dat
        assign ext_ram_data[i] = ext_ram_data_t[i] ? 1'bz : ext_ram_data_o[i];
        assign ext_ram_data[i+16] = ext_ram_data_t[i+16] ? 1'bz : ext_ram_data_o[i+16];
        assign flash_data[i] = flash_data_t[i] ? 1'bz : flash_data_o[i];
    end
endgenerate

always @(posedge sysclk or negedge pll_locked) begin : proc_rst_cnt
  if(~pll_locked) begin
    rst_cnt <= 0;
    sysrst <= 1;
    sysrst_pipe <= 1;
  end else begin
    rst_cnt <= (&rst_cnt) ? rst_cnt : rst_cnt+1;
    sysrst_pipe <= ~(&rst_cnt);
    sysrst <= sysrst_pipe;
  end
end

flasher_clk pll(
    .clk_in1(clk),
    .clk_out1(sysclk),
    .locked(pll_locked)
);

bridge host_bridge(
    .rst   (sysrst),
    .we_i_n(we_i_n),
    .oe_i_n(oe_i_n),
    .ale_i (ale_i),
    .ad_i  (ad_i),
    .ad_o  (ad_o),
    .ad_t  (ad_t),
    .we_o_n(we_o_n),
    .oe_o_n(oe_o_n),
    .addr_o(internal_addr),
    .data_i(internal_data_i),
    .data_o(internal_data_o),
    .data_t(internal_data_t),
    .clk   (sysclk)
);

always @(posedge sysclk) begin : proc_gpio0
  if(~pll_locked) begin
    gpio0 <= 0;
  end else begin
    gpio0 <= internal_addr;
  end
end

endmodule
`default_nettype wire
