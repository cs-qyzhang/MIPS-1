`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * 打印模
 *
 * input:
 *      data:
 *      prints:
 *      print_mode:
 *      clk
 * output:
 *      an
 *      seg 
 *      
 */
module Print(data,prints,print_mode,clk,an,seg);
    parameter SHOW_WIDTH=32;
    parameter LED0=3'd0,LED1=3'd1,LED2=3'd2,LED3=3'd3,LED4=3'd4,LED5=3'd5,LED6=3'd6,LED7=3'd7;
    
    input [SHOW_WIDTH-1:0]data;
    input prints,clk;
    input[3:0] print_mode;
    output reg [7:0]an = 0;
    output  [7:0]seg;
    
    wire clk_n;
    reg [SHOW_WIDTH-1:0]show_data = 0;
    reg [3:0]show_number = 0;
    reg [31:0] i = 0;
     
    always @(negedge clk_n)
        begin
            if(prints) 
                begin
                   show_data<=data;
                end
             else 
                begin 
                   show_data<=show_data;
                end 
          
            case(i)
                LED0:
                    begin
                        an=8'b11111110;
                        show_number=show_data[3:0];
                        i=LED1;
                        
                    end
                LED1:
                    begin
                        an=8'b11111101;
                        show_number=show_data[7:4];
                        i=LED2;
                    end
                LED2:
                    begin
                        an=8'b11111011;
                        show_number=show_data[11:8];
                        i=LED3;
                    end
                LED3:
                    begin
                        an=8'b11110111;
                        show_number<=show_data[15:12];
                        i=LED4;
                    end
                LED4:
                    begin
                        an=8'b11101111;
                        show_number<=show_data[19:16];
                        i=LED5;
                    end
                LED5:
                     begin
                        an=8'b11011111;
                        show_number<=show_data[23:20];
                        i=LED6;
                    end
                LED6:
                    begin
                        an=8'b10111111;
                        show_number<=show_data[27:24];
                        i=LED7;
                    end
                LED7:
                    begin
                        an=8'b01111111;
                        show_number<=show_data[31:28];
                        i=LED0;
                    end
                default:
                    begin
                        an=8'b0;
                    end
            endcase
        end
        
        Pattern
            led0(show_number,seg);
        Divider #(50000)
            divider0(clk,clk_n);
endmodule

module Pattern(code, patt);
    input [3: 0] code;            
    output reg [7:0] patt; 
 
    always
        @(code) begin
            case(code)
                4 'b0000 : patt = 8'b11000000;
                4 'b0001 : patt = 8'b11111001;
                4 'b0010 : patt = 8'b10100100;
                4 'b0011 : patt = 8'b10110000;
                4 'b0100 : patt = 8'b10011001;
                4 'b0101 : patt = 8'b10010010;
                4 'b0110 : patt = 8'b10000010;
                4 'b0111 : patt = 8'b11111000;
                4 'b1000 : patt = 8'b10000000;
                4 'b1001 : patt = 8'b10011000;
                4 'b1010 : patt = 8'b10001000;
                4 'b1011 : patt = 8'b10000011;
                4 'b1100 : patt = 8'b11000110;
                4 'b1101 : patt = 8'b10100001;
                4 'b1110 : patt = 8'b10000110;
                4 'b1111 : patt = 8'b10001110;
            endcase
    end

endmodule
