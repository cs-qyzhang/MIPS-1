`timescale 1ns / 1ps
`include "MIPS-1.vh"

module counter_test();
    reg         clk, count, ld, rst;
    reg[31:0]   data;
    wire[31:0]  cnt;

    Counter #(0) test(
        .clk(clk),
        .count(count),
        .ld(ld),
        .data(data),
        .cnt(cnt),
        .rst(rst)
    );

    initial
        begin
            rst = 0;
            clk = 0;
            count = 0;
            #50
            data = 10;
            #50
            ld = 1;
            #100
            ld = 0;
            #200
            count = 1;
            #100
            count = 0;
            #200
            count = 1;
            #100
            count = 0;
        end

    always
        #50  clk = ~clk;

endmodule
