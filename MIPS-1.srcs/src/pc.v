`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * pc寄存器
 * 
 * input:
 *      npc:
 *      rst:
 *      clk:
 *      pc_valid:
 * output:
 *      pc:
 */
module Pc(npc,rst,clk,pc_valid,pc);
    input[31:0]     npc;
    input           rst, clk, pc_valid;
    output reg[31:0]pc;

    initial
        begin
            pc = 0;
        end

    always
        @(posedge clk)
        begin
            if (rst)
                pc <= 0;
            else if (pc_valid)
                pc <= npc;
            else
                ;
        end

endmodule
