`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * 输入处理模块，处理按钮和开关
 *
 * sw[15]: 显示所有周期
 * sw[14]: 显示条件分支成功数
 * sw[13]: 显示无条件分支数
 *
 * sw[4]:  频率为最快
 * sw[3]:  频率为快
 * sw[2]:  频率为中等
 * sw[1]:  频率为慢
 * sw[0]:  频率为最慢
 *
 * 频率采用优先编码，取最快的
 *
 */
module Input(btnl,btnr,btnc,btnu,btnd,sw,
             go,rst,freq,pause_and_show,show_type,
             hardware_interrupt);

    input           btnl, btnr, btnc, btnu, btnd;
    input[15:0]     sw;

    output          pause_and_show,go,rst;
    output[3:0]     show_type;
    output reg[31:0]freq = `FREQ_DEF;
    output[5:0] hardware_interrupt;

    assign go = btnr;
    assign rst = btnl;
    assign pause_and_show = |sw[15:13];
    assign show_type = sw[15] ? `SHOW_ALL_CYC : (sw[14] ? `SHOW_BRANCH_NUM : (sw[13] ? `SHOW_JMP_NUM : `SHOW_ALL_CYC));
    assign hardware_interrupt = btnc ? 'b1 : 'b0;

    always
        @(sw[4:0])
        begin
            if (sw[4])
                freq <= `FREQ_ULTRA_FAST;
            else if (sw[3])
                freq <= `FREQ_FAST;
            else if (sw[2])
                freq <= `FREQ_MID;
            else if (sw[1])
                freq <= `FREQ_SLOW;
            else if (sw[0])
                freq <= `FREQ_ULTRA_SLOW;
            else
                freq <= `FREQ_DEF;
        end

endmodule
