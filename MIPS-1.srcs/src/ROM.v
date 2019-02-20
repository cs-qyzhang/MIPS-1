`timescale 1ns / 1ps
`include "MIPS-1.vh"
/*
 *module ROM
 *input:
 *      addr
 *      sel
 *      clk
 *output:
 *      data             
 */
module ROM(addr,sel,data);

    parameter ADDR_LEN=32;
    parameter DATA_LEN=32;
    parameter DATA_NUM=256;
    
    input [ADDR_LEN:0]addr;
    input sel;
    output  [DATA_LEN:0]data;
    //integer i;
    reg[DATA_LEN-1:0]my_rom[DATA_NUM-1:0];
    
    initial 
        begin
            $readmemh("/media/psf/Home/Desktop/ROM.txt",my_rom); 
        end
        assign data=sel?my_rom[addr]:'bz;
endmodule