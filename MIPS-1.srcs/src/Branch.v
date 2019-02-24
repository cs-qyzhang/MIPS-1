`timescale 1ns / 1ps

/*
��֧��ת�ź�
input:
    R ALU�Ƚ���������ȡ��0λ
    Equal ALU�Ƚ��ź�
    beq
    bne
    B 4��B��ָ���λ
    rsn 4λ����������BLTZ��BGEZָ��
output:
    Branch ��֧��ת�źţ�һλ    
*/
module Branch(R,Equal,beq,bne,B,Branch,rt);
    input R,Equal,beq,bne;
    input [1:0]B;
    input [4:0]rt;
    output reg Branch;
    
    always @(*)
        begin
            if (beq)
                Branch = Equal ? 1 : 0;
            else if (bne)
                Branch = Equal ? 0 : 1;
            else if (B == 2'b00)
                Branch = 0;
            else if (B == 2'b01)
                Branch = (R || Equal) ? 1 : 0;
            else if (B == 2'b10)
                Branch = (R || Equal) ? 0 : 1;
            else if (B == 2'b11)
                begin
                    if (rt == 5'b0)
                        Branch = R ? 1 : 0;
                    else
                        Branch = R ? 0 : 1;
                end
            else
                Branch = 0;
        end

endmodule
