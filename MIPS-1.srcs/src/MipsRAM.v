`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * MIPS RAM
 *
 * input:
 *      mode: 00: 读四个字节；
 *            10：读两个字节；
 *            01：读一个字节
 * 
 */
module MipsRAM(addr, din, mode, we, clk, rst, dout, mem_signed_ext);
    parameter   ADDR_WIDTH = `ADDR_WIDTH;
    parameter   DATA_NUM = 128;

    input[ADDR_WIDTH-1:0]addr;
    input[31:0]     din;
    input[1:0]      mode;
    input           we, clk, rst, mem_signed_ext;

    output[31:0]    dout;

    (* rom_style = "block" *)reg[7:0]    ram[DATA_NUM-1:0];
    wire[7:0]   ext_data;
    integer i;
    
    assign  ext_data    = mem_signed_ext ? {8{ram[addr][7]}} : 8'b0;
    assign  dout[7:0]   = ram[addr + ((mode == 2'b00) ? 'd3 : ((mode == 2'b10) ? 'd1 : 'd0))];
    assign  dout[15:8]  = (mode == 2'b01) ? ext_data : ram[addr + ((mode == 2'b00) ? 'd2 : 'd0)];
    assign  dout[23:16] = (mode == 2'b01 || mode == 2'b10) ? ext_data : ram[addr + 'd1];
    assign  dout[31:24] = (mode == 2'b00) ? ram[addr] : ext_data;

    initial
        begin
            for (i = 0; i < 32; i = i + 1)
                begin
                    ram[i] = 'b0;
                end
        end

    always @(negedge clk)
        begin
            if (rst)
                begin
                    for (i = 0; i <= DATA_NUM - 'b1; i = i + 'b1)
                        ram[i] = 'b0;
                end
            else if (we)
                begin
                    case (mode)
                        2'b00:
                            begin
                                ram[addr]       = din[31:24];
                                ram[addr + 'd1] = din[23:16];
                                ram[addr + 'd2] = din[15:8];
                                ram[addr + 'd3] = din[7:0];
                            end
                        2'b01:
                            begin
                                ram[addr]       = din[7:0];
                            end
                        2'b10:
                            begin
                                ram[addr]       = din[15:8];
                                ram[addr + 'd1] = din[7:0];
                            end
                        default:
                            ;
                    endcase
                end
            else
                ;
        end

endmodule
