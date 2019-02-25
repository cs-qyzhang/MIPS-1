`timescale 1ns / 1ps
/*
    module EX/MEM

*/
module EX_MEM(
        clk,rst,stall,//always
        
        RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, MemSignExt_in,RegDst_in,
        MemWrite_in, MODE_in, LO_R_in,LO_Out_in,Wback_in,
        ImmExt_in, ImmExtSft_in, r2_in, r1_in, pc_in, ir_in,
           
        RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, MemSignExt_out,RegDst_out,
        MemWrite_out, MODE_out, LO_R_out,LO_Out_out,Wback_out,
        ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out  
        );
        parameter DATA_LEN=32;
        
        input clk, rst, stall;//in
        input RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, MemSignExt_in, MemWrite_in, RegDst_in;//in
        input [1:0]MODE_in;//in
        input [4:0]Wback_in;
        input [DATA_LEN-1:0] LO_R_in, LO_Out_in, ImmExt_in, ImmExtSft_in, r2_in, r1_in, pc_in, ir_in;//in
        
        output reg RegWrite_out                 = 1'b0;
        output reg Jal_out                      = 1'b0;
        output reg Lui_out                      = 1'b0;
        output reg MFLO_out                     = 1'b0;
        output reg MemToReg_out                 = 1'b0;
        output reg Syscall_out                  = 1'b0;
        output reg MemSignExt_out               = 1'b0;
        output reg MemWrite_out                 = 1'b0;
        output reg RegDst_out                   = 1'b0;
        output reg [1:0] MODE_out               = 2'b0;
        output reg [4:0] Wback_out              = 5'b0;
        output reg [DATA_LEN-1:0] LO_R_out      = DATA_LEN*1'b0;
        output reg [DATA_LEN-1:0] LO_Out_out    = DATA_LEN*1'b0;
        output reg [DATA_LEN-1:0] ImmExt_out    = DATA_LEN*1'b0;
        output reg [DATA_LEN-1:0] ImmExtSft_out = DATA_LEN*1'b0;
        output reg [DATA_LEN-1:0] r2_out        = DATA_LEN*1'b0;
        output reg [DATA_LEN-1:0] r1_out        = DATA_LEN*1'b0;
        output reg [DATA_LEN-1:0] pc_out        = DATA_LEN*1'b0;
        output reg [DATA_LEN-1:0] ir_out        = DATA_LEN*1'b0;
          
        always @(posedge clk)
            begin
                if(rst)
                    begin
                        {RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, MemSignExt_out,RegDst_out,
                         MemWrite_out, MODE_out, LO_R_out,LO_Out_out,Wback_out,
                         ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out} <=0;
                    end
                else if(stall)
                    begin
                        ;
                    end
                else
                    begin
                         {
                          RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, MemSignExt_out,RegDst_out,
                          MemWrite_out, MODE_out, LO_R_out,LO_Out_out,Wback_out,
                          ImmExt_out, ImmExtSft_out, r2_out, r1_out, pc_out, ir_out
                          } 
                          <=
                          {
                          RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, MemSignExt_in,RegDst_in,
                          MemWrite_in, MODE_in, LO_R_in,LO_Out_in,Wback_in,
                          ImmExt_in, ImmExtSft_in, r2_in, r1_in, pc_in, ir_in
                          };
                    end  
                  
            end
endmodule

