`timescale 1ns / 1ps
`include "MIPS-1.vh"

module  InterruptGeneration(clk,rst,cause,status,ebase,hw,sw
                            interrupt_request,exception_handle_addr);

    parameter   ADDR_WIDTH = `ADDR_WIDTH;

    input                   clk, rst;
    input[5:0]              hw;
    input[1:0]              sw;
    input[31:0]             cause, status, ebase;
    output reg              interrupt_request       = 0;
    output reg[ADDR_WIDTH-1:0]exception_handle_addr = `EXCEPTION_HANDLE_ADDR;

    assign  cause[`CAUSE_IP7] = hw[5];
    assign  cause[`CAUSE_IP6] = hw[4];
    assign  cause[`CAUSE_IP5] = hw[3];
    assign  cause[`CAUSE_IP4] = hw[2];
    assign  cause[`CAUSE_IP3] = hw[1];
    assign  cause[`CAUSE_IP2] = hw[0];
    assign  cause[`CAUSE_IP1] = sw[1];
    assign  cause[`CAUSE_IP0] = sw[0];

    always @(negedge clk)
        begin
            if (rst)
                begin
                    interrupt_request     = 1;
                    exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                end
            else if (status[`STATUS_IE])
                begin
                    if (cause[`CAUSE_IP7] && status[`STATUS_IM7])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else if (cause[`CAUSE_IP6] && status[`STATUS_IM6])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else if (cause[`CAUSE_IP5] && status[`STATUS_IM5])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else if (cause[`CAUSE_IP4] && status[`STATUS_IM4])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else if (cause[`CAUSE_IP3] && status[`STATUS_IM3])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else if (cause[`CAUSE_IP2] && status[`STATUS_IM2])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else if (cause[`CAUSE_IP1] && status[`STATUS_IM1])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else if (cause[`CAUSE_IP0] && status[`STATUS_IM0])
                        begin
                            interrupt_request     = 1;
                            exception_handle_addr = `EXCEPTION_HANDLE_ADDR;
                        end
                    else
                        begin
                            interrupt_request     = 0;
                            exception_handle_addr = exception_handle_addr;
                        end
                end
            else
                begin
                    interrupt_request     = 0;
                    exception_handle_addr = exception_handle_addr;
                end
        end

endmodule
