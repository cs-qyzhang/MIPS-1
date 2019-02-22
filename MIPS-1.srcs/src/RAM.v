`timescale 1ns / 1ps
`include "MIPS-1.vh"
/*module RAM
 *input:
 *      clk
 *      rst
 *      addr
 *      sel
 *      read_en
 *      write_en
 *      data_in
 *      data_out
 *output:
 *      data_out
 */
module RAM(clk,rst,addr,sel,read_en,write_en,data_in,data_out);
    parameter ADDR_LEN=8;
    parameter DATA_LEN=8;
    parameter DATA_NUM=100;
    
    input clk,rst,read_en,write_en;
    input [3:0]sel;
    input [ADDR_LEN-1:0]addr;
    input [DATA_LEN-1:0]data_in;
    output [DATA_LEN-1:0]data_out;
    
    reg [DATA_LEN-1:0]my_ram[DATA_NUM-1:0];
    integer i;
    
    initial
        begin
            for(i=0;i<=DATA_NUM-1;i=i+1)
                begin
                    my_ram[i]<='b0;                //without parameter
                end
        end
        
    assign data_out[(DATA_LEN/4)-1:0] = (sel[0] && read_en) ?  my_ram[addr][(DATA_LEN/4)-1:0] :   'bz;
    assign data_out[(2*DATA_LEN/4)-1:(DATA_LEN/4)] =    (sel[1] && read_en) ?   my_ram[addr][(2*DATA_LEN/4)-1:(DATA_LEN/4)] :   'bz;
    assign data_out[(3*DATA_LEN/4)-1:(2*DATA_LEN/4)] =  (sel[2] && read_en) ?   my_ram[addr][(3*DATA_LEN/4)-1:(2*DATA_LEN/4)]   :   'bz;
    assign data_out[DATA_LEN-1:(3*DATA_LEN/4)] =    (sel[3] && read_en) ?   my_ram[addr][DATA_LEN-1:(3*DATA_LEN/4)]  : 'bz;
        
    always@(negedge clk)
        begin
           if(rst)
                begin
                    for(i=0;i<=DATA_NUM-1;i=i+1)
                        begin
                            my_ram[i]<='b0;         //without parameter
                        end      
                end
                
           else if(write_en)
                begin
                    my_ram[addr][(DATA_LEN/4)-1:0]<=sel[0]?data_in[(DATA_LEN/4)-1:0]:my_ram[addr][(DATA_LEN/4)-1:0];
                    my_ram[addr][(2*DATA_LEN/4)-1:(DATA_LEN/4)]<=sel[1]?data_in[(2*DATA_LEN/4)-1:(DATA_LEN/4)]:my_ram[addr][(2*DATA_LEN/4)-1:(DATA_LEN/4)];
                    my_ram[addr][(3*DATA_LEN/4)-1:(2*DATA_LEN/4)]<=sel[2]?data_in[(3*DATA_LEN/4)-1:(2*DATA_LEN/4)]:my_ram[addr][(3*DATA_LEN/4)-1:(2*DATA_LEN/4)];
                    my_ram[addr][DATA_LEN-1:(3*DATA_LEN/4)]<=sel[3]?data_in[DATA_LEN-1:(3*DATA_LEN/4)]: my_ram[addr][DATA_LEN-1:(3*DATA_LEN/4)];
                end
                
           else 
               ;
            
        end
        
         
endmodule
