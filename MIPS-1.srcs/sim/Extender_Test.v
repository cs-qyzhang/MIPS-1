`timescale 1ns / 1ps

module Extender_Test();
    reg sel;
reg [15:0]data_in1;
wire [31:0]data_out1;
reg [4:0]data_in2;
wire [31:0]data_out2;

initial
begin
data_in1 <= 16'hf111;
data_in2 <= 5'b11111;
sel <= 1;
#50
sel <= 0;
end

Extender #(.DATA_IN_WIDTH(16),.DATA_OUT_WIDTH(32)) test(data_in1,data_out1,sel);
endmodule
