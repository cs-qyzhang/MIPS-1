`timescale 1ns / 1ps


module Register_Test();
    reg CLK,RST,INR;
reg [31:0]data_in;
wire [31:0]data_out;

always #10 CLK <= ~CLK;
initial begin
CLK <= 0;
RST <= 1;
INR <= 1;
#25
RST <= 0;
INR <= 1;
data_in <= 32'h11111111;
#25
RST <= 0;
INR <= 0;
data_in <= 32'h00000000;
#25
RST <= 0;
INR <= 1;
end

Register test(data_in,data_out,CLK,RST,INR);
endmodule
