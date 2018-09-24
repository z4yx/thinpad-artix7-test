`default_nettype none
`timescale 1ns/100ps
module flasher_tb ();

reg clk_in = 0;

wire[31:0] ext_ram_data;
wire[19:0] ext_ram_address;
wire ext_ram_we_n;
wire ext_ram_oe_n;
wire ext_ram_ce_n;
wire[3:0] ext_ram_be_n;

wire[15:0] flash_data;
wire[21:0] flash_address;
wire flash_rp_n;
wire flash_vpen;
wire flash_oe_n;
wire flash_ce_n;
wire flash_byte_n;
wire flash_we_n;

wire[31:0] gpio1;

reg tb_oe_n=1, tb_we_n=1, tb_ale=0;
reg[23:0] tb_ad;
wire[23:0] tb_ad_i;

assign gpio1[31:29] = {tb_we_n,tb_oe_n,tb_ale};
assign gpio1[23:0] = tb_ad;
assign tb_ad_i = tb_ad;

always begin
    #10 clk_in = ~clk_in; //50MHz clock in
end

initial begin 
    @(posedge clk_in);
    wait(dut.sysrst == 0);
    #10;
    
    // write test
    tb_ale = 1;
    #40;
    tb_we_n = 0;
    #10 tb_ad = 24'h200010;
    #100 tb_we_n = 1;
    
    #100;

    tb_ale = 0;
    #40;
    tb_we_n = 0;
    #10 tb_ad = 16'hdead;
    #100 tb_we_n = 1;
    
    #100;

    // read test
    tb_oe_n = 0;
    #10 tb_ad = 24'hzzzzzz;
    #100 tb_oe_n = 1;
    
    #100;

    // continuous write test
    tb_ale = 1;
    tb_ad = 1<<23 | 24'h200011;
    tb_we_n = 0;
    #40 tb_we_n = 1;
    #40;

    tb_ale = 0;
    repeat(5)begin 
        #10;
        tb_ad[15:0] = $random();
        tb_we_n = 0;
        #40 tb_we_n = 1;
        #40;
    end
    
    // continuous read test
    tb_ale = 1;
    tb_ad = 1<<23 | 24'h200010;
    tb_we_n = 0;
    #40 tb_we_n = 1;
    #40;

    tb_ad = 24'hzzzzzz;
    tb_ale = 0;
    repeat(6)begin 
        tb_oe_n = 0;
        #40 tb_oe_n = 1;
        #40;
    end

    #100;

    // flash test
    tb_ale = 1;
    tb_ad = 24'h400000;
    tb_we_n = 0;
    #80 tb_we_n = 1;
    #80;

    tb_ale = 0;
    tb_ad = 16'h90;
    tb_we_n = 0;
    #80 tb_we_n = 1;
    #80;

    tb_ale = 1;
    tb_ad = 24'hC00000;
    tb_we_n = 0;
    #80 tb_we_n = 1;
    #80;

    tb_ale = 0;
    tb_ad = 24'hzzzzzz;
    tb_oe_n = 0;
    #80 tb_oe_n = 1;
    #80;

    tb_oe_n = 0;
    #80 tb_oe_n = 1;
    #80;
end

flasher_top dut(
           .ext_ram_data(ext_ram_data),
           .ext_ram_addr(ext_ram_address),
           .ext_ram_ce_n(ext_ram_ce_n),
           .ext_ram_oe_n(ext_ram_oe_n),
           .ext_ram_we_n(ext_ram_we_n),
           .ext_ram_be_n(ext_ram_be_n),
           .clk(clk_in),
           .flash_data(flash_data),
           .flash_address(flash_address),
           .flash_rp_n(flash_rp_n),
           .flash_vpen(flash_vpen),
           .flash_oe_n(flash_oe_n),
           .flash_ce_n(flash_ce_n),
           .flash_byte_n(flash_byte_n),
           .flash_we_n(flash_we_n),
           .gpio1(gpio1));

AS7C34098A ext1(/*autoinst*/
            .DataIO(ext_ram_data[15:0]),
            .Address(ext_ram_address[17:0]),
            .OE_n(ext_ram_oe_n),
            .CE_n(ext_ram_ce_n),
            .WE_n(ext_ram_we_n),
            .LB_n(ext_ram_be_n[0]),
            .UB_n(ext_ram_be_n[1]));
AS7C34098A ext2(/*autoinst*/
            .DataIO(ext_ram_data[31:16]),
            .Address(ext_ram_address[17:0]),
            .OE_n(ext_ram_oe_n),
            .CE_n(ext_ram_ce_n),
            .WE_n(ext_ram_we_n),
            .LB_n(ext_ram_be_n[2]),
            .UB_n(ext_ram_be_n[3]));
s29gl064n01 flash(
    .A21      (flash_address[21]),
    .A20      (flash_address[20]),
    .A19      (flash_address[19]),
    .A18      (flash_address[18]),
    .A17      (flash_address[17]),
    .A16      (flash_address[16]),
    .A15      (flash_address[15]),
    .A14      (flash_address[14]),
    .A13      (flash_address[13]),
    .A12      (flash_address[12]),
    .A11      (flash_address[11]),
    .A10      (flash_address[10]),
    .A9       (flash_address[9]),
    .A8       (flash_address[8]),
    .A7       (flash_address[7]),
    .A6       (flash_address[6]),
    .A5       (flash_address[5]),
    .A4       (flash_address[4]),
    .A3       (flash_address[3]),
    .A2       (flash_address[2]),
    .A1       (flash_address[1]),
    .A0       (flash_address[0]),

    .DQ15     (flash_data[15]),
    .DQ14     (flash_data[14]),
    .DQ13     (flash_data[13]),
    .DQ12     (flash_data[12]),
    .DQ11     (flash_data[11]),
    .DQ10     (flash_data[10]),
    .DQ9      (flash_data[9]),
    .DQ8      (flash_data[8]),
    .DQ7      (flash_data[7]),
    .DQ6      (flash_data[6]),
    .DQ5      (flash_data[5]),
    .DQ4      (flash_data[4]),
    .DQ3      (flash_data[3]),
    .DQ2      (flash_data[2]),
    .DQ1      (flash_data[1]),
    .DQ0      (flash_data[0]),

    .CENeg    (flash_ce_n),
    .OENeg    (flash_oe_n),
    .WENeg    (flash_we_n),
    .RESETNeg (flash_rp_n),
    .WPNeg    (flash_vpen),
    .BYTENeg  (flash_byte_n),
    .RY()
);

// defparam flash.UserPreload = 1'b1;
// defparam flash.mem_file_name = "flash_preload.mem";
defparam flash.TimingModel = "S29GL064N11TFIV2";

endmodule
`default_nettype wire