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
module ROM_test;
     parameter ADDR_LEN=32;
     parameter DATA_LEN=32;
     
     reg [ADDR_LEN:0]addr_t;
     reg sel_t;
     wire [DATA_LEN:0]data_t;
     //wire [DATA_LEN:0]rom_t;
     integer i;
     initial 
        begin
            addr_t<=0;
            sel_t<=0;
 
            #200 addr_t<=0;
            #10 sel_t<=1;
            
            for(i=0;i<10;i=i+1)
                begin
                 #60 addr_t=addr_t+1;
                end   
            #10 sel_t<=0;     
         
        end
        
     ROM rom_ut(
        .addr(addr_t),
        .sel(sel_t),
        .data(data_t)
        );
     
endmodule