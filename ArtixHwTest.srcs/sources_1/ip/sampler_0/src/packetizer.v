module packetizer (
//output
            out_data,
//input
            sample_clk,
            tx_clock,
            tx_clock_rst_n,
            begin_of_sample,
            data_compressed,
            diff_bitset,
            sample_running);

`define PACKET_T_IDLE 6'h2a
`define PACKET_T_NOP 6'h00
`define PACKET_T_FIRST 6'h11
`define PACKET_T_NEXT  6'h22
`define PACKET_T_LAST  6'h33

parameter integer CHANNEL = 16;
parameter integer DATA_BITS = 16;

input wire sample_clk;    // Clock
input wire tx_clock;
input wire tx_clock_rst_n;
input wire begin_of_sample;  // Asynchronous reset active high
input wire[DATA_BITS*CHANNEL-1:0] data_compressed;
input wire[CHANNEL-1:0] diff_bitset;
input wire sample_running;

output reg[27:0] out_data;

reg wr_en_hold;
wire rd_en;
wire rd_empty, rd_valid;
wire[DATA_BITS*CHANNEL-1:0] data_from_fifo;
wire[CHANNEL-1:0] diff_from_fifo;

always @(posedge sample_clk or posedge begin_of_sample) begin : proc_wr_en_hold
    if(begin_of_sample) begin
        wr_en_hold <= 0;
    end else if(~sample_running) begin
        wr_en_hold <= 0;
    end else if(sample_running && (&diff_bitset)) begin //keyframe found
        wr_en_hold <= 1;
    end
end


sample_fifo_0 sample_fifo(
    .rst(begin_of_sample),
    .wr_clk(sample_clk),
    .rd_clk(tx_clock),
    .din({data_compressed, diff_bitset}),
    .wr_en(sample_running & (wr_en_hold | (&diff_bitset))),
    .rd_en(rd_en),
    .dout({data_from_fifo, diff_from_fifo}),
    .full(),
    .valid(rd_valid),
    .almost_empty(rd_empty)
);

wire[$clog2(CHANNEL):0] diff_bit_cnt;
bit_counter counter(
    .data (diff_from_fifo),
    .count(diff_bit_cnt)
);

reg rd_valid_dly1;
reg[DATA_BITS*CHANNEL-1:0] data_dly1;
reg[CHANNEL-1:0] diff_dly1;
reg[$clog2(CHANNEL):0] diff_bit_cnt_dly1;

always @(posedge tx_clock or negedge tx_clock_rst_n) begin : proc_rd_dly1
    if(~tx_clock_rst_n) begin
        rd_valid_dly1 <= 0;
    end else if(rd_en) begin
        rd_valid_dly1 <= rd_valid;
        diff_bit_cnt_dly1 <= diff_bit_cnt;
        data_dly1 <= data_from_fifo;
        diff_dly1 <= diff_from_fifo;
    end
end

reg [16*3-1:0] payload;
reg [5:0] packet_type;
reg packet_available;
reg [2:0] packet_state;
reg[DATA_BITS*CHANNEL-1:0] data_remain;
reg[$clog2(CHANNEL):0] diff_bit_cnt_remain;

assign rd_en = (packet_state==1 && (~rd_valid_dly1 || diff_bit_cnt_dly1<=2))
            ||(packet_state==2 && diff_bit_cnt_remain <= 3);
always @(posedge tx_clock or negedge tx_clock_rst_n) begin : proc_packet_state
    if(~tx_clock_rst_n) begin
        packet_state <= 1;
        packet_available <= 0;
    end else begin
        case (packet_state)
            1: begin 
                packet_available <= rd_valid_dly1;
                payload <= {data_dly1[31:0], diff_dly1};
                if(~rd_valid_dly1)begin 

                end else if(diff_bit_cnt_dly1 > 2)begin //following packet required
                    packet_type <= `PACKET_T_FIRST;
                    packet_state <= 2;
                    diff_bit_cnt_remain <= diff_bit_cnt_dly1-2;
                    data_remain <= data_dly1>>2*DATA_BITS;
                end else begin //only one packet
                    packet_type <= `PACKET_T_LAST;
                end
            end
            2: begin 
                packet_available <= 1;
                payload <= data_remain[47:0];
                if(diff_bit_cnt_remain > 3)begin //following packet required
                    packet_type <= `PACKET_T_NEXT;
                    packet_state <= 2;
                    diff_bit_cnt_remain <= diff_bit_cnt_remain-3;
                    data_remain <= data_remain>>3*DATA_BITS;
                end else begin // the last packet
                    packet_type <= `PACKET_T_LAST;
                    packet_state <= 1;
                end

            end
        endcase
    end
end


wire [28*2-1:0] packet_out;
wire packet_fifo_empty;
wire [28*2-1:0] packet;

assign packet = {1'b0, packet_type[5:3], payload[47:24],
                1'b1, packet_type[2:0], payload[23:0]};

reg[2:0] tx_state;
reg nop_packet,idle_packet;
reg sample_running_sync,sample_running_txclk;

always @(posedge tx_clock or negedge tx_clock_rst_n) begin
    if(~tx_clock_rst_n)begin
        sample_running_txclk = 0;
        sample_running_sync <= 0;
    end else begin
        sample_running_sync <= sample_running;
        sample_running_txclk <= sample_running_sync;
    end
end

txmit_fifo txmit_fifo_inst(
    .rst(begin_of_sample),
    .clk(tx_clock),
    .din(packet),
    .wr_en(packet_available),
    .rd_en(tx_state==3'h2),
    .dout(packet_out),
    .full(),
    .empty(packet_fifo_empty)
);

always @(posedge tx_clock or negedge tx_clock_rst_n) begin
    if(~tx_clock_rst_n)begin 
        tx_state <= 3'h2;
        nop_packet <= 1;
        idle_packet <= 1;
    end
    else
    case (tx_state)
        3'h1: begin 
            tx_state <= 3'h2;
        end    
        3'h2: begin 
            tx_state <= 3'h1;
            idle_packet <= ~sample_running_txclk;
            nop_packet <= packet_fifo_empty;
        end
    endcase
end

wire [5:0] nop_type,idle_type;
assign nop_type = `PACKET_T_NOP;
assign idle_type = `PACKET_T_IDLE;
always@(*)begin 
    if(idle_packet)begin 
        if(tx_state == 3'h2)
            out_data <= {1'b1, idle_type[2:0], 24'haaaaaa};
        else
            out_data <= {1'b0, idle_type[5:3], 24'h555555};
    end else if(nop_packet)begin 
        if(tx_state == 3'h2)
            out_data <= {1'b1, nop_type[2:0], 24'h010101};
        else
            out_data <= {1'b0, nop_type[5:3], 24'h101010};
    end else begin 
        if(tx_state == 3'h2)
            out_data <= packet_out[27:0];
        else
            out_data <= packet_out[55:28];
    end
end

endmodule

module bit_counter (
    count,data
);
parameter integer CHANNEL = 16;

input wire [CHANNEL-1:0] data;
output reg [$clog2(CHANNEL):0] count;
integer i;

always @(*) begin : proc_count
    count = 0;
    for (i = 0; i < CHANNEL; i=i+1) begin
        count = count + data[i];
    end
end

endmodule