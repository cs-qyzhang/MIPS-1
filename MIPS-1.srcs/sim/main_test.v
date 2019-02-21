`timescale 1ns / 1ps
`include "MIPS-1.vh"


module main_test();
    reg         clk, rst;
    wire[7:0]   an, seg;

    Main main(
        .clk(clk),
        .an(an),
        .seg(seg)
    );

    initial
        begin
            rst = 0;
            clk = 1;
        end
        
    always
        #10 clk = ~clk;
    
endmodule
