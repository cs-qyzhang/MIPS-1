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

    reg[3:0]        mdu_op;
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
                `ALU_SLL: begin assign Result = A << Shmat; assign Result2 = 0; end
                `ALU_SRL: begin assign Result = A >> Shmat; assign Result2 = 0; end
                `ALU_SRA: begin
                                assign Result = $signed(A) >>> Shmat;
                                assign Result2 = 0;
                          end
                `ALU_MUL:
                    begin
                        mdu_op = `MDU_MUL;
                        assign Result = mdu_lo;
                        assign Result2 = mdu_hi;
                    end
                `ALU_DIV:
                    begin
                        mdu_op = `MDU_DIV;
                        assign Result = mdu_lo;
                        assign Result2 = mdu_hi;
                    end
                `ALU_ADD:  begin assign Result = A + B;    assign Result2 = 0; end
                `ALU_SUB:  begin assign Result = A - B;    assign Result2 = 0; end
                `ALU_AND:  begin assign Result = A & B;    assign Result2 = 0; end
                `ALU_OR:   begin assign Result = A | B;    assign Result2 = 0; end
                `ALU_XOR:  begin assign Result = A ^ B;    assign Result2 = 0; end
                `ALU_NOR:  begin assign Result = ~(A | B); assign Result2 = 0; end
                `ALU_SLT:  begin
                                 assign Result = ($signed(A) < $signed(B)) ? 1 : 0;
                                 assign Result2 = 0;
                           end
                `ALU_SLTU: begin
                                 assign Result = ($unsigned(A) < $unsigned(B)) ? 1 : 0;
                                 assign Result2 = 0;
                           end
                default:   begin assign Result = 0; assign Result2 = 0; end
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
