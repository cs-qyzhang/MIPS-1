`timescale 1ns / 1ps
`include "MIPS-1.vh"


module main_test();
    reg         clk, rst, go;
    wire[7:0]   an, seg;
    wire[15:0] led;
    reg[15:0]   sw;
    wire            led16_b, led16_g, led16_r, led17_b, led17_g, led17_r;

    Main main(
        .clk(clk),
        .an(an),
        .seg(seg),
        .btnl(rst),
        .btnr(go),
        .btnc(1'b0),
        .btnu(1'b0),
        .btnd(1'b0),
        .sw(sw),
        .led(led),
        .led16_b(led16_b),
        .led16_g(led16_g),
        .led16_r(led16_r),
        .led17_b(led17_b),
        .led17_g(led17_g),
        .led17_r(led17_r)
    );

    initial
        begin
            rst = 0;
            clk = 1;
            go = 0;
            sw[15:0] = 'b0;
            #31000
            sw[15] = 1;
            #100
            sw[15] = 0;
            sw[14] = 1;
            #100
            sw[14] = 0;
            sw[13] = 1;
        end
        
    always
        #5 clk = ~clk;
    
endmodule
