`timescale 1ns / 1ps
module MEM_WB(
        clk,rst,stall,//always
        
        RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, RegDst_in,
        MODE_in, LO_R_in,LO_Out_in,Wback_in,
        MemOut_in, ImmExt_in, ImmExtSft_in, r2_in, r1_in, pc_in, ir_in,
           
        RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, RegDst_out,
        MODE_out, LO_R_out,LO_Out_out,Wback_out,
        MemOut_out, ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out  
    );
    parameter DATA_LEN=32;
    
    input  clk, rst, stall, RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, RegDst_in;
    input [1:0]MODE_in;
    input [4:0]Wback_in;
    input  [DATA_LEN-1:0] MemOut_in, ImmExt_in, ImmExtSft_in, r2_in, r1_in, pc_in, ir_in, LO_R_in,LO_Out_in;
    
    output reg RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, RegDst_out;
    output reg [1:0] MODE_out;
    output reg [4:0] Wback_out;
    output reg [DATA_LEN-1:0]LO_R_out,LO_Out_out,MemOut_out, ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out;  
           
initial
    begin
         {RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, RegDst_out,
          MODE_out, LO_R_out,LO_Out_out,Wback_out,
          MemOut_out, ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out}<=0;  
    end
always 
    begin
        if(rst)
            begin
              {RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, RegDst_out,
              MODE_out, LO_R_out,LO_Out_out,Wback_out,
              MemOut_out, ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out}<=0;    
            end
        else if(stall)
            begin
            ;
            end
        else
            begin
                {RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, RegDst_out,
                MODE_out, LO_R_out,LO_Out_out,Wback_out,
                MemOut_out, ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out}
                <= 
                {RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, RegDst_in,
                MODE_in, LO_R_in,LO_Out_in,Wback_in,
                MemOut_in, ImmExt_in, ImmExtSft_in, r2_in, r1_in, pc_in, ir_in};
            end
    end
endmodule
