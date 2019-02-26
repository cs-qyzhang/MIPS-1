`timescale 1ns / 1ps
`include "MIPS-1.vh"


module main_redirectInterrupt_test();
    reg         clk, rst, go;
    wire[7:0]   an, seg;
    wire[15:0] led;
    reg[15:0]   sw;
    wire            led16_b, led16_g, led16_r, led17_b, led17_g, led17_r;
    
    reg btnu=0;
    reg btnc=0;
    reg btnd=0;
    
    MainRedirectInterrupt main_redirect(
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
            rst = 1;
            clk = 0;
            go = 0;
            btnc = 0;
            #50 rst<=0;
          
            sw[15:0] = 'b0;
            #1000
            btnc=1;
            #5 btnc=0;
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
