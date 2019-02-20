`timescale 1ns / 1ps
/*
 * 打印
 *
 * input:
 *      data:
 *      prints:
 *      print_mode:
 *      clk
 *
 * output:
 *      an
 *      seg 
 *      
 */
module print_test;

    parameter SHOW_WIDTH=32;
    
    reg [SHOW_WIDTH:0]data_t;
    reg prints_t;
    reg [1:0]print_mode_t;
    reg clk_t;
    
    wire [2:0]an_t;
    wire [7:0]seg_t;
    
    initial
        begin
            clk_t<=0;
            data_t<=0;
            prints_t<=0;
            print_mode_t<=0; 
          
            #50 data_t=32'h12345678;
            #150 prints_t=1;
            #30 prints_t=0;
            
            #200 data_t=32'h88899900;
            #10 prints_t<=1;
            #30 prints_t<=0;  
             
        end
        
    always 
        begin
            #15 clk_t<=~clk_t;
        end 
    Print print_test(
        .data(data_t),
        .prints(prints_t),
        .print_mode(print_mode_t),
        .clk(clk_t),
        .an(an_t),
        .seg(seg_t)
        );
           
     
endmodule
