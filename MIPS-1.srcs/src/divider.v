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
