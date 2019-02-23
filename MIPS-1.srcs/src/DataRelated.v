`timescale 1ns / 1ps

/*
 * DataRelated
 * 
 * input:
 *    OP           : 32位指令IR的op字段
 *    FUNC         : 32位指令IR的func字段
 *    ex_regwrite  : ex阶段的寄存器写回信号
 *    mem_regwrite : mem阶段的寄存器写回信号
 *    id_r1        : ID阶段寄存器R1的地址
 *    id_r2        : ID阶段寄存器R2的地址
 *    mem_memtoreg : mem阶段RAM读出信号
 *    ex_memtoreg  : ex阶段RAM读出信号
 *    ex_wb        : ex阶段寄存器写回地址
 *    mem_wb       : mem阶段寄存器写回地址
 *
 * output:
 *    r1_forward : ID阶段R1寄存器多路选择信号
 *    r2_forward : ID阶段R2寄存器多路选择信号
 *    load_use   : 是否为Load-Use相关
 *
 * TODO:运算溢出？Result2默认值设置？
 */
module DataRelated(
  OP,
  FUNC,
  ex_regwrite, mem_regwrite,
  id_r1, id_r2,
  mem_memtoreg, ex_memtoreg,
  ex_wb, mem_wb,
  r1_forward, r2_forward,
  load_use
  );

    input [5:0]OP,FUNC;
    input [4:0]id_r1,id_r2,ex_wb,mem_wb;
    output [1:0]r1_forward,r2_forward;
    input ex_regwrite,mem_regwrite,mem_memtoreg,ex_memtoreg;
    output load_use;
    
    wire r1_used,r2_used;
    wire data_related;
    
    //调用源寄存器使用情况
    SrcRegUsed SrcRegUsed_gen(OP, FUNC, r1_used, r2_used);
    
    assign r1_forward[0] = (id.r1 == ex_wb) & (ex_regwrite & r1_used);
    assign r1_forward[1] = (id_r1 == mem_wb) & (mem_regwrite & r1_used);
    assign r2_forward[0] = (id_r2 == ex_wb) & (ex_regwrite & r2_used);
    assign r2_forward[1] = (id_r2 == mem_wb) & (mem_regwrite & r2_used);
    
    assign data_related = r1_forward[0] | r1_forward[1] | r2_forward[0] | r2_forward[1];
    assign load_use = data_related & (ex_memtoreg | mem_memtoreg);
    
endmodule
