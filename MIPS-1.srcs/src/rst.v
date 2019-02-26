`timescale 1ns / 1ps
`include "MIPS-1.vh"

module Rst(clk,rst_button,rst);
    input       clk;
    input       rst_button;
    output reg  rst;

    reg         start = 0;

    always @(posedge clk)
        begin
            if (!start)
                begin
                    start = 1;
                    rst   = 1;
                end
            else
                rst = rst_button;
        end
endmodule
