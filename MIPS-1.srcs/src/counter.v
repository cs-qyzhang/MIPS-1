`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * 计数器
 *
 * input:
 *      count: 计数信号
 *      clk:
 *      rst:
 *      ld: 加载信号
 *      data: 加载数据
 *
 * output:
 *      cnt: 当前计数值
 *
 */
module Counter(clk,rst,count,ld,data,cnt);
    input           clk, rst, count, ld;
    input[31:0] data;
    output reg[31:0]cnt;

    initial
            cnt <= 0;

    always
        @(posedge clk or posedge rst)
        begin
            if (rst)
                cnt <= 0;
            else if (ld)
                cnt <= data;
            else if (count)
                cnt <= cnt + 'b1;
            else
                ;
        end

endmodule
