`timescale 1ns / 1ps
`include "MIPS-1.vh"

module  InterruptHandler(clk,rst,interrupt_request,epc,exception_handle_addr);
    input       clk, rst, interrupt_request;
    input[31:0] pc;
    input[`ADDR_WIDTH-1:0]  exception_handle_addr;
    output[31:0]epc;


endmodule
