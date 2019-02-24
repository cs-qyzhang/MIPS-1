`timescale 1ns / 1ps
/*
    module ID/EX
    input:
        clk
        rst
        stall
        
        RegWrite_in
        Jal_in
        Lui_in
        MFLO_in
        MemToReg_in
        Syscall_in
        MemSignExt_in
        MemWrite_in
        MODE_in
        Shamt_in
        Hlen_in
        AluSrcB_in
        AluOP_in
        
        ImmExt_in
        ImmExtSft_in
        r2_in
        r1_in
        pc_in
        ir_in

        wback_in
          
   output:
        clk
           rst
           stall
           
           RegWrite_out
           Jal_out
           Lui_out
           MFLO_out
           MemToReg_out
           Syscall_out
           MemSignExt_out
           MemWrite_out
           MODE_out
           Shamt_out
           Hlen_out
           AluSrcB_out
           AluOP_out
           
           ImmExt_out
           ImmExtSft_out
           r2_out
           r1_out
           pc_out
           ir_out

           wback_out           
*/
module ID_EX(
    clk,rst,stall, //always
    RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, MemSignExt_in,RegDst_in,//in
    MemWrite_in, MODE_in, Shamt_in, Hlen_in, AluSrcB_in, AluOP_in, ImmExt_in,//in
    ImmExtSft_in, r2_in, r1_in, pc_in, ir_in, Wback_in,//in
    
    RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, MemSignExt_out,RegDst_out,//out
    MemWrite_out, MODE_out, Shamt_out, Hlen_out, AluSrcB_out, AluOP_out, ImmExt_out,//out
    ImmExtSft_out, r2_out, r1_out, pc_out, ir_out,Wback_out //out 
    );

    parameter DATA_LEN=32;
    
    input clk,rst,stall;
    input RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, MemSignExt_in,RegDst_in;
    input MemWrite_in, Shamt_in, Hlen_in, AluSrcB_in;
    input [1:0]MODE_in;
    input [3:0]AluOP_in;
    input [4:0] Wback_in; 
    input [DATA_LEN-1:0]ImmExt_in,ImmExtSft_in,r2_in,r1_in,pc_in,ir_in;
    
    output reg RegWrite_out                = 0;
    output reg Jal_out                     = 0;
    output reg Lui_out                     = 0;
    output reg MFLO_out                    = 0;
    output reg MemToReg_out                = 0;
    output reg Syscall_out                 = 0;
    output reg MemSignExt_out              = 0;
    output reg RegDst_out                  = 0;
    output reg MemWrite_out                = 0;
    output reg Shamt_out                   = 0;
    output reg Hlen_out                    = 0;
    output reg AluSrcB_out                 = 0;
    output reg [1:0]MODE_out               = 0;
    output reg [3:0]AluOP_out              = 0;
    output reg [4:0]Wback_out              = 0;
    output reg [DATA_LEN-1:0]ImmExt_out    = 0;
    output reg [DATA_LEN-1:0]ImmExtSft_out = 0;
    output reg [DATA_LEN-1:0]r2_out        = 0;
    output reg [DATA_LEN-1:0]r1_out        = 0;
    output reg [DATA_LEN-1:0]pc_out        = 0;
    output reg [DATA_LEN-1:0]ir_out        = 0;

        
    always@(posedge clk)
        begin
            if(rst)
            begin
                {RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, MemSignExt_out,RegDst_out,
                MemWrite_out,Shamt_out, Hlen_out, AluSrcB_out,
                MODE_out, AluOP_out, Wback_out,
                ImmExtSft_out,r2_out,r1_out,pc_out,ir_out}<=0;
            end
            else if(stall)
                begin
                ;
                end
            else 
                begin
                    {RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, MemSignExt_out,RegDst_out,
                    MemWrite_out,Shamt_out, Hlen_out, AluSrcB_out,
                    MODE_out, AluOP_out, Wback_out,
                    ImmExtSft_out,r2_out,r1_out,pc_out,ir_out}
                    <=
                    {RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, MemSignExt_in,RegDst_in,
                    MemWrite_in, Shamt_in, Hlen_in, AluSrcB_in,
                    MODE_in,AluOP_in,Wback_in,
                    ImmExtSft_in,r2_in,r1_in,pc_in,ir_in};   
                end
        end   
endmodule
