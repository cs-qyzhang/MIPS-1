`timescale 1ns / 1ps

/*
寄存器
input 
    clk 时钟
    rst 清零
    inr 忽略时钟信号
    data_in 输入
output 
    data_out 输出
*/
module Register(data_in,data_out,clk,rst,inr);
    parameter DATA_WIDTH = 32;
    input [DATA_WIDTH-1:0]data_in;
    input clk,rst,inr;
    output reg [DATA_WIDTH-1:0]data_out;

    //上升沿触发
    always @ (posedge clk)
    begin 
    //当rst为1时，清零
        if(rst == 1) data_out <= 0;
    //当inr为0时，忽略时钟的输入
        else if(inr == 0);
    //当时钟端输入后，若不是上面两种情况则更新寄存器的值
        else data_out <= data_in; 
    end

endmodule
