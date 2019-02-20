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

// op_code
`define         ZERO_OP     6'd0        //R型指令op_code
`define         J_OP        6'd2        
`define         JAL_OP      6'd3        
`define         BEQ_OP      6'd4        
`define         BNE_OP      6'd5
`define         ADDI_OP     6'd8
`define         ANDI_OP     6'd12
`define         ADDIU_OP    6'd9
`define         SLTI_OP     6'd10
`define         ORI_OP      6'd13
`define         LW_OP       6'd35
`define         SW_OP       6'd43
`define         XORI_OP     6'd14
`define         LUI_OP      6'd15
`define         SLTIU_OP    6'd11
`define         LB_OP       6'd32
`define         LBU_OP      6'd36
`define         LH_OP       6'd33
`define         LHU_OP      6'd37
`define         SB_OP       6'd40
`define         SH_OP       6'd41
`define         BLEZ_OP     6'd6
`define         BGTZ_OP     6'd7
`define         BLTZ_OP     6'd1
`define         BGEZ_OP     6'd1

// func
`define         SLL_FUNC    6'd0
`define         SRA_FUNC    6'd3
`define         SRL_FUNC    6'd2
`define         ADD_FUNC    6'd32
`define         ADDU_FUNC   6'd33
`define         SUB_FUNC    6'd34
`define         AND_FUNC    6'd36
`define         OR_FUNC     6'd37
`define         NOR_FUNC    6'd39
`define         SLT_FUNC    6'd42
`define         SLTU_FUNC   6'd43
`define         JR_FUNC     6'd8
`define         SYS_FUNC    6'd12
`define         SLLV_FUNC   6'd4
`define         SRLV_FUNC   6'd6
`define         SRAV_FUNC   6'd7
`define         SUBU_FUNC   6'd35
`define         XOR_FUNC    6'd38
`define         MULTU_FUNC  6'd25
`define         DIVU_FUNC   6'd27
`define         MFLO_FUNC   6'd18

// Adder width
`define         ADDR_WIDTH  10
