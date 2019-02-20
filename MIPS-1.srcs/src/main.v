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
    divider #(1000) divider(clk, cp);
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

    ROM rom(
        .addr(ins_addr),
        .sel(rom_sel),
        .data(ins)
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
        .print(print),
        .led_data(led_data),
        .print_mode(print_mode)
    );

    Register register(
        .data_in(data_in),
        .data_out(data_out),

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

    assign  op    = ins[31:26];
    assign  rs    = ins[25:21];
    assign  rt    = ins[20:16];
    assign  rd    = ins[15:11];
    assign  shmat = ins[10:6];
    assign  func  = ins[5:0];
    assign  imm   = ins[15:0];
    assign  imm26 = ins[25:0];

    assign  ins_addr = pc;
endmodule
