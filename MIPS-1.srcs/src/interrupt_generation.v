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
module  InterruptGeneration(clk,rst,cause_ip_in,status_im,ebase,hw,sw,
                            interrupt_en_in,interrupt_finish,
                            interrupt,cause_ip_out,interrupt_en_out,
                            exception_handle_addr,epc,interrupt_disable,
                            interrupt_enable,npc,interrupt_begin);

    parameter   ADDR_WIDTH = `ADDR_WIDTH;

    input                   clk, rst, interrupt_finish;
    input[5:0]              hw;
    input[1:0]              sw;
    input[31:0]             ebase, npc;
    input[7:0]              status_im, cause_ip_in;
    input                   interrupt_disable, interrupt_enable, interrupt_en_in;
    output reg[31:0]        epc;
    output reg[7:0]         cause_ip_out;
    output reg              interrupt               = 0;
    output reg              interrupt_en_out        = 1;
    output reg              interrupt_begin         = 0;
    output reg[ADDR_WIDTH-1:0]exception_handle_addr = `EXCEPTION_HANDLE_ADDR;

    reg[2:0]                interrupt_source        = 0;

    always @(negedge clk)
        begin
            interrupt_begin = 0;

            cause_ip_out[7] = cause_ip_in[7] ? cause_ip_in[7] : hw[5];
            cause_ip_out[6] = cause_ip_in[6] ? cause_ip_in[6] : hw[4];
            cause_ip_out[5] = cause_ip_in[5] ? cause_ip_in[5] : hw[3];
            cause_ip_out[4] = cause_ip_in[4] ? cause_ip_in[4] : hw[2];
            cause_ip_out[3] = cause_ip_in[3] ? cause_ip_in[3] : hw[1];
            cause_ip_out[2] = cause_ip_in[2] ? cause_ip_in[2] : hw[0];
            cause_ip_out[1] = cause_ip_in[1] ? cause_ip_in[1] : sw[1];
            cause_ip_out[0] = cause_ip_in[0] ? cause_ip_in[0] : sw[0];

            if (interrupt_finish)
                begin
                    interrupt                      = 0;
                    cause_ip_out[interrupt_source] = 0;
                end
            else
                begin
                    interrupt = interrupt;
                end

            if (interrupt_disable)
                interrupt_en_out = 0;
            else if (interrupt_enable)
                interrupt_en_out = 1;
            else
                interrupt_en_out = interrupt_en_in;

            if (rst)
                begin
                    interrupt             = 0;
                    exception_handle_addr = ebase;
                    cause_ip_out[7:0]     = 0;
                    interrupt_source      = 0;
                    interrupt_begin       = 0;
                end
            else if (interrupt_en_out)
                begin
                    if (cause_ip_out[7] && status_im[7])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 7;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else if (cause_ip_out[6] && status_im[6])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 6;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else if (cause_ip_out[5] && status_im[5])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 5;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else if (cause_ip_out[4] && status_im[4])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 4;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else if (cause_ip_out[3] && status_im[3])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 3;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else if (cause_ip_out[2] && status_im[2])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 2;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else if (cause_ip_out[1] && status_im[1])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 1;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else if (cause_ip_out[0] && status_im[0])
                        begin
                            interrupt             = 1;
                            exception_handle_addr = ebase;
                            interrupt_source      = 0;
                            interrupt_en_out      = 0;
                            epc                   = npc;
                            interrupt_begin       = 1;
                        end
                    else
                        begin
                            interrupt             = 0;
                            exception_handle_addr = exception_handle_addr;
                        end
                end
            else
                begin
                    interrupt             = 0;
                    exception_handle_addr = exception_handle_addr;
                end
        end

endmodule
