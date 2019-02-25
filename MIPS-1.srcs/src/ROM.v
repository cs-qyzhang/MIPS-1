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
    parameter DATA_NUM=1024;
    
    input [ADDR_LEN-1:0]addr;
    input sel;
    output  [DATA_LEN-1:0]data;
    
    (* rom_style = "block" *)reg[DATA_LEN-1:0]my_rom[DATA_NUM-1:0];
    
    initial 
        begin
`ifdef QY_ZHANG
            $readmemh("/home/qyzhang/ROM_GO_EXCEPTION_MULTI.txt",my_rom); 
`else
            //$readmemh("/media/psf/Home/Desktop/ROM.txt",my_rom);
            $readmemh("/home/longj/MIPS-1/汇编工具及测试用例4.31/rom.txt", my_rom); 
`endif
        end

        assign data=sel?my_rom[addr]:'bz;

endmodule
