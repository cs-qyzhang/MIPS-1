`timescale 1ns / 1ps

/*
��λ������֧���߼����ƣ�
input 
    Din ��������
    Dst ���룬��ʾ��λ��λ��
output
    Dout �������
*/
module Shifter(Din,Dst,Dout);
    parameter DATA_WIDTH = 32;
    
    input [DATA_WIDTH-1:0]Din,Dst;
    output [DATA_WIDTH-1:0]Dout;
    
    assign Dout = Din << Dst;
    
endmodule
