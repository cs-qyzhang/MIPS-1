`timescale 1ns / 1ps

/*
分支跳转信号
input:
    R ALU比较运算结果，取第0位
    Equal ALU比较信号
    beq
    bne
    B 4条B类指令，两位
    rsn 4位，用来区分BLTZ和BGEZ指令
output:
    Branch 分支跳转信号，一位    
*/
module Branch(R,Equal,beq,bne,B,Branch,rsn);
    input R,Equal,beq,bne;
    input [1:0]B;
    input [4:0]rsn;
    output Branch;
    
    assign Branch = beq ? (Equal ? 1 : 0) :
                    bne ? (Equal ? 0 : 1) :
                    (B == 2'b01) ? (R||Equal ? 1 : 0) :
                    (B == 2'b10) ? (R||Equal ? 0 : 1) :
                    (B == 2'b11) ? (rsn == 5'b00000 ? (R ? 1 : 0) : (R ? 0 : 1)) :
                    (0);
    
endmodule
