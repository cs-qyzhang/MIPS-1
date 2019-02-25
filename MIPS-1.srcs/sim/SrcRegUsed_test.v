`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * SrcRegUsed测试模块
 */
module SrcRegUsed_test();

  reg [5 : 0] op_code;
  reg [5 : 0] func;

  wire R1_Used;
  wire R2_Used;

  SrcRegUsed SrcRegUsed_tb(
    .op_code(op_code),
    .func(func),
    .R1_Used(R1_Used),
    .R2_Used(R2_Used)
  );

  initial
    begin
      op_code = `ZERO_OP;
      func = `SLL_FUNC;
      #5
      func = `SRA_FUNC;
      #5
      func = `SRL_FUNC;
      #5
      func = `ADD_FUNC;
      #5
      func = `ADDU_FUNC;
      #5
      func = `SUB_FUNC;
      #5
      func = `AND_FUNC;
      #5
      func = `OR_FUNC;
      #5
      func = `NOR_FUNC;
      #5
      func = `SLT_FUNC;
      #5
      func = `SLTU_FUNC;
      #5 
      func = `JR_FUNC;
      #5
      func = `SYS_FUNC;
      #5
      op_code = `J_OP;
      #5
      op_code = `JAL_OP;
      #5
      op_code = `BEQ_OP;
      #5
      op_code = `BNE_OP;
      #5
      op_code = `ADDI_OP;
      #5
      op_code = `ANDI_OP;
      #5
      op_code = `ADDIU_OP;
      #5
      op_code = `SLTI_OP;
      #5
      op_code = `ORI_OP;
      #5
      op_code = `LW_OP;
      #5
      op_code = `SW_OP;
      #5
      op_code = `ZERO_OP;
      func = `SLLV_FUNC;
      #5
      func = `SRLV_FUNC;
      #5
      func = `SRAV_FUNC;
      #5
      func = `SUBU_FUNC;
      #5
      func = `XOR_FUNC;
      #5
      op_code = `XORI_OP;
      #5
      op_code = `LUI_OP;
      #5
      op_code = `SLTIU_OP;
      #5
      op_code = `ZERO_OP;
      func = `MULTU_FUNC;
      #5
      func = `DIVU_FUNC;
      #5
      func = `MFLO_FUNC;
      #5
      op_code = `LB_OP;
      #5
      op_code = `LBU_OP;
      #5
      op_code = `LH_OP;
      #5
      op_code = `LHU_OP;
      #5
      op_code = `SB_OP;
      #5
      op_code = `SH_OP;
      #5
      op_code = `BLEZ_OP;
      #5
      op_code = `BGTZ_OP;
      #5
      op_code = `BLTZ_OP;
      #5
      op_code = `BGEZ_OP;
    end
    

endmodule

