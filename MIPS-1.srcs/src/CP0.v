`timescale 1ns / 1ps
`include "MIPS-1.vh"

module CP0(clk,rst,we,din,dout,rw,ra,rb,status,cause,ebase);
    input       clk, rst, we;
    input[4:0]  ra, rb, rw;
    input[31:0] din;
    output[31:0]dout, ebase;
    inout[31:0] cause, ebase;

    reg[31:0]   CP0_reg[31:0];

    assign  cause   = CP0_reg[`CP0_CAUSE];
    assign  ebase   = CP0_reg[`CP0_EBASE];
    assign  status  = CP0_reg[`CP0_STATUS];

    initial
        begin
            for (i = 0; i < 32; i = i + 1)
                CP0_reg = 32'b0;
            CP0_reg[EBASE] = `EXCEPTION_HANDLE_ADDR;
        end

    always @(negedge clk)
        begin
            CP0_reg[`CP0_CAUSE]  = cause;
            CP0_reg[`CP0_STATUS] = status;
            if (we)
                CP0_reg[rw] = din;
            else
                ;
        end

endmodule
