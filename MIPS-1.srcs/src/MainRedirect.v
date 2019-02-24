`timescale 1ns / 1ps


module MainRedirect(
    clk,
    btnl,btnr,btnc,btnu,btnd,
    sw,
    an,seg,
    led,
    led16_b,led16_g,led16_r,led17_b,led17_g,led17_r
    );

    input       clk, btnl, btnr, btnc, btnu, btnd;
    input[15:0]  sw;
    output[7:0]  an, seg;
    output[15:0] led;
    output       led16_b, led16_g, led16_r, led17_b, led17_g, led17_r;
    
    wire cp, go, rst;
    wire prints;
    wire [3:0]   print_mode;
    wire pause_and_show;
    wire [3:0]   show_type;
    wire [31:0] freq;

    wire[5:0]   op, func;
    wire[4:0]   rs, rt, rd;
    // wire[4:0]   shmat;
    wire[15:0]  imm;
    wire[25:0]  imm26;
    //wire[31:0]  imm_ext;

    wire [31:0] RegDin;
    wire [31:0] led_data;
    wire [31:0] show_data;

    wire pause;
    wire pcvalid;
   
    wire can_jump;
    wire [31:0] next_pc;
    wire [31:0] pc_out;

    wire load_use;
    wire [1:0] r1_forward, r2_forward;
    // wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire alu_equal;
    wire [4:0] alu_shamt;


    //计数统计
    wire [31:0] all_cyc_num;//总周期数
    wire [31:0] jmp_num;//无条件分支数
    wire [31:0] load_use_num;//load-use次数


//IF 
    wire [31:0] pc_if, ir_if;
//ID
    wire [31:0] reg_r1, reg_r2;
    wire [31:0] pc_id, ir_id;
    wire [3:0] alu_op_id;
    wire MemToReg_id;
    wire MemWrite_id;
    wire alu_src_id;
    wire shamt_src_id;
    wire RegWrite_id;
    wire RegDst_id;
    wire syscall_id;
    wire SignedExt_id;
    wire mem_signed_ext_id;
    wire beq_id;
    wire bne_id;
    wire jr_id;
    wire jmp_id;
    wire jal_id;
    wire lui_id;
    wire mflo_id;
    wire hlen_id;
    wire [1:0] mode_id;
    wire [1:0] b_branch_id;
    wire [4:0] id_r1, id_r2, id_wb;//寄存器地址
    wire [31:0] imm_ext_id, imm_ext_sft_id;
    wire [31:0] r1_a0_id, r2_v0_id;
//EX
    wire [31:0] alu_result_lo_ex;
    wire [31:0] alu_result_hi_ex;
    wire RegWrite_ex;
    wire RegDst_ex;
    wire jal_ex;
    wire lui_ex;
    wire mflo_ex;
    wire MemToReg_ex;
    wire syscall_ex;
    wire mem_signed_ext_ex;
    wire MemWrite_ex;
    wire [1:0] mode_ex;
    wire [31:0] lo_out_ex;
    wire [31:0] hi_out_ex;
    wire shamt_src_ex;
    wire hlen_ex;
    wire alu_src_ex;
    wire [3:0] alu_op_ex;
    wire [31:0] imm_ext_ex, imm_ext_sft_ex;
    wire [31:0] r1_a0_ex, r2_v0_ex;
    wire [31:0] pc_ex, ir_ex;
    wire [4:0] wb_ex;
    
//MEM
    wire [31:0] alu_result_lo_mem;
    wire [31:0] alu_result_hi_mem;
    wire RegWrite_mem;
    wire RegDst_mem;
    wire jal_mem;
    wire lui_mem;
    wire mflo_mem;
    wire MemToReg_mem;
    wire syscall_mem;
    wire mem_signed_ext_mem;
    wire MemWrite_mem;
    wire [1:0] mode_mem;
    wire [31:0] lo_out_mem;
    wire [31:0] imm_ext_mem, imm_ext_sft_mem;
    wire [31:0] r1_a0_mem, r2_v0_mem;
    wire [31:0] pc_mem, ir_mem;
    wire [31:0] mem_out_mem;
    wire [4:0] wb_mem;
    
//WB
    wire RegWrite_wb;
    wire RegDst_wb;
    wire syscall_wb;
    wire jal_wb;
    wire lui_wb;
    wire mflo_wb;
    wire MemToReg_wb;
    wire [31:0] alu_result_lo_wb;
    wire [31:0] lo_out_wb;
    wire [31:0] imm_ext_wb, imm_ext_sft_wb;
    wire [31:0] r1_a0_wb, r2_v0_wb;
    wire [31:0] pc_wb, ir_wb;
    wire [31:0] mem_out_wb;
    wire [4:0] wb_wb;


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


    assign pcvalid = ~pause;
    Register reg_pc(
        .data_in(next_pc),
        .data_out(pc_if),
        .clk(cp),
        .rst(rst),
        .en((pcvalid) & (~load_use))
    );
      
    ROM #(.ADDR_LEN(`ADDR_WIDTH-2), .DATA_LEN(32)) pc_rom(
        .addr(pc_if[`ADDR_WIDTH-1:2]),
        .sel(1'b1), //rom_sel=1
        .data(ir_if)
    );

    IF_ID ifIdPiped(
        .clk(cp),
        .rst(rst|can_jump),
        .stall(load_use),
        .pc_in(pc_if),
        .ir_in(ir_if),
        .pc_out(pc_id),
        .ir_out(ir_id)
    );


    assign op = ir_id[31:26];
    assign rs = ir_id[25:21];
    assign rt = ir_id[20:16];
    assign rd = ir_id[15:11];
    assign func = ir_id[5:0];
    assign imm = ir_id[15:0];
    assign imm26 = ir_id[25:0];

    Controller ctrl_unit(
        .op_code(op),
        .func(func),
        .alu_op(alu_op_id),
        .MemToReg(MemToReg_id),
        .MemWrite(MemWrite_id),
        .alu_src(alu_src_id),
        .shamt_src(shamt_src_id),
        .RegWrite(RegWrite_id),
        .RegDst(RegDst_id),
        .syscall(syscall_id),
        .SignedExt(SignedExt_id),
        .mem_signed_ext(mem_signed_ext_id),
        .beq(beq_id),
        .bne(bne_id),
        .jr(jr_id),
        .jmp(jmp_id),
        .jal(jal_id),
        .lui(lui_id),
        .mflo(mflo_id),
        .hlen(hlen_id),
        .mode(mode_id),
        .b_branch(b_branch_id)
    );


    assign id_r1 = (syscall_id) ? 5'h4 : rs;
    
    assign id_r2 = (b_branch_id[1] | b_branch_id[0]) ? 5'h0
                    : (syscall_id) ? 5'h2
                    : rt;
                    
    assign id_wb = (jal_id) ? 5'h1f
                    :(RegDst_id) ? rd
                    : rt;
    
    Extender ext_unit(
        .Din(imm),
        .Dout(imm_ext_id),
        .sel(SignedExt_id)
    );

    //以下代码功能为移位 
    assign imm_ext_sft_id[31:16] = imm;
    assign imm_ext_sft_id[15:0] =  'b0;

//module RegFile(clk,ra,rb,rw,we,din,R1,R2);
    RegFile regfile(
        .clk(cp),
        .ra(id_r1),
        .rb(id_r2),
        .rw(wb_wb),
        .we(RegWrite_wb),
        .din(RegDin),
        .R1(reg_r1),
        .R2(reg_r2)
    );

    DataRelated hazard_unit(
        .OP(op),
        .FUNC(func),
        .ex_regwrite(RegWrite_ex),
        .mem_regwrite(RegWrite_mem),
        .id_r1(id_r1),
        .id_r2(id_r2),
        .mem_memtoreg(MemToReg_mem),
        .ex_memtoreg(MemToReg_ex),
        .ex_wb(wb_ex),
        .mem_wb(wb_mem),
        .r1_forward(r1_forward),
        .r2_forward(r2_forward),
        .load_use(load_use)
    );

    assign r1_a0_id = (r1_forward == 2'b00) ? reg_r1
                    : (r1_forward == 2'b01) ? alu_result_lo_ex
                    : (r1_forward == 2'b10) ? alu_result_lo_mem
                    : alu_result_lo_ex;
    assign r2_v0_id = (r2_forward == 2'b00) ? reg_r2
                    : (r2_forward == 2'b01) ? alu_result_lo_ex
                    : (r2_forward == 2'b10) ? alu_result_lo_mem
                    : alu_result_lo_ex;
    
    //module Jump(pc,ir,rs,rt,beq,bne,j,jr,SignedExt,B_Branch,npc,jump)
    Jump npc_unit(
        .pc(pc_id),
        .ir(ir_id),
        .rs(r1_a0_id),
        .rt(r2_v0_id),
        .beq(beq_id),
        .bne(bne_id),
        .j(jmp_id),
        .jr(jr_id),
        .SignedExt(SignedExt_id),
        .B_Branch(b_branch_id),
        .npc(pc_out),
        .jump(can_jump)
    );

    assign next_pc = (can_jump) ? pc_out : (pc_if + 32'd4);
/*
module ID_EX(
    clk,rst,stall, //always
    RegWrite_in, Jal_in, Lui_in, MFLO_in, MemToReg_in, Syscall_in, MemSignExt_in,RegDst_in,//in
    MemWrite_in, MODE_in, Shamt_in, Hlen_in, AluSrcB_in, AluOP_in, ImmExt_in,//in
    ImmExtSft_in, r2_in, r1_in, pc_in, ir_in, Wback_in,//in
    
    RegWrite_out, Jal_out, Lui_out, MFLO_out, MemToReg_out, Syscall_out, MemSignExt_out,RegDst_out,//out
    MemWrite_out, MODE_out, Shamt_out, Hlen_out, AluSrcB_out, AluOP_out, ImmExt_out,//out
    ImmExtSft_out, r2_out, r1_out, pc_out, ir_out,Wback_out //out 
    );
*/
    ID_EX idExPiped(
        .clk(cp),
        .rst(rst | load_use),
        .stall(1'b0),
        .RegWrite_in(RegWrite_id),
        .Jal_in(jal_id),
        .Lui_in(lui_id),
        .MFLO_in(mflo_id),
        .MemToReg_in(MemToReg_id),
        .Syscall_in(syscall_id),
        .MemSignExt_in(mem_signed_ext_id),
        .RegDst_in(RegDst_id),
        .MemWrite_in(MemWrite_id),
        .MODE_in(mode_id),
        .Shamt_in(shamt_src_id),
        .Hlen_in(hlen_id),
        .AluSrcB_in(alu_src_id),
        .AluOP_in(alu_op_id),
        .ImmExt_in(imm_ext_id),
        .ImmExtSft_in(imm_ext_sft_id),
        .r2_in(r2_v0_id),
        .r1_in(r1_a0_id),
        .pc_in(pc_id),
        .ir_in(ir_id),
        .Wback_in(id_wb),//stage: id
        .RegWrite_out(RegWrite_ex),
        .Jal_out(jal_ex),
        .Lui_out(lui_ex),
        .MFLO_out(mflo_ex),
        .MemToReg_out(MemToReg_ex),
        .Syscall_out(syscall_ex),
        .MemSignExt_out(mem_signed_ext_ex),
        .RegDst_out(RegDst_ex),
        .MemWrite_out(MemWrite_ex),
        .MODE_out(mode_ex),
        .Shamt_out(shamt_src_ex),
        .Hlen_out(hlen_ex),
        .AluSrcB_out(alu_src_ex),
        .AluOP_out(alu_op_ex),
        .ImmExt_out(imm_ext_ex),
        .ImmExtSft_out(imm_ext_sft_ex),
        .r2_out(r2_v0_ex),
        .r1_out(r1_a0_ex),
        .pc_out(pc_ex),
        .ir_out(ir_ex),
        .Wback_out(wb_ex)//stage: ex
    );

    // assign alu_a = r1_a0_ex;
    assign alu_b = (alu_src_ex) ? imm_ext_ex : r2_v0_ex;
    assign alu_shamt = (shamt_src_ex) ? (r1_a0_ex[4:0]) : (ir_ex[10:6]);

    //module ALU(A,B,Shmat,AluOp,Equal,Result,Result2);
    ALU alu_unit(
        .A(r1_a0_ex),
        .B(alu_b),
        .Shmat(alu_shamt),
        .AluOp(alu_op_ex),
        .Equal(alu_equal),
        .Result(alu_result_lo_ex),
        .Result2(alu_result_hi_ex)
    );

    Register reglo(
        .data_in(alu_result_lo_ex),
        .data_out(lo_out_ex),
        .clk(cp),
        .rst(rst),
        .en(hlen_ex)
    );

    Register reghi(
        .data_in(alu_result_hi_ex),
        .data_out(hi_out_ex),
        .clk(cp),
        .rst(rst),
        .en(hlen_ex)
    );

    EX_MEM exMemPiped(
        .clk(cp),
        .rst(rst),
        .stall(1'b0),
        .RegWrite_in(RegWrite_ex),
        .Jal_in(jal_ex),
        .Lui_in(lui_ex),
        .MFLO_in(mflo_ex),
        .MemToReg_in(MemToReg_ex),
        .Syscall_in(syscall_ex),
        .MemSignExt_in(mem_signed_ext_ex),
        .RegDst_in(RegDst_ex),
        .MemWrite_in(MemWrite_ex),
        .MODE_in(mode_ex),
        .LO_R_in(alu_result_lo_ex),
        .LO_Out_in(lo_out_ex),
        .ImmExt_in(imm_ext_ex),
        .ImmExtSft_in(imm_ext_sft_ex),
        .r2_in(r2_v0_ex),
        .r1_in(r1_a0_ex),
        .pc_in(pc_ex),
        .ir_in(ir_ex),
        .Wback_in(wb_ex),//stage: ex
        .RegWrite_out(RegWrite_mem),
        .Jal_out(jal_mem),
        .Lui_out(lui_mem),
        .MFLO_out(mflo_mem),
        .MemToReg_out(MemToReg_mem),
        .Syscall_out(syscall_mem),
        .MemSignExt_out(mem_signed_ext_mem),
        .RegDst_out(RegDst_mem),
        .MemWrite_out(MemWrite_mem),
        .MODE_out(mode_mem),
        .LO_R_out(alu_result_lo_mem),
        .LO_Out_out(lo_out_mem),
        .ImmExt_out(imm_ext_mem),
        .ImmExtSft_out(imm_ext_sft_mem),
        .r2_out(r2_v0_mem),
        .r1_out(r1_a0_mem),
        .pc_out(pc_mem),
        .ir_out(ir_mem),
        .Wback_out(wb_mem)//stage: mem
    );
//module MipsRAM(addr, din, mode, we, clk, rst, dout, mem_signed_ext);
    MipsRAM mipsDataRam(
        .addr(alu_result_lo_mem[`ADDR_WIDTH-1:0]),
        .din(r2_v0_mem),
        .mode(mode_mem),
        .we(MemWrite_mem),
        .clk(cp),
        .rst(rst),
        .dout(mem_out_mem),
        .mem_signed_ext(mem_signed_ext_mem)
    );

    MEM_WB memWbPiped(
        .clk(cp),
        .rst(rst),
        .stall(1'b0),
        .RegWrite_in(RegWrite_mem),
        .Jal_in(jal_mem),
        .Lui_in(lui_mem),
        .MFLO_in(mflo_mem),
        .MemToReg_in(MemToReg_mem),
        .Syscall_in(syscall_mem),
        .RegDst_in(RegDst_mem),
        .LO_R_in(alu_result_lo_mem),
        .LO_Out_in(lo_out_mem),
        .ImmExt_in(imm_ext_mem),
        .ImmExtSft_in(imm_ext_sft_mem),
        .r2_in(r2_v0_mem),
        .r1_in(r1_a0_mem),
        .pc_in(pc_mem),
        .ir_in(ir_mem),
        .Wback_in(wb_mem),//stage: mem
        .MemOut_in(mem_out_mem),//new
        .MemOut_out(mem_out_wb),
        .RegWrite_out(RegWrite_wb),
        .Jal_out(jal_wb),
        .Lui_out(lui_wb),
        .MFLO_out(mflo_wb),
        .MemToReg_out(MemToReg_wb),
        .Syscall_out(syscall_wb),
        .RegDst_out(RegDst_wb),
        .LO_R_out(alu_result_lo_wb),
        .LO_Out_out(lo_out_wb),
        .ImmExt_out(imm_ext_wb),
        .ImmExtSft_out(imm_ext_sft_wb),
        .r2_out(r2_v0_wb),
        .r1_out(r1_a0_wb),
        .pc_out(pc_wb),
        .ir_out(ir_wb),
        .Wback_out(wb_wb)//stage: wb
    );

    assign show_data = (show_type == `SHOW_ALL_CYC) ? all_cyc_num :
                                       ( (show_type == `SHOW_BRANCH_NUM) ? load_use_num: 
                                       ( (show_type == `SHOW_JMP_NUM) ? jmp_num : all_cyc_num) );
    Syscall syacall_unit(
        .clk(cp),
        .rst(rst),
        .syscall(syscall_wb),
        .go(go),
        .a0(r1_a0_wb),
        .v0(r2_v0_wb),
        .led_data(led_data),
        .pause(pause),
        .print(prints),
        .print_mode(print_mode),
        .pause_and_show(pause_and_show),
        .show_data(show_data)
    );

    assign RegDin = (mflo_wb) ? lo_out_wb
                    : (lui_wb) ? imm_ext_sft_wb
                    : (jal_wb) ? (pc_wb + 32'd4)
                    : (MemToReg_wb) ? mem_out_wb
                    : alu_result_lo_wb;

    Counter all_cyc_counter(
        .clk(cp),
        .rst(rst),
        .count(pcvalid),
        .ld(1'b0),
        .data(32'd0),
        .cnt(all_cyc_num)
    );

    Counter jmp_counter(
        .clk(cp),
        .rst(rst),
        .count(jmp_id | jr_id),
        .ld(1'b0),
        .data(32'd0),
        .cnt(jmp_num)
    );

    Counter load_use_counter(
        .clk(cp),
        .rst(rst),
        .count(load_use),
        .ld(1'b0),
        .data(32'd0),
        .cnt(load_use_num)
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
        .show_type(show_type)
    );

endmodule