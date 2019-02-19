`timescale 1ns / 1ps
`include "MIPS-1.vh"

module syscall_test();
    reg[31:0]   a0, v0;
    reg         clk, rst, syscall, go;
    wire[31:0]  led_data;
    wire        pause, print;
    wire[3:0]   print_mode;

    initial
        begin
            clk = 0;
            rst = 0;
            go = 0;
            a0 = 10;
            v0 = `SYS_PDEC;
            #5
            syscall = 1;
            #5
            syscall = 0;
            #10
            v0 = `SYS_PDEC;
            syscall = 1;
            #5
            syscall = 0;
            #20
            v0 = `SYS_PAUSE;
            #5
            syscall = 1;
            #10
            go = 1;
            #10
            go = 0;
            #5
            syscall = 0;
            #10
            v0 = `SYS_EXIT;
            #20
            syscall = 1;
            #10
            go = 1;

        end

    always
        #5 clk = ~clk;

    syscall syscalls(
        .clk(clk),
        .rst(rst),
        .syscall(syscall),
        .go(go),
        .a0(a0),
        .v0(v0),
        .pause(pause),
        .print(print),
        .led_data(led_data),
        .print_mode(print_mode)
    );

endmodule
