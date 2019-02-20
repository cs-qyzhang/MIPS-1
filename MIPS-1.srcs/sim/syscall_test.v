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
            #50
            syscall = 1;
            #50
            syscall = 0;
            #100
            v0 = `SYS_PDEC;
            syscall = 1;
            #50
            syscall = 0;
            #200
            v0 = `SYS_PAUSE;
            #50
            syscall = 1;
            #100
            go = 1;
            #100
            go = 0;
            #50
            syscall = 0;
            #100
            v0 = `SYS_EXIT;
            #200
            syscall = 1;
            #100
            go = 1;

        end

    always
        #50 clk = ~clk;

    Syscall syscalls(
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
