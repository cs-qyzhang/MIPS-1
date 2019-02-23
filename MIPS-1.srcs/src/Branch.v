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
    output Branch;
    
    assign Branch = beq ? (Equal ? 1 : 0) :
                    bne ? (Equal ? 0 : 1) :
                    (B == 2'b00) ? 0 :
                    (B == 2'b01) ? ((R|Equal) ? 1 : 0) :
                    (B == 2'b10) ? ((R|Equal) ? 0 : 1) :
                    (B == 2'b11) ? ((rt == 5'b00000) ? (R ? 1 : 0) : (R ? 0 : 1)) :
                    (0);
endmodule
