`timescale 1ns / 1ps
/*
 *input:
 *      PC #32bit
 *      IR #32bit
 *      RS #32bit
 *      RT #32bit
 *      BEQ
 *      BNE
 *      J
 *      JR
 *      SignedExt
 *      B_Branch #2bit
 *output:
 *      NPC
 *      JUMP
 */
module Jump(pc,ir,rs,rt,beq,bne,j,jr,SignedExt,B_Branch,npc,jump);
    parameter DATA_LEN=32;
    
    input [DATA_LEN-1:0] pc,ir,rs,rt;
    input beq,bne,j,jr,SignedExt;
    input [1:0]B_Branch;
    output [DATA_LEN-1:0]npc;
    output jump;
    
    wire [1:0]sel;
    wire [15:0]imm16;
    wire [25:0]imm26;
    
    wire [DATA_LEN-1:0]J_type;
    wire [DATA_LEN-1:0]I_type;
    wire [DATA_LEN-1:0]else_type;
    wire [DATA_LEN-1:0]JR_type;
    wire [DATA_LEN-1:0]ext_imm;
    
    wire blez,bgtz,bltz,bgez;
    wire blez_e,bgtz_e,bltz_e,bgez_e;
    
    //wire sel0,sel1,sel2,sel3;
    wire [2:0]out_sel;
    wire [31:0]pc_4;
    
    wire beq_e,bne_e;
    
    assign pc_4=pc+4;
    assign imm16=ir[15:0];
    assign imm26=ir[25:0];
    
    assign J_type={pc_4[31:28],imm26,2'b00};
    assign I_type=pc_4+{ext_imm[29:0],2'b00};
    assign else_type=pc_4;
    assign JR_type=rs;
    
    
    assign blez=(B_Branch==2'b01)?1:0;
    assign bgtz=(B_Branch==2'b10)?1:0;
    assign bltz=(B_Branch==2'b11)?
                ((ir[20:16]==5'b00000)?1:0):0;
    assign bgez=(B_Branch==2'b11)?
                ((ir[20:16]==5'b00001)?1:0):0;
                
    
    assign bne_e=(rs==rt)?0:1;
    assign beq_e=(rs==rt)?1:0;
    
    
    
    assign blez_e=($signed(rs)<=0)?1:0; //<=0
    assign bltz_e=($signed(rs)<0)?1:0;//<0
    assign bgez_e=($signed(rs)>=0)?1:0;//>=0
    assign bgtz_e=($signed(rs)>0)?1:0;//>0
    
    assign out_sel[2]=(beq&beq_e)|
                      (bne&bne_e)|
                      (blez&blez_e)|
                      (bgtz&bgtz_e)|
                      (bltz&bltz_e)|
                      (bgez&bgez_e)
    ;
    
    assign out_sel[1]=j&(~jr);
    assign out_sel[0]=jr&j;
    
    assign
           npc=(out_sel==3'b001)?JR_type:
               (out_sel==3'b010)?J_type:
               (out_sel==3'b100)?I_type:
               else_type;          
    assign
          jump=(out_sel[0]|out_sel[1]|out_sel[2]);  
    
    Extender
        extender0(
            .Din(imm16),
            .sel(SignedExt),
            .Dout(ext_imm)
            );  
    
endmodule
