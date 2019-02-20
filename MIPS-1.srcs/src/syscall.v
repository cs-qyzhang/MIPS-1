`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * 系统调用模块
 *
 * input:
 *      clk:
 *      rst:
 *      syscall: syscall 信号
 *      go:
 *      a0: 调用参数
 *      v0: 调用号
 *
 * output:
 *      led_data: 显示数据
 *      pause: 暂停
 *      print: 打印信号
 *      print_mode: 打印模式
 */
module Syscall(clk,rst,syscall,go,a0,v0,pause,print,led_data,print_mode);
    input           clk, rst, syscall, go;
    input[31:0]     a0, v0;
    output reg[31:0]led_data;
    output reg      pause, print;
    output reg[3:0] print_mode;

    reg can_go;

    initial
        begin
            led_data   <= 0;
            pause      <= 0;
            print      <= 0;
            print_mode <= `PRINT_DEC;
            can_go      = 0;
        end

    always
        @(negedge clk)
        begin
            print <= 0;

            if (go && can_go && pause)
                pause <= 0;
            else if (rst)
                begin
                    led_data   <= 0;
                    pause      <= 0;
                    print      <= 0;
                    print_mode <= `PRINT_DEC;
                    can_go      = 0;
                end
            else if (!pause && syscall)
                begin
                    case (v0)
                        `SYS_PAUSE:
                            begin
                                can_go = 1;
                                pause <= 1;
                            end
                        `SYS_EXIT:
                            begin
                                can_go = 0;
                                pause <= 1;
                            end
                        `SYS_PDEC:
                            begin
                                led_data   <= a0;
                                print      <= 1;
                                print_mode <= `PRINT_DEC;
                            end
                        `SYS_PBIN:
                            begin
                                led_data   <= a0;
                                print      <= 1; 
                                print_mode <= `PRINT_BIN;
                            end
                        `SYS_PHEX:
                            begin
                                led_data   <= a0;
                                print      <= 1;
                                print_mode <= `PRINT_HEX;
                            end
                    endcase
                end
            else
                ;
        end

endmodule
