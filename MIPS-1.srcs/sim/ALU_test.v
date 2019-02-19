`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * ALU 模块测试
 */
module ALU_test();
    reg[31:0]   A, B;
    reg[3:0]    AluOp;
    reg[4:0]    Shmat;
    wire[31:0]   Result, Result2;

    ALU alu_test(
        .A(A),
        .B(B),
        .AluOp(AluOp),
        .Shmat(Shmat),
        .Result(Result),
        .Result2(Result2)
    );

    initial
        begin
            A = -10;
            B = 8;
            Shmat = 18;
            AluOp = `ALU_ADD;
            #5
            AluOp = `ALU_SUB;
            #5
            AluOp = `ALU_MUL;
            #5
            AluOp = `ALU_DIV;
            #5
            AluOp = `ALU_AND;
            #5
            AluOp = `ALU_OR;
            #5
            AluOp = `ALU_NOR;
            #5
            AluOp = `ALU_SLT;
            #5
            AluOp = `ALU_SLTU;
            #5
            AluOp = `ALU_SLL;
            #5
            AluOp = `ALU_SRA;
            #5
            AluOp = `ALU_SRL;
        end
endmodule
