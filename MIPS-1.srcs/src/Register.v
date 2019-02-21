`timescale 1ns / 1ps

/*
�Ĵ���
input 
    clk ʱ��
    rst ����
    inr ����ʱ���ź�
    data_in ����
output 
    data_out ���
*/
module Register(data_in,data_out,clk,rst,inr);
    parameter DATA_WIDTH = 32;
    input [DATA_WIDTH-1:0]data_in;
    input clk,rst,inr;
    output reg [DATA_WIDTH-1:0]data_out;

    //�����ش���
    always @ (posedge clk)
    begin 
    //��rstΪ1ʱ������
        if(rst == 1) data_out <= 0;
    //��inrΪ0ʱ������ʱ�ӵ�����
        else if(inr == 0);
    //��ʱ�Ӷ���������������������������¼Ĵ�����ֵ
        else data_out <= data_in; 
    end

endmodule
