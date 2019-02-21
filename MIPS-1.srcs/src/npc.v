`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * NextPC, PC更新逻辑
 * 
 * input:
 *      pc: 旧pc
 *      clk:
 *      rst:
 *      imm: 16位立即数
 *      imm26: 26位立即数
 *      branch: 跳转信号（跳转成功）
 *      rs: rs 寄存器值（JR指令跳转）
 *      jr: jr 指令
 *      jmp: jar, j指令
 *      
 * output:
 *      npc: next pc
 *
 */
module Npc(pc,clk,rst,imm_ext,imm26,branch,rs,jr,jmp,npc);
    input[31:0]     pc, rs;
    input           clk, rst, branch, jr, jmp;
    input[25:0]     imm26;
    input[31:0]     imm_ext;

    output reg[31:0]npc;

    initial
        begin
            npc <= 0;
        end

    always
        @(negedge clk)
        begin
            if (rst)
                npc <= 0;
            else if (branch)
                npc <= (imm_ext << 2) + pc + 4;
            else if (jr)
                npc <= rs;
            else if (jmp)
                npc <= {pc[31:28], imm26, 2'b00};
            else
                npc <= pc + 4;
        end

endmodule
