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
module Jump(PC,IR,RS,RT,BEQ,BNE,J,JR,SignedExt,B_Branch,NPC,JUMP);
    parameter DATA_LEN=32;
    
    input [DATA_LEN-1:0] PC,IR,RS,RT;
    input BEQ,BNE,J,JR,SignedExt;
    input [1:0]B_Branch;
    output [DATA_LEN-1:0]NPC;
    output JUMP;
    
    wire [1:0]sel;
    wire [15:0]imm16;
    wire [25:0]imm26;
    
    wire [DATA_LEN-1:0]J_type;
    wire [DATA_LEN-1:0]I_type;
    wire [DATA_LEN-1:0]else_type;
    wire [DATA_LEN-1:0]JR_type;
    wire [DATA_LEN-1:0]ext_imm;
    
    wire BLEZ,BGTZ,BLTZ,BGEZ;
    wire BLEZ_E,BGTZ_E,BLTZ_E,BGEZ_E,BNE_E,BEQ_E;
    
    wire sel0,sel1,sel2,sel3;
    wire [2:0]out_sel;
    
    assign imm16=IR[15:0];
    assign imm26=IR[25:0];
    
    assign J_type={PC[DATA_LEN-1:DATA_LEN-4],imm26[27:2],2'b00};
    assign I_type=PC+4+ext_imm;
    assign else_type=PC+4;
    assign JR_type=RS;
    
    
    assign BLEZ=(B_Branch==2'b01)?1:0;
    assign BGTZ=(B_Branch==2'b10)?1:0;
    assign BLTZ=(B_Branch==2'b11)?
                ((IR[20:16]==5'b00000)?1:0):0;
    assign BGEZ=(B_Branch==2'b11)?
                ((IR[20:16]==5'b00001)?1:0):0;
                
    
    assign BNE_E=(RS==RT)?0:1;
    assign BEQ_E=(RS==RT)?1:0;
    assign BLEZ_E=($signed(RS)<=0)?1:0; //<=0
    assign BLTZ_E=($signed(RS)<0)?1:0;//<0
    assign BGEZ_E=($signed(RS)>=0)?1:0;//>=0
    assign BGTZ_E=($signed(RS)>0)?1:0;//>0
    
    assign out_sel[0]=(BEQ&BEQ_E)|
                      (BNE&BNE_E)|
                      (BLEZ&BLEZ_E)|
                      (BGTZ&BGTZ_E)|
                      (BLTZ&BLTZ_E)|
                      (BGEZ&BGEZ_E)
    ;
    
    assign out_sel[1]=J;
    assign out_sel[2]=JR&~J;
    
    assign
           NPC=(out_sel==3'b001)?JR_type:
               (out_sel==3'b010)?J_type:
               (out_sel==3'b100)?I_type:
               else_type;          
    assign
          JUMP=(J_type|JR_type|I_type);  
    
    Extender
        extender0(
            .Din(imm16),
            .sel(SignedExt),
            .Dout(ext_imm)
            );  
    
endmodule
