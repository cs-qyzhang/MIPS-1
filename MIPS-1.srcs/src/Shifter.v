`timescale 1ns / 1ps

/*
移位器（仅支持逻辑左移）
input 
    Din 输入数据
    Dst 距离，表示移位的位数
output
    Dout 输出数据
*/
module Shifter(Din,Dst,Dout);
    parameter DATA_WIDTH = 32;
    
    input [DATA_WIDTH-1:0]Din,Dst;
    output [DATA_WIDTH-1:0]Dout;
    
    assign Dout = Din << Dst;
    
endmodule
