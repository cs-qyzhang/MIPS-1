`timescale 1ns / 1ps
`include "MIPS-1.vh"

/*
 * 顶层模块
 *
 * input:
 *      clk:
 *      sw:
 *      seg:
 *      an:
 *
 * output:
 *      led:
 *
 */
module main(clk);
    input   clk;

    wire[31:0]  pc;
    wire        rst;
    wire        pc_valid;

    wire[5:0]   op, func;
    wire[4:0]   rs, rt, rd;
    wire[15:0]  imm;
    wire[25:0]  imm26;

    wire[31:0]  npc, npc_rs;

    wire        MemToReg, MemWrite;
    wire        alu_src, shamt_src;
    wire        RegWrite, RegDst;
    wire        syscall;
    wire        SignedExt, mem_signed_ext;
    wire        beq, bne;
    wire        jr, jmp, jal;
    wire        lui, mflo;
    wire        hlen;
    wire[1:0]   b_branch;

    wire[4:0]   rsn;
    wire[1:0]   B;

    wire[31:0]  R1, R2, regfile_din;
    wire[4:0]   ra, rb, rw;
    wire        regfile_we;

    wire[31:0]  A, B;
    wire        equal;
    wire[3:0]   aluop;
    wire[4:0]   shmat;
    wire[31:0]  result, result2;

    wire[31:0]  ram_addr;
    wire[31:0]  ram_din, ram_dout;
    wire[1:0]   ram_mode;
    wire        ram_we;

    wire[31:0]  ins_addr, ins;
    wire        rom_sel;

    wire[31:0]  a0, v0;
    wire        pause, go, print;
    wire[31:0]  led_data;
    wire[3:0]   print_mode;

`ifdef  DEBUG
    assign cp = clk;
`else
    divider #(10000) divider(clk, cp);
`endif

    Pc pc(
        .npc(npc),
        .rst(rst),
        .clk(cp),
        .pc_valid(pc_valid),
        .pc(pc)
    );

    Npc npc(
        .pc(pc),
        .clk(cp),
        .rst(rst),
        .imm(imm),
        .imm26(imm26),
        .branch(branch),
        .rs(npc_rs),
        .jr(jr),
        .jmp(jmp),
        .npc(npc)
    );

    Controller controller(
        .op_code(op),
        .func(func),
        .alu_op(aluop),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .alu_src(alu_src), 
        .shamt_src(shmat_src),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .syscall(syscall),
        .SignedExt(SignedExt),
        .mem_signed_ext(mem_signed_ext),
        .beq(beq),
        .bne(bne),
        .jr(jr),
        .jmp(jmp),
        .jal(jal),
        .lui(lui),
        .mflo(mflo),
        .hlen(hlen),
        .mode(ram_mode),
        .b_branch(b_branch)
    );

    ROM #(.ADDR_LEN(`ADDR_WIDTH),.DATA_LEN(32)) rom(
        .addr(ins_addr),
        .sel(rom_sel),
        .data(ins)
    );

    RegFile regfile(
        .clk(cp),
        .ra(ra),
        .rb(rb),
        .rw(rw),
        .we(regfile_we),
        .din(regfile_din),
        .R1(R1),
        .R2(R2)
    );

    ALU alu(
        .A(A),
        .B(A),
        .Shmat(shmat),
        .AluOp(aluop),
        .Equal(equal),
        .Result(result),
        .Result2(result2)
    );

    RAM #(.ADDR_LEN(`ADDR_WIDTH),.DATA_LEN(32)) ram(
        .clk(clk),
        .rst(rst),
        .addr(ram_addr),
        .sel(ram_sel),
        .read_en(ram_re),
        .write_en(ram_we),
        .data_in(ram_din),
        .data_out(ram_dout)
    );

    Branch branch(
        .R(R),
        .Equal(equal),
        .beq(beq),
        .bne(bne),
        .B(B),
        .Branch(branch),
        .rsn(rsn)
    );

    Syscall syscall(
        .clk(cp),
        .rst(rst),
        .syscall(syscall),
        .go(go),
        .a0(a0),
        .v0(v0),
        .pause(pause),
        .print(prints),
        .led_data(led_data),
        .print_mode(print_mode)
    );

    Print #(.SHOW_WIDTH(32)) print(
        .data(led_data),
        .prints(prints),
        .print_mode(print_mode),
        .clk(clk),
        .an(an),
        .seg(seg)
    );

    assign  op    = ins[31:26];
    assign  rs    = ins[25:21];
    assign  rt    = ins[20:16];
    assign  rd    = ins[15:11];
    assign  shmat = ins[10:6];
    assign  func  = ins[5:0];
    assign  imm   = ins[15:0];
    assign  imm26 = ins[25:0];

    assign  ins_addr = pc[ADDR_WIDTH-1:0];

endmodule
