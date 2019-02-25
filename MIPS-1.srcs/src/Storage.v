`timescale 1ns / 1ps
`include "MIPS-1.vh"

module Storage(addr, din, mode, we, clk, rst, dout, mem_signed_ext);
    input[`ADDR_WIDTH-1:0]   addr;
    input[31:0]     din;
    input[1:0]      mode;
    input           we, clk, rst, mem_signed_ext;

    output[31:0]dout;

    wire[3:0]    sel;
    wire    i_24, i_16, i_8, i_0;
    wire[31:0]  ram_out, ram_in, out;
    wire[`ADDR_WIDTH-1:0]   ram_addr;
    wire    sign;

    assign  i_24 = (mode == 2'b01 && addr[1] && addr[0]);
    assign  i_16 = (mode == 2'b01 && addr[1] && !addr[0]) || (mode == 2'b10 && addr[1]);
    assign  i_8  = (mode == 2'b01 && !addr[1] && addr[0]);
    assign  i_0  = (mode == 2'b01 && !addr[1] && !addr[0]) || (mode == 2'b00) || (mode == 2'b10 && !addr[1]);

    assign  sel[3] = (mode == 2'b00) || (mode == 2'b10 && addr[1]) || i_24;
    assign  sel[2] = (mode == 2'b00) || (mode == 2'b10 && addr[1]) || i_16;
    assign  sel[1] = (mode == 2'b00) || (mode == 2'b10 && !addr[1]) || i_8;
    assign  sel[0] = i_0;
    
    assign  sign = sel[3] ? ram_out[31] : (sel[2] ? ram_out[23] : (sel[1] ? ram_out[15] : ram_out[7]));

    assign  out[7:0]   = sel[0] ? ram_out[7:0]   : (mem_signed_ext ? 'b0 : 8'b0);
    assign  out[15:8]  = sel[1] ? ram_out[15:8]  : (mem_signed_ext ? 'b0 : 8'b0);
    assign  out[23:16] = sel[2] ? ram_out[23:16] : (mem_signed_ext ? 'b0 : 8'b0);
    assign  out[31:24] = sel[3] ? ram_out[31:24] : (mem_signed_ext ? 'b0 : 8'b0);

    assign  dout = i_24 ? ($signed(out) >> 24) : (i_16 ? ($signed(out) >> 16) : (i_8 ? ($signed(out) >> 8) : out));
    assign  ram_in = i_24 ? (din << 24) : (i_16 ? (din << 16) : (i_8 ? (din << 8) : din));

    RAM #(.ADDR_LEN(`ADDR_WIDTH),.DATA_LEN(32)) ram(
        .clk(clk),
        .rst(rst),
        .addr({addr[`ADDR_WIDTH-1:2], 2'b00}),
        .sel(sel),
        .read_en(1'b1),
        .write_en(we),
        .data_in(ram_in),
        .data_out(ram_out)
    );

endmodule
