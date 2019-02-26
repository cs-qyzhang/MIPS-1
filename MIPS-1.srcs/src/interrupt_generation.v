`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * 中断产生
 *
 * input:
 *      interrupt_en: IE
 *
 * output:
 *      interrupt: 脉冲信号
 */
module  InterruptGeneration(clk,rst,cause_ip_in,status_im,ebase,hw,sw,interrupt_finish_after,
                            interrupt_finish,interrupt,cause_ip_out,interrupt_en,
                            exception_handle_addr,interrupt_begin);

    parameter   ADDR_WIDTH = `ADDR_WIDTH;

    input                   clk, rst, interrupt_finish;
    input[5:0]              hw;
    input[1:0]              sw;
    input[31:0]             ebase;
    input[7:0]              status_im, cause_ip_in;
    input[7:0]              interrupt_en;
    output reg[7:0]         cause_ip_out = 0;
    output reg              interrupt = 0;
    output reg              interrupt_begin;
    output reg[ADDR_WIDTH-1:0]exception_handle_addr;
    output reg              interrupt_finish_after;
    
    reg[3:0]                interrupt_now[3:0];
    reg[3:0]                interrupt_state;
    integer                 i;

    always @(negedge clk)
        begin
            interrupt_begin = 0;
            interrupt_finish_after = 0;

            cause_ip_out[7] = cause_ip_out[7] | hw[5];
            cause_ip_out[6] = cause_ip_out[6] | hw[4];
            cause_ip_out[5] = cause_ip_out[5] | hw[3];
            cause_ip_out[4] = cause_ip_out[4] | hw[2];
            cause_ip_out[3] = cause_ip_out[3] | hw[1];
            cause_ip_out[2] = cause_ip_out[2] | hw[0];
            cause_ip_out[1] = cause_ip_out[1] | sw[1];
            cause_ip_out[0] = cause_ip_out[0] | sw[0];

            if (interrupt_finish)
                begin
                    interrupt_finish_after = 1;
                    
                    if (cause_ip_out[7])
                        cause_ip_out[7] = 0;
                    else if (cause_ip_out[6])
                        cause_ip_out[6] = 0;
                    else if (cause_ip_out[5])
                        cause_ip_out[5] = 0;
                    else if (cause_ip_out[4])
                        cause_ip_out[4] = 0;
                    else if (cause_ip_out[3])
                        cause_ip_out[3] = 0;
                    else if (cause_ip_out[2])
                        cause_ip_out[2] = 0;
                    else if (cause_ip_out[1])
                        cause_ip_out[1] = 0;
                    else if (cause_ip_out[0])
                        cause_ip_out[0] = 0;
                    else
                        ;
                    
                    interrupt_now[interrupt_state] = 4'b1111;
                    interrupt_state = interrupt_state - 1;
                    if (interrupt_state)
                        begin
                            interrupt = 1;
                        end
                    else
                        begin
                            interrupt = 0;
                        end
                end
            else
                ;

            if (rst)
                begin
                    interrupt             = 0;
                    exception_handle_addr = ebase;
                    cause_ip_out[7:0]     = 0;
                    interrupt_begin       = 0;
                    interrupt_state       = 0;
                    for (i = 0; i <= 4'b1111; i = i + 1)
                        interrupt_now[i] = 4'b1111;
                end
            else if (interrupt_en)
                begin
                    if (cause_ip_out[7] && status_im[7] && (interrupt_now[interrupt_state] != 7))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 7 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 7;
                        end
                    else if (cause_ip_out[6] && status_im[6] && (interrupt_now[interrupt_state] != 6))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 6 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 6;
                        end
                    else if (cause_ip_out[5] && status_im[5] && (interrupt_now[interrupt_state] != 5))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 5 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 5;
                        end
                    else if (cause_ip_out[4] && status_im[4] && (interrupt_now[interrupt_state] != 4))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 4 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 4;
                        end
                    else if (cause_ip_out[3] && status_im[3] && (interrupt_now[interrupt_state] != 3))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 3 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 3;
                        end
                    else if (cause_ip_out[2] && status_im[2] && (interrupt_now[interrupt_state] != 2))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 2 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 2;
                        end
                    else if (cause_ip_out[1] && status_im[1] && (interrupt_now[interrupt_state] != 1))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 1 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 1;
                        end
                    else if (cause_ip_out[0] && status_im[0] && (interrupt_now[interrupt_state] != 0))
                        begin
                            interrupt                      = 1;
                            exception_handle_addr          = ebase + 0 * 3 * 4;
                            interrupt_begin                = 1;
                            interrupt_state                = interrupt_state + 1;
                            interrupt_now[interrupt_state] = 0;
                        end
                    else
                        begin
                            interrupt             = interrupt;
                            exception_handle_addr = exception_handle_addr;
                        end
                end
            else
                begin
                    interrupt             = interrupt;
                    exception_handle_addr = exception_handle_addr;
                end
        end

endmodule
