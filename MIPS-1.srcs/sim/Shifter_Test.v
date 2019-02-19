`timescale 1ns / 1ps

module Shifter_Test();
    reg [31:0]Din,Dst;
wire [31:0]Dout;

initial begin
Din <= 32'h11111111;
Dst <= 32'h00000002;
end

Shifter test(Din,Dst,Dout);
endmodule
