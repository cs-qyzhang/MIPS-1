`timescale 1ns / 1ps
`include "MIPS-1.vh"
/*
 *module divider
 *input:
 *      clk
 *output:
 *      clk_n
 */
module Divider(clk, clk_n);
    input clk;                          
    output clk_n;                       
    
    parameter N = 50000;           
    reg [31:0] cnt = 0;                    
    reg clk_n = 0;

    always
        @(posedge clk) begin
            cnt = cnt + 1;
            if (cnt == N)
                begin
                    cnt = 0;
                    clk_n <= ~clk_n;
                end
            else
                clk_n <= clk_n;
        end
endmodule

module DividerFreq(clk,freq,clk_n);
    input       clk;
    input[31:0] freq;
    output reg  clk_n = 0;

    reg [31:0]  cnt = 0;

    always
        @(posedge clk) begin
            cnt = cnt + 1;
            if (cnt >= (100_000_000 / freq))
                begin
                    cnt = 0;
                    clk_n <= ~clk_n;
                end
            else
                clk_n <= clk_n;
        end

endmodule
