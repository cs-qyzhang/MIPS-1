`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * 通用寄存器组
 *
 * input:
 *      clk:
 *      ra:
 *      rb:
 *      rw:
 *      we:
 *      din:
 *
 * output:
 *      R1:
 *      R2:
 */
module RegFile(clk,ra,rb,rw,we,din,R1,R2);
    input           clk, we;
    input[4:0]      ra, rb, rw;
    input[31:0]     din;
    output[31:0]    R1, R2;

    reg[31:0]       GPR[31:0];
    integer         i;

    assign  R1 = GPR[ra];
    assign  R2 = GPR[rb];

    initial
        begin
            for (i = 0; i < 32; i = i + 1)
                GPR[i] <= 0;
        end

    always
        @(posedge clk)
        begin
            if (we && rw != 0)
                GPR[rw] <= din;
        end

endmodule
