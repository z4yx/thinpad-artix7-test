module cleaner(
    input wire clk,

    //CPLD串口控制器信号
    output wire uart_rdn,         //读串口信号，低有效
    output wire uart_wrn,         //写串口信号，低有效
    input wire uart_dataready,    //串口数据准备好
    input wire uart_tbre,         //发送数据标志
    input wire uart_tsre,         //数据发送完毕标志

    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共享
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire base_ram_ce_n,       //BaseRAM片选，低有效
    output wire base_ram_oe_n,       //BaseRAM读使能，低有效
    output wire base_ram_we_n,       //BaseRAM写使能，低有效

    //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire ext_ram_ce_n,       //ExtRAM片选，低有效
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有效
    output wire ext_ram_we_n,       //ExtRAM写使能，低有效

    output wire flash_rp_n,         //Flash复位信号，低有效
    output wire sl811_rst_n,
    output wire dm9k_pwrst_n
);

reg [3:0] por;
reg reset_n;
reg [31:0] lfsr;
wire done;

always @(posedge clk) begin
    reset_n <= por == 4'h5;
    if (por != 4'h5) begin
        por <= por + 4'h1;
    end
end

always @(posedge clk, negedge reset_n) begin
    if(~reset_n) begin
        lfsr <= 32'h19260817;
    end else if(~done) begin
        lfsr <= {lfsr[0]^lfsr[10]^lfsr[30]^lfsr[31], lfsr[1+:31]};
    end
end

assign sl811_rst_n = 1'b0;
assign dm9k_pwrst_n = 1'b0;
assign flash_rp_n = 1'b0;

assign uart_rdn = reset_n; // clear the receive buffer
assign uart_wrn = 1'b1;

sram_fill u_base_fill (
    .clk         (clk),
    .rst_n       (reset_n),
    .lfsr        (lfsr),
    .ram_data    (base_ram_data),
    .ram_addr    (base_ram_addr),
    .ram_be_n    (base_ram_be_n),
    .ram_ce_n    (base_ram_ce_n),
    .ram_oe_n    (base_ram_oe_n),
    .ram_we_n    (base_ram_we_n),
    .done        (done)
);
sram_fill u_ext_fill (
    .clk         (clk),
    .rst_n       (reset_n),
    .lfsr        (lfsr),
    .ram_data    (ext_ram_data),
    .ram_addr    (ext_ram_addr),
    .ram_be_n    (ext_ram_be_n),
    .ram_ce_n    (ext_ram_ce_n),
    .ram_oe_n    (ext_ram_oe_n),
    .ram_we_n    (ext_ram_we_n),
    .done        ()
);

endmodule

