`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * controller
 * 
 * input:
 *    op_code
 *    func
 *
 * output:
 *    alu_op: alu功能选择
 *    其他一系列控点，具体见表格
 *
 * TODO: 使用verilog udp真值表描述？
 */
module controller(
  op_code, func,
  alu_op,
  MemToReg, MemWrite,
  alu_src, shamt_src,
  RegWrite, RegDst,
  syscall,
  SignedExt, mem_signed_ext,
  beq, bne,
  jr, jmp, jal,
  lui, mflo,
  hlen,
  mode,
  b_branch
  );

  input [5:0] op_code;
  input [5:0] func;

  output [3:0] alu_op;
  output MemToReg, MemWrite;
  output alu_src, shamt_src;
  output RegWrite, RegDst;
  output syscall;
  output SignedExt, mem_signed_ext;
  output beq, bne;
  output jr, jmp, jal;
  output lui, mflo;
  output hlen;
  output [1:0] mode;
  output [1:0] b_branch;

  wire sll, sra, srl;
  wire add, addu;
  wire sub;
  wire And, Or, Nor;
  wire j;
  wire slt, sltu;
  wire addi;
  wire andi;
  wire addiu;
  wire slti;
  wire ori;
  wire lw, sw;
  wire sllv, srlv, srav;
  wire subu;
  wire Xor, Xori;
  wire lui;
  wire sltiu;
  wire multu, divu;
  wire lb, lbu, lh, lhu;
  wire sb, sh;
  wire blez, bgtz, bltz, bgez;

  assign sll = (func == `SLL_FUNC) & (op_code == `ZERO_OP);
  assign sra = (func == `SRA_FUNC) & (op_code == `ZERO_OP);
  assign srl = (func == `SRL_FUNC) & (op_code == `ZERO_OP);
  assign add = (func == `ADD_FUNC) & (op_code == `ZERO_OP);
  assign addu = (func == `ADDU_FUNC) & (op_code == `ZERO_OP);
  assign sub = (func == `SUB_FUNC) & (op_code == `ZERO_OP);
  assign And = (func == `AND_FUNC) & (op_code == `ZERO_OP);
  assign Or = (func == `OR_FUNC) & (op_code == `ZERO_OP);
  assign Nor = (func == `NOR_FUNC) & (op_code == `ZERO_OP);
  assign slt = (func == `SLT_FUNC) & (op_code == `ZERO_OP);
  assign sltu = (func == `SLTU_FUNC) & (op_code == `ZERO_OP);
  assign jr = (func == `JR_FUNC) & (op_code == `ZERO_OP);
  assign syscall = (func == `SYS_FUNC) & (op_code == `ZERO_OP);

  assign j = (op_code == `J_OP);
  assign jal = (op_code == `JAL_OP);
  assign beq = (op_code == `BEQ_OP); 
  assign bne = (op_code == `BNE_OP); 
  assign addi = (op_code == `ADDI_OP); 
  assign andi = (op_code == `ANDI_OP);
  assign addiu = (op_code == `ADDIU_OP);
  assign slti = (op_code == `SLTI_OP);
  assign ori = (op_code == `ORI_OP);
  assign lw = (op_code == `LW_OP);
  assign sw = (op_code == `SW_OP);
  
  assign sllv = (func == `SLLV_FUNC) & (op_code == `ZERO_OP);
  assign srlv = (func == `SRLV_FUNC) & (op_code == `ZERO_OP);
  assign srav = (func == `SRAV_FUNC) & (op_code == `ZERO_OP);
  assign subu = (func == `SUBU_FUNC) & (op_code == `ZERO_OP);
  assign Xor = (func == `XOR_FUNC) & (op_code == `ZERO_OP);

  assign Xori = (op_code == `XORI_OP);
  assign lui = (op_code == `LUI_OP);
  assign sltiu = (op_code == `SLTIU_OP);

  assign multu = (func == `MULTU_FUNC) & (op_code == `ZERO_OP);
  assign divu = (func == `DIVU_FUNC) & (op_code == `ZERO_OP);
  assign mflo = (func == `MFLO_FUNC) & (op_code == `ZERO_OP);
  
  assign lb = (op_code == `LB_OP);
  assign lbu = (op_code == `LBU_OP);
  assign lh = (op_code == `LH_OP);
  assign lhu = (op_code == `LHU_OP);
  assign sb = (op_code == `SB_OP);
  assign sh = (op_code == `SH_OP);

  assign blez = (op_code == `BLEZ_OP);
  assign bgtz = (op_code == `BGTZ_OP);
  assign bltz = (op_code == `BLTZ_OP);
  assign bgez = (op_code == `BGEZ_OP);

  assign alu_op = (sll | sllv) ? `ALU_SLL:
                  (sra | srav) ? `ALU_SRA:
                  (srl | srlv) ? `ALU_SRL:
                  (multu) ? `ALU_MUL:
                  (divu) ? `ALU_DIV:
                  (add | addu | addi | addiu | lw | sw | lb | lbu | lh | lhu | sb | sh) ? `ALU_ADD :
                  (sub | subu) ? `ALU_SUB:
                  (And | andi) ? `ALU_AND:
                  (Or | ori) ? `ALU_OR:
                  (Xor | Xori) ? `ALU_XOR:
                  (Nor) ? `ALU_NOR:
                  (slt | slti | sltiu | blez | bgtz | bltz | bgez) ? `ALU_SLT:
                  (sltu) ? `ALU_SLTU: 4'd15; //剩下的指令alu_op全1

  assign MemToReg = (lw | lb | lbu | lh | lhu);
  assign MemWrite = (sw | sb | sh);
  assign alu_src = (addi | andi | addiu | 
                    slti | ori | 
                    lw | sw | 
                    Xori | sltiu | 
                    lb | lbu | lh | lhu | 
                    sb | sh);
  assign RegWrite = sll | sra | srl |
                    add | addu |
                    sub |
                    And | Or | Nor |
                    slt | sltu |
                    jal |
                    addi | andi | addiu |
                    slti |
                    ori |
                    lw |
                    sllv | srlv | srav |
                    subu |
                    Xor | Xori |
                    lui | sltiu |
                    mflo |
                    lb | lbu | lh | lhu;
  assign SignedExt = addi | addiu |
                      slti |
                      lw | sw |
                      sltiu |
                      lb | lbu | lh | lhu |
                      sb | sh;
  assign RegDst = sll | sra | srl |
                  add | addu |
                  sub |
                  And | Or | Nor |
                  slt | sltu |
                  sllv | srlv | srav |
                  subu |
                  Xor |
                  mflo;
  assign jmp = (jr | j | jal);
  assign shamt_src = (sllv | srlv | srav);
  assign hlen = (multu | divu);
  assign mode[1] = (lh | lhu | sh);
  assign mode[0] = (lb | lbu | sb);
  assign mem_signed_ext = (lb | lh);
  assign b_branch[1] = (bgtz | bltz | bgez);
  assign b_branch[0] = (blez | bgtz | bgez);

endmodule
