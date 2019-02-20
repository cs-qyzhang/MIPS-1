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
module Main(clk, an, seg);
    input       clk;
    input[7:0]  an, seg;

    wire[31:0]  pc, lo_out;
    wire        rst;
    wire        cp;

    wire[5:0]   op, func;
    wire[4:0]   rs, rt, rd;
    wire[4:0]   shmat;
    wire[15:0]  imm;
    wire[25:0]  imm26;
    wire[31:0]  imm_sign_ext, imm_zero_ext, imm_ext;

    wire[31:0]  npc, npc_rs;

    wire        MemToReg, MemWrite;
    wire        alu_src, shmat_src;
    wire        RegWrite, RegDst;
    wire        syscall;
    wire        SignedExt, mem_signed_ext;
    wire        beq, bne;
    wire        jr, jmp, jal;
    wire        lui, mflo;
    wire        hlen;

    wire[1:0]   b_branch;
    wire            branch;

    wire[31:0]  R1, R2, regfile_din;
    wire[4:0]   ra, rb, rw;

    wire[31:0]  A, B;
    wire        equal;
    wire[3:0]   aluop;
    wire[4:0]   alu_shmat;
    wire[31:0]  result, result2;

    wire[`ADDR_WIDTH-1:0]  ram_addr;
    wire[31:0]  ram_din, ram_dout;
    wire[1:0]   ram_mode;

    wire[`ADDR_WIDTH-1:0]  ins_addr;
    wire[31:0] ins;
    wire        rom_sel;

    wire[31:0]  a0, v0;
    wire        pause, go, prints;
    wire[31:0]  led_data;
    wire[3:0]   print_mode;

`ifdef  DEBUG
    assign cp = clk;
    assign go = 1;
    assign rst = 0;
`else
    divider #(10000) divider(clk, cp);
`endif

    Pc reg_pc(
        .npc(npc),
        .rst(rst),
        .clk(cp),
        .pc_valid(~pause),
        .pc(pc)
    );

    Register reg_lo(
        .data_in(result),
        .data_out(lo_out),
        .clk(clk),
        .rst(rst),
        .inr(mflo)
    );

    Npc npcs(
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

    Extender zero_extender(
        .Din(imm),
        .Dout(imm_zero_ext),
        .sel(1'b0)
    );

    Extender sign_extender(
        .Din(imm),
        .Dout(imm_sign_ext),
        .sel(1'b1)
    );

    assign rom_sel = 1;
    ROM #(.ADDR_LEN(`ADDR_WIDTH-2),.DATA_LEN(32)) rom(
        .addr(ins_addr[`ADDR_WIDTH-1:2]),
        .sel(rom_sel),
        .data(ins)
    );

    RegFile regfile(
        .clk(cp),
        .ra(ra),
        .rb(rb),
        .rw(rw),
        .we(RegWrite),
        .din(regfile_din),
        .R1(R1),
        .R2(R2)
    );

    ALU alu(
        .A(A),
        .B(B),
        .Shmat(alu_shmat),
        .AluOp(aluop),
        .Equal(equal),
        .result(result),
        .result2(result2)
    );

    //RAM #(.ADDR_LEN(`ADDR_WIDTH),.DATA_LEN(32)) ram(
        //.clk(clk),
        //.rst(rst),
        //.addr(ram_addr),
        //.sel(ram_sel),
        //.read_en(ram_re),
        //.write_en(ram_we),
        //.data_in(ram_din),
        //.data_out(ram_dout)
    //);

    Storage storage(
        .addr(ram_addr),
        .din(ram_din),
        .mode(ram_mode),
        //.Mem_SignExt(mem_signed_ext),
        .we(MemWrite),
        .clk(clk),
        .rst(rst),
        .dout(ram_dout)
    );

    Branch branchs(
        .R(result[0]),
        .Equal(equal),
        .beq(beq),
        .bne(bne),
        .B(b_branch),
        .Branch(branch),
        .rt(rt)
    );

    Syscall syscalls(
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

    Print #(.SHOW_WIDTH(32)) printf(
        .data(led_data),
        .prints(prints),
        .print_mode(print_mode),
        .clk(clk),
        .an(an),
        .seg(seg)
    );

    assign op    = ins[31:26];
    assign rs    = ins[25:21];
    assign rt    = ins[20:16];
    assign rd    = ins[15:11];
    assign shmat = ins[10:6];
    assign func  = ins[5:0];
    assign imm   = ins[15:0];
    assign imm26 = ins[25:0];

    assign imm_ext = SignedExt ? imm_sign_ext : imm_zero_ext;

    assign ins_addr = pc[`ADDR_WIDTH-1:0];

    assign ra   = syscall ? 5'd4 : rs;
    assign rb   = (|B) ? 5'd0 : (syscall ? 5'd2 : rt);
    assign rw   = jal ? 5'h1f : (RegDst ? rd : rt);

    assign A    = R1;
    assign B    = alu_src ? imm_ext : R2;
    assign alu_shmat = shmat_src ? shmat : R1;
    
    assign a0 = R1;
    assign v0 = R2;
    assign npc_rs = R1;

    assign ram_din = R2;
    assign ram_addr = result[`ADDR_WIDTH-1:0];

    assign regfile_din = mflo ? lo_out : 
                         (lui ? (imm_zero_ext << 'h10) :
                         (jal ? (pc + 4) :
                         (MemToReg ? ram_dout : result)));

endmodule
