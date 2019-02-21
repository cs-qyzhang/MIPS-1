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
    reg [31:0] cnt;                    
    reg clk_n;

    initial
        begin
            cnt = 0;
        end

    always
        @(posedge clk) begin
            cnt = cnt + 1;
            if (cnt == N)
                begin
                    cnt = 0;
                    clk_n = ~clk_n;
                end
        end
endmodule

module DividerFreq(clk,freq,clk_n);
    input       clk;
    input[31:0] freq;
    output reg  clk_n;

    reg [31:0]  cnt;

    initial
        begin
            cnt = 0;
        end

    always
        @(posedge clk) begin
            cnt = cnt + 1;
            if (cnt >= (100_000_000 / freq))
                begin
                    cnt = 0;
                    clk_n = ~clk_n;
                end
        end

endmodule
