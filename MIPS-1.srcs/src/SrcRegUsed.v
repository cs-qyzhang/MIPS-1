`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * SrcRegUsed
 * 
 * input:
 *    op_code
 *    func
 *
 * output:
 *    R1_Used: R1是否作为ID段源寄存器
 *    R2_Used: R2是否作为ID段源寄存器
 *
 * TODO: 使用verilog udp真值表描述？
 */
module SrcRegUsed(
  op_code, func,
  R1_Used, R2_Used
  );

  input [5:0] op_code;
  input [5:0] func;

  output R1_Used;
  output R2_Used;

  wire sll, sra, srl;
  // wire add, addu;
  // wire sub;
  // wire And, Or, Nor;
  // wire slt, sltu;
  wire j;
  wire addi;
  wire andi;
  wire addiu;
  wire slti;
  wire ori;
  wire lw;
  // wire sw;
  // wire sllv, srlv, srav;
  // wire subu;
  // wire Xor;
  wire Xori;
  wire lui;
  wire sltiu;
  // wire multu, divu;
  wire lb, lbu, lh, lhu;
  // wire sb, sh;
  wire blez, bgtz, bltz, bgez;

  assign sll = (func == `SLL_FUNC) & (op_code == `ZERO_OP);
  assign sra = (func == `SRA_FUNC) & (op_code == `ZERO_OP);
  assign srl = (func == `SRL_FUNC) & (op_code == `ZERO_OP);
  // assign add = (func == `ADD_FUNC) & (op_code == `ZERO_OP);
  // assign addu = (func == `ADDU_FUNC) & (op_code == `ZERO_OP);
  // assign sub = (func == `SUB_FUNC) & (op_code == `ZERO_OP);
  // assign And = (func == `AND_FUNC) & (op_code == `ZERO_OP);
  // assign Or = (func == `OR_FUNC) & (op_code == `ZERO_OP);
  // assign Nor = (func == `NOR_FUNC) & (op_code == `ZERO_OP);
  // assign slt = (func == `SLT_FUNC) & (op_code == `ZERO_OP);
  // assign sltu = (func == `SLTU_FUNC) & (op_code == `ZERO_OP);
  assign jr = (func == `JR_FUNC) & (op_code == `ZERO_OP);
  // assign syscall = (func == `SYS_FUNC) & (op_code == `ZERO_OP);

  assign j = (op_code == `J_OP);
  assign jal = (op_code == `JAL_OP);
  // assign beq = (op_code == `BEQ_OP); 
  // assign bne = (op_code == `BNE_OP); 
  assign addi = (op_code == `ADDI_OP); 
  assign andi = (op_code == `ANDI_OP);
  assign addiu = (op_code == `ADDIU_OP);
  assign slti = (op_code == `SLTI_OP);
  assign ori = (op_code == `ORI_OP);
  assign lw = (op_code == `LW_OP);
  // assign sw = (op_code == `SW_OP);
  // 
  // assign sllv = (func == `SLLV_FUNC) & (op_code == `ZERO_OP);
  // assign srlv = (func == `SRLV_FUNC) & (op_code == `ZERO_OP);
  // assign srav = (func == `SRAV_FUNC) & (op_code == `ZERO_OP);
  // assign subu = (func == `SUBU_FUNC) & (op_code == `ZERO_OP);
  // assign Xor = (func == `XOR_FUNC) & (op_code == `ZERO_OP);

  assign Xori = (op_code == `XORI_OP);
  assign lui = (op_code == `LUI_OP);
  assign sltiu = (op_code == `SLTIU_OP);

  // assign multu = (func == `MULTU_FUNC) & (op_code == `ZERO_OP);
  // assign divu = (func == `DIVU_FUNC) & (op_code == `ZERO_OP);
  assign mflo = (func == `MFLO_FUNC) & (op_code == `ZERO_OP);
  
  assign lb = (op_code == `LB_OP);
  assign lbu = (op_code == `LBU_OP);
  assign lh = (op_code == `LH_OP);
  assign lhu = (op_code == `LHU_OP);
  // assign sb = (op_code == `SB_OP);
  // assign sh = (op_code == `SH_OP);

  assign blez = (op_code == `BLEZ_OP);
  assign bgtz = (op_code == `BGTZ_OP);
  assign bltz = (op_code == `BLTZ_OP);
  assign bgez = (op_code == `BGEZ_OP);

  assign R1_Used = !(sll | sra | srl |
                      j | jal |
                      lui |
                      mflo);

  assign R2_Used = !(jr | j | jal |
                      addi | andi | addiu | slti | ori |
                      lw |
                      Xori |
                      lui |
                      sltiu |
                      mflo |
                      lb | lbu | lh | lhu |
                      blez | bgtz | bltz | bgez);

endmodule
