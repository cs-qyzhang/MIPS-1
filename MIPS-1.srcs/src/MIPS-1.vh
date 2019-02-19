/*
 * MIPS-1.vh
 * 常数定义
 */
`timescale  1 ns / 1 ps
`define         TRUE        1'b1
`define         FALSE       1'b0

// ALU OP
`define         ALU_SLL     4'b0000
`define         ALU_SRA     4'b0001
`define         ALU_SRL     4'b0010
`define         ALU_MUL     4'b0011
`define         ALU_DIV     4'b0100
`define         ALU_ADD     4'b0101
`define         ALU_SUB     4'b0110
`define         ALU_AND     4'b0111
`define         ALU_OR      4'b1000
`define         ALU_XOR     4'b1001
`define         ALU_NOR     4'b1010
`define         ALU_SLT     4'b1011
`define         ALU_SLTU    4'b1100

// MDU OP
`define         MDU_NOP     2'b00
`define         MDU_MUL     2'b01
`define         MDU_DIV     2'b10
