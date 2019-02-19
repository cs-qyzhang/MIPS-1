/*
 * MIPS-1.vh
 * 常数定义
 */
`timescale  1 ns / 1 ps

`define         TRUE        1
`define         FALSE       0

// SYSCALL
`define         SYS_PDEC    1 
`define         SYS_EXIT    10
`define         SYS_PHEX    34
`define         SYS_PBIN    35
`define         SYS_PAUSE   50

// ALU OP
`define         ALU_SLL     4'b0000     // 逻辑左移
`define         ALU_SRA     4'b0001     // 算术右移
`define         ALU_SRL     4'b0010     // 逻辑右移
`define         ALU_MUL     4'b0011     // 乘法
`define         ALU_DIV     4'b0100     // 除法
`define         ALU_ADD     4'b0101     // 加法
`define         ALU_SUB     4'b0110     // 减法
`define         ALU_AND     4'b0111     // 与
`define         ALU_OR      4'b1000     // 或
`define         ALU_XOR     4'b1001     // 异或
`define         ALU_NOR     4'b1010     // 或非
`define         ALU_SLT     4'b1011     // 符号小于判断
`define         ALU_SLTU    4'b1100     // 无符号小于判断

// MDU OP
`define         MDU_NOP     4'b0000     // 无动作
`define         MDU_MUL     4'b0001     // 符号乘法
`define         MDU_DIV     4'b0010     // 符号除法
`define         MDU_MULU    4'b0100     // 无符号乘法
`define         MDU_DIVU    4'b1000     // 无符号除法

// PRINT MODE
`define         PRINT_DEC   4'b0000     // 有符号10进制打印
`define         PRINT_HEX   4'b0001     // 有符号16进制打印
`define         PRINT_BIN   4'b0010     // 有符号2进制打印
