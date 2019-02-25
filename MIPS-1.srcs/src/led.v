`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * led 显示模块
 *
 */
module Led(pause,
           led16_b,led16_g,led16_r,led17_b,led17_g,led17_r);

    input   pause;
    output          led16_b, led16_g, led16_r, led17_b, led17_g, led17_r;

    assign led16_r = pause;
    assign led16_g = !pause;
    assign led16_b = 0;

    assign led17_r = 0;
    assign led17_g = 0;
    assign led17_b = 0;

endmodule
