`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 18:16:51
// Design Name: 
// Module Name: Branch_Test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Branch_Test();
reg R,Equal,beq,bne;
reg [1:0]B;
reg [4:0]rsn;
wire Branch;

initial
begin
//bne≤‚ ‘
    R <= 0;
    Equal <= 1;
    beq <= 0;
    bne <= 1;
    B <= 2'b00;
    rsn <= 5'b00000;
    #20
    R <= 0;
    Equal <= 0;
    beq <= 0;
    bne <= 1;
    B <= 2'b00;
    rsn <= 5'b00000;
    //beq≤‚ ‘
    #20
    R <= 0;
    Equal <= 1;
    beq <= 1;
    bne <= 0;
    B <= 2'b00;
    rsn <= 5'b00000;
    #20
    R <= 0;
    Equal <= 0;
    beq <= 1;
    bne <= 0;
    B <= 2'b00;
    rsn <= 5'b00000;
    //BLEZ≤‚ ‘
    #20
    R <= 0;
    Equal <= 1;
    beq <= 0;
    bne <= 0;
    B <= 2'b01;
    rsn <= 5'b00000;
    #20
    R <= 0;
    Equal <= 0;
    beq <= 0;
    bne <= 0;
    B <= 2'b01;
    rsn <= 5'b00000;
    //BGTZ≤‚ ‘
    #20
    R <= 0;
    Equal <= 0;
    beq <= 0;
    bne <= 0;
    B <= 2'b10;
    rsn <= 5'b00000;
    #20
    R <= 1;
    Equal <= 0;
    beq <= 0;
    bne <= 0;
    B <= 2'b10;
    rsn <= 5'b00000;
    //BLTZ≤‚ ‘
    #20
    R <= 0;
    Equal <= 0;
    beq <= 0;
    bne <= 0;
    B <= 2'b11;
    rsn <= 5'b00000;
    #20
    R <= 1;
    Equal <= 0;
    beq <= 0;
    bne <= 0;
    B <= 2'b11;
    rsn <= 5'b00000;
    //BGEZ≤‚ ‘
    #20
    R <= 0;
    Equal <= 0;
    beq <= 0;
    bne <= 0;
    B <= 2'b11;
    rsn <= 5'b00001;
    #20
    R <= 1;
    Equal <= 0;
    beq <= 0;
    bne <= 0;
    B <= 2'b11;
    rsn <= 5'b00001;
end

Branch Test(R,Equal,beq,bne,B,Branch,rsn);
endmodule
