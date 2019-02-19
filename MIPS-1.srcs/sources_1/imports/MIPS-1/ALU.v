`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * ALU
 * 
 * input:
 *    A: 操作数1
 *    B: 操作数2
 *    Shmat: 移位
 *    AluOp: 操作类型
 *
 * output:
 *    Equal: 是否等于
 *    Result: 结果
 *    Result2: 结果的第二部分
 *
 * TODO:运算溢出？Result2默认值设置？
 */
module ALU(A,B,Shmat,AluOp,Equal,Result,Result2);
    input[31:0]     A, B;
    input[4:0]      Shmat;
    input[3:0]      AluOp;
    output          Equal;
    output reg[31:0]Result, Result2;

    assign Equal = (A == B) ? 1 : 0;

    wire[1:0]       mdu_op;
    wire[31:0]      mdu_hi, mdu_lo;
    MDU mdu(
        .A(A),
        .B(B),
        .op(mdu_op),
        .HI(mdu_hi),
        .LO(mdu_lo)
    );

    always
        @(AluOp, A, B)
        begin
            case (AluOp)
                4'b0000: begin Result <= A << Shmat; Result2 <= 0; end
                4'b0001: begin Result <= A >>> Shmat; Result2 <= 0; end
                4'b0010: begin Result <= A >> Shmat; Result2 <= 0; end
                4'b0011: //乘法
                    begin
                        mdu_op = MDU_MUL;
                        // lo,hi产生时间与赋值时间顺序？
                        Result <= mdu_lo;
                        Result2 <= mdu_hi;
                    end
                4'b0100: // 除法
                    begin
                        mdu_op = MDU_DIV;
                        // lo,hi产生时间与赋值时间顺序？
                        Result <= mdu_lo;
                        Result2 <= mdu_hi;
                    end
                4'b0101: begin Result <= A + B; Result2 <= 0; end
                4'b0110: begin Result <= A - B; Result2 <= 0; end
                4'b0111: begin Result <= A & B; Result2 <= 0; end
                4'b1000: begin Result <= A | B; Result2 <= 0; end
                4'b1001: begin Result <= A ^ B; Result2 <= 0; end
                4'b1010: begin Result <= ~(A | B); Result2 <= 0; end
                4'b1011: begin Result <= ($signed(A) < $signed(B)) ? 1 : 0; Result2 <= 0; end
                4'b1100: begin Result <= ($unsigned(A) < $unsigned(B)) ? 1 : 0; Result2 <= 0; end
                //4'b1101:
                //4'b1110:
                //4'b1111:
                default: begin Result <= 0; Result2 <= 0;
            endcase
        end

endmodule

/*
 * 乘除法器
 * input:
 *      op: 操作类型，MDU_NOP：无操作；MDU_MUL：乘法；MDU_DIV：除法
 *      A:  操作数1
 *      B： 操作数2
 *
 * output:
 *      LO:
 *      HI:
 */
module MDU(op,A,B,LO,HI);
    input[1:0]  op;
    input[31:0] A, B;
    output[31:0]LO,HI;

    reg[63:0]   mul_result;

    always
        begin
            case (op)
                MDU_NOP:
                MDU_MUL:
                    begin
                        mul_result = A * B;
                        LO <= mul_result[31:0];
                        HI <= mul_result[63:32];
                    end
                MDU_DIV:
                    begin
                        LO <= A / B;
                        HI <= A % B;
                    end
            endcase
        end
endmodule
