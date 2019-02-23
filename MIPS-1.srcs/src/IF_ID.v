`timescale 1ns / 1ps
/*
 module IF/ID
 input:
    clk
    rst
    stall
    pc_if
    ir_if
 output:
    pc_id
    ir_id
 */
module IF_ID(
            clk,rst,stall, //always
            pc_in,  ir_in, //in
            pc_out,  ir_out  //out
            );
            
    parameter DATA_LEN=32;
    parameter ADDR_LEN=32;

    input clk,rst,stall;
    input [DATA_LEN-1:0]pc_in;
    input [ADDR_LEN-1:0]ir_in;
    
    output reg [DATA_LEN-1:0]pc_out = 0;
    output reg [ADDR_LEN-1:0]ir_out = 0;
     
    always@(posedge clk)
        begin
           if(rst)
             begin
                pc_out<=0;
                ir_out<=0;
             end
           else if(!stall)
             begin
              ;
             end
           else
            begin
                pc_out<=pc_in;
                ir_out<=ir_out;
            end
        end
    
endmodule
