`timescale 1ns / 1ps
`include "MIPS-1.vh"


module main_test();
    reg         clk, rst, go;
    wire[7:0]   an, seg, led;
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
            sw[15] = 0;
            sw[14:0] = 15'b0;
            #31000
            sw[15] = 1;
            //sw[15] <= #31000 1;
            //sw[15] <= #31100 0;
            //sw[14] <= #31100 1;
            //sw[14] <= #31200 0;
            //sw[13] <= #31200 1;
        end
        
    always
        #10 clk = ~clk;
    
endmodule
