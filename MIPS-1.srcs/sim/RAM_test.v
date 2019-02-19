`timescale 1ns / 1ps
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
module RAM_test;
    reg clk_t,rst_t,read_en_t,write_en_t;
    reg [7:0]addr_t;
    reg [7:0]data_in_t;
    reg [3:0]sel_t;
    wire [7:0]data_out_t;
   
    initial 
        begin
            clk_t<=0;
            rst_t<=0;
            read_en_t<=0;
            write_en_t<=0;
            addr_t<=0;
            data_in_t<=0;
            sel_t<=0;
            #120 rst_t<=~rst_t;
            #200 rst_t<=~rst_t;
            
            #200 sel_t<=4'b1111;
            #10 read_en_t<=1;
            #20 read_en_t<=0;
            
            #20 read_en_t<=1;
            #20 read_en_t<=0;
            
            #50 data_in_t<=8'b10101010;
            
            #20 write_en_t<=1;
            #20 write_en_t<=0;
            
            #30 read_en_t<=1;
            #20 read_en_t<=0;
             
            #30 rst_t<=1;
            #20 rst_t<=0;
            
            #30 read_en_t<=1;
            #20 read_en_t<=0;
            
            #30 addr_t=8'b00000001;
                data_in_t=8'b11111111;
                sel_t=4'b0110;
                
            #20 write_en_t<=1;
            #20 write_en_t<=0;
            
            #30 read_en_t<=1;
            #20 read_en_t<=0;
            
             #30 addr_t=8'b00000000;
             #30 read_en_t<=1;
             #20 read_en_t<=0;
             
             
            
            
        end
        
    always 
        begin
            #2 clk_t<=~clk_t;
        end
        
    RAM test(
        .clk(clk_t),
        .rst(rst_t),
        .addr(addr_t),
        .sel(sel_t),
        .read_en(read_en_t),
        .write_en(write_en_t),
        .data_in(data_in_t),
        .data_out(data_out_t)
        );
   
endmodule