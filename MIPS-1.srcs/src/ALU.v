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
module ALU(A,B,Shmat,AluOp,Equal,result,result2);
    input[31:0]     A, B;
    input[4:0]      Shmat;
    input[3:0]      AluOp;
    output          Equal;
    output[31:0]result, result2;

    assign Equal = (A == B) ? 1 : 0;

    reg             mul_or_div;
    reg[3:0]        mdu_op;
    wire[31:0]      mdu_hi, mdu_lo;
    reg[31:0]       Result, Result2;

    MDU mdu(
        .A(A),
        .B(B),
        .op(mdu_op),
        .HI(mdu_hi),
        .LO(mdu_lo)
    );

    initial
        begin
            mul_or_div = 0;
            Result = 0;
            Result2 = 0;
        end

    assign result = mul_or_div ? mdu_lo : Result;
    assign result2 = mul_or_div ? mdu_hi : Result2;

    always
        @(AluOp, A, B)
        begin
            mul_or_div = 0;
            case (AluOp)
                `ALU_SLL: begin Result = B << $unsigned(Shmat); Result2 = 0; end
                `ALU_SRL: begin Result = B >> Shmat;  Result2 = 0; end
                `ALU_SRA: begin
                                Result = $signed(B) >>> Shmat;
                                Result2 = 0;
                          end
                `ALU_MUL:
                    begin
                        mdu_op = `MDU_MUL;
                        mul_or_div = 1;
                    end
                `ALU_DIV:
                    begin
                        mdu_op = `MDU_DIV;
                        mul_or_div = 1;
                    end
                `ALU_ADD:  begin Result = A + B;    Result2 = 0; end
                `ALU_SUB:  begin Result = A - B;    Result2 = 0; end
                `ALU_AND:  begin Result = A & B;    Result2 = 0; end
                `ALU_OR:   begin Result = A | B;    Result2 = 0; end
                `ALU_XOR:  begin Result = A ^ B;    Result2 = 0; end
                `ALU_NOR:  begin Result = ~(A | B); Result2 = 0; end
                `ALU_SLT:  begin
                                 Result = ($signed(A) < $signed(B)) ? 1 : 0;
                                 Result2 = 0;
                           end
                `ALU_SLTU: begin
                                 Result = ($unsigned(A) < $unsigned(B)) ? 1 : 0;
                                 Result2 = 0;
                           end
                default:   begin Result = 0; Result2 = 0; end
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
    input[3:0]      op;
    input[31:0]     A, B;
    output reg[31:0]LO,HI;

    reg[63:0]       mul_result;

    always
        @(op, A, B)
        begin
            case (op)
                `MDU_NOP: ;
                `MDU_MUL:
                    begin
                        mul_result = $signed(A) * $signed(B);
                        LO <= mul_result[31:0];
                        HI <= mul_result[63:32];
                    end
                `MDU_MULU:
                    begin
                        mul_result = $unsigned(A) * $unsigned(B);
                        LO <= mul_result[31:0];
                        HI <= mul_result[63:32];
                    end
                `MDU_DIV:
                    begin
                        LO <= $signed(A) / $signed(B);
                        HI <= $signed(A) % $signed(B);
                    end
                `MDU_DIVU:
                    begin
                        LO <= $unsigned(A) / $unsigned(B);
                        HI <= $unsigned(A) % $unsigned(B);
                    end
                default: ;
            endcase
        end
endmodule
