`timescale 1ns / 1ps

/*
位数可变的拓展
input:
    Din
    sel
output:
    Dout
*/
module Extender(Din,Dout,sel);
    parameter DATA_IN_WIDTH = 16;
    parameter DATA_OUT_WIDTH = 32;

    input sel;
    input [DATA_IN_WIDTH-1:0]Din;
    output [DATA_OUT_WIDTH-1:0]Dout;

    assign Dout = sel ? {{(DATA_OUT_WIDTH-DATA_IN_WIDTH)*1'b0},Din[DATA_IN_WIDTH-1:0]} : {{(DATA_OUT_WIDTH-DATA_IN_WIDTH){Din[DATA_IN_WIDTH-1]}},Din[DATA_IN_WIDTH-1:0]};

endmodule
