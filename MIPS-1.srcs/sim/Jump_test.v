`timescale 1ns / 1ps
module Jump_test;


    wire [31:0]pc,ir,rs,rt,npc;
    wire [1:0]b_branch;
    
    wire MemToReg, MemWrite;
    wire alu_src, shmat_src;
    wire RegWrite, RegDst;
    wire syscall;
    wire SignedExt, mem_signed_ext;
    wire beq, bne;
    wire jr, jmp, jal;
    wire lui, mflo;
    wire hlen;
    wire [5:0]op,func;
    wire [4:0]aluop;
    wire [1:0]ram_mode;
    wire jump;
    
    reg clk;
    reg rst;
    
    initial 
        begin
            clk<=0;
            rst<=0;
        end
    always 
        begin
            #5 clk<=~clk;
        end  
    assign op=ir[31:26];
    assign func=ir[5:0];  
    Jump jump_module(
                .PC(pc),
                .IR(ir),
                .RS(rs),
                .RT(rt),
                .BEQ(beq),
                .BNE(bne),
                .J(jmp),
                .JR(jr),
                .SignedExt(SignedExt),
                .B_Branch(b_branch),
                .NPC(npc),
                .JUMP(jump)
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
                
    RegFile regfile(
                        .clk(clk),
                        .ra(ir[25:21]),
                        .rb(ir[20:16]),
                        .rw(0),
                        .we(RegWrite),
                        .din(0),
                        .R1(rs),
                        .R2(rt)
                    );
    Pc  reg_pc(
            .npc(npc),
            .rst(rst),
            .clk(clk),
            .pc_valid(1),
            .pc(pc)     
            );
            
    ROM #(.ADDR_LEN(`ADDR_WIDTH-2),.DATA_LEN(32)) rom(
                    .addr(pc[`ADDR_WIDTH-1:2]),
                    .sel(1),
                    .data(ir)
                );
        
endmodule
