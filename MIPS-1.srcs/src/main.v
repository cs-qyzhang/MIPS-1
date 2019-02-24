`timescale 1ns / 1ps
`include "MIPS-1.vh"

// MULTU, DIVU, MFLO, LB, LBU, LH, LHU,SB,SBU(大小端？), BLTZ
/*
 * 顶层模块
 *
 */
module Main(clk,btnl,btnr,btnc,btnu,btnd,sw,
            an,seg,led,led16_b,led16_g,led16_r,led17_b,led17_g,led17_r);
    input       clk, btnl, btnr, btnc, btnu, btnd;
    input[15:0]  sw;
    output[7:0]  an, seg;
    output[15:0] led;
    output       led16_b, led16_g, led16_r, led17_b, led17_g, led17_r;

    wire[31:0]  pc, lo_out;
    wire        rst;
    wire        cp;

    wire[5:0]   op, func;
    wire[4:0]   rs, rt, rd;
    wire[4:0]   shmat;
    wire[15:0]  imm;
    wire[25:0]  imm26;
    wire[31:0]  imm_ext;

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
    wire        eret, mfc0, mtc0;

    wire[1:0]   b_branch;
    wire        branch;

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
    wire[31:0]  ins;
    wire        rom_sel;

    wire[31:0]  a0, v0;
    wire        pause, go, prints, pause_and_show;
    wire[31:0]  led_data, show_data;
    wire[3:0]   print_mode;
    wire[3:0]   show_type;

    wire[31:0]  jmp_num, branch_num, all_cyc;
    wire[31:0]  freq;

    wire        interrupt_request, interrupt_begin, interrupt_finish;
    wire        interrupt_en_in, interrupt_en_out, nmi_in, nmi_out;
    wire        interrupt_enable, interrupt_disable, interrupt;
    wire[31:0]ebase;
    wire[7:0]   cause_ip_in, cause_ip_out, status_im;
    wire            cp0_we;
    wire[4:0]   cp0_ra, cp0_rw;
    wire[31:0]  cp0_din, cp0_dout, epc_in, epc_out;
    wire[1:0]   software_interrupt;
    wire[5:0]   hardware_interrupt;
    wire[`ADDR_WIDTH-1:0]exception_handle_addr;

`ifdef  DEBUG
    assign cp = clk;
`else
    DividerFreq freq_divider(
        .clk(clk),
        .clk_n(cp),
        .freq(freq)
    );
    assign go = btnr;
    assign rst = btnl;
`endif

    CP0 cp0(
        .clk(cp),
        .rst(rst),
        .we(cp0_we),
        .din(cp0_din),
        .dout(cp0_dout),
        .rw(cp0_rw),
        .ra(cp0_ra),
        .status_im(status_im),
        .cause_ip_in(cause_ip_out),
        .cause_ip_out(cause_ip_in),
        .ebase(ebase),
        .interrupt_en_in(interrupt_en_out),
        .interrupt_en_out(interrupt_en_in),
        .nmi_in(nmi_out),
        .nmi_out(nmi_in),
        .epc_in(epc_in),
        .epc_out(epc_out)
    );

    InterruptGeneration interrupt_generation(
        .clk(clk),
        .rst(rst),
        .cause_ip_in(cause_ip_in),
        .cause_ip_out(cause_ip_out),
        .status_im(status_im),
        .ebase(ebase),
        .hw(hardware_interrupt),
        .sw(software_interrupt),
        .interrupt_en_in(interrupt_en_in),
        .interrupt_en_out(interrupt_en_out),
        .interrupt_begin(interrupt_begin),
        .interrupt_finish(interrupt_en_out),
        .interrupt(interrupt),
        .exception_handle_addr(exception_handle_addr),
        .epc(epc_in),
        .interrupt_disable(interrupt_disable),
        .interrupt_enable(interrupt_enable),
        .npc(npc)
    );

    Pc reg_pc(
        .npc(interrupt_begin ? exception_handle_addr : npc),
        .rst(rst),
        .clk(cp),
        .pc_valid(~pause),
        .pc(pc)
    );

    Register #(.EDGE(`NEGEDGE))reg_lo(
        .data_in(result),
        .data_out(lo_out),
        .clk(clk),
        .rst(rst),
        .en((op == `ZERO_OP) && ((func == `DIVU_FUNC) || (func == `MULTU_FUNC)))
    );

    Npc npcs(
        .pc(pc),
        .clk(cp),
        .rst(rst),
        .imm_ext(imm_ext),
        .imm26(imm26),
        .branch(branch),
        .rs(npc_rs),
        .jr(jr),
        .jmp(jmp),
        .npc(npc),
        .epc(epc_out),
        .interrupt_finish(interrupt_finish)
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
        .b_branch(b_branch),
        .rs(rs),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .eret(eret),
        .cp0_we(cp0_we)
    );

    Extender extender(
        .Din(imm),
        .Dout(imm_ext),
        .sel(SignedExt)
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
        .Result(result),
        .Result2(result2)
    );

    MipsRAM ram(
        .addr(ram_addr),
        .din(ram_din),
        .mode(ram_mode),
        .mem_signed_ext(mem_signed_ext),
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
        .print_mode(print_mode),
        .pause_and_show(pause_and_show),
        .show_data(show_data)
    );

    Print #(.SHOW_WIDTH(32)) printf(
        .data(led_data),
        .prints(prints),
        .print_mode(print_mode),
        .clk(clk),
        .an(an),
        .seg(seg)
    );

    Led leds(
        .pause(pause),
        .led(led),
        .led16_b(led16_b),
        .led16_g(led16_g),
        .led16_r(led16_r),
        .led17_b(led17_b),
        .led17_g(led17_g),
        .led17_r(led17_r)
    );

    Input inputs(
        .btnl(btnl),
        .btnr(btnr),
        .btnc(btnc),
        .btnu(btnu),
        .btnd(btnd),
        .sw(sw),
        .go(go),
        .rst(rst),
        .freq(freq),
        .pause_and_show(pause_and_show),
        .show_type(show_type),
        .hardware_interrupt(hardware_interrupt)
    );

    Counter all_cyc_counter(
        .clk(cp),
        .rst(rst),
        .count(~pause),
        .ld(1'b0),
        .data('b0),
        .cnt(all_cyc)
    );

    Counter branch_num_counter(
        .clk(cp),
        .rst(rst),
        .count(branch),
        .ld(1'b0),
        .data('b0),
        .cnt(branch_num)
    );

    Counter jmp_num_counter(
        .clk(cp),
        .rst(rst),
        .count(jmp | jr),
        .ld(1'b0),
        .data('b0),
        .cnt(jmp_num)
    );

    assign op    = ins[31:26];
    assign rs    = ins[25:21];
    assign rt    = ins[20:16];
    assign rd    = ins[15:11];
    assign shmat = ins[10:6];
    assign func  = ins[5:0];
    assign imm   = ins[15:0];
    assign imm26 = ins[25:0];

    assign ins_addr = pc[`ADDR_WIDTH-1:0];

    assign ra   = syscall ? 5'd4 : rs;
    assign rb   = (|b_branch) ? 5'd0 : (syscall ? 5'd2 : rt);
    assign rw   = jal ? 5'h1f : (RegDst ? rd : rt);

    assign A    = R1;
    assign B    = alu_src ? imm_ext : R2;
    assign alu_shmat = shmat_src ? R1[4:0] : shmat;
    
    assign a0 = R1;
    assign v0 = R2;
    assign npc_rs = R1;

    assign ram_din = R2;
    assign ram_addr = result[`ADDR_WIDTH-1:0];

    assign regfile_din = mflo ? lo_out : 
                         (lui ? ({imm,16'b0}) :
                         (jal ? (pc + 32'd4) :
                         (MemToReg ? ram_dout :
                         (mfc0 ? cp0_dout : result))));

    assign show_data = (show_type == `SHOW_ALL_CYC) ? all_cyc :
                                       ( (show_type == `SHOW_BRANCH_NUM) ? branch_num : 
                                       ( (show_type == `SHOW_JMP_NUM) ? jmp_num : all_cyc) );

    assign interrupt_finish = eret;
    assign cp0_rw = rd;
    assign cp0_ra = rd;
    assign cp0_din = R2;
    assign software_interrupt = 0;

endmodule
