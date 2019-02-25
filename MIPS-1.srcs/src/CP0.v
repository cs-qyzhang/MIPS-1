`timescale 1ns / 1ps
`include "MIPS-1.vh"

module CP0(clk,rst,we,din,dout,rw,ra,
           status_im,cause_ip_in,cause_ip_out,ebase,
           interrupt_en,nmi_in,nmi_out,interrupt_state,
           epc_in,epc_out,interrupt_begin,interrupt_finish,interrupt);

    input       clk, rst, we, interrupt_begin, interrupt_finish, interrupt;
    input[4:0]  ra, rw;
    input[31:0] din;
    input       nmi_in;
    input[31:0] epc_in;
    input[7:0]  cause_ip_in;
    input[3:0]  interrupt_state;

    output[31:0]dout, ebase;
    output[7:0] cause_ip_out, status_im;
    output      nmi_out, interrupt_en;
    output[31:0]epc_out;

    reg[31:0]   CP0_reg[31:0];
    integer     i;

    assign  cause_ip_out[7:0] = CP0_reg[`CP0_CAUSE][`CAUSE_IP7:`CAUSE_IP0];
    assign  status_im[7:0]    = CP0_reg[`CP0_STATUS][`STATUS_IM7:`STATUS_IM0];
    assign  nmi_out           = CP0_reg[`CP0_STATUS][`STATUS_NMI];
    assign  epc_out           = CP0_reg[`CP0_EPC];
    assign  dout              = CP0_reg[ra];
    assign  ebase             = CP0_reg[`CP0_EBASE];
    assign  interrupt_en      = CP0_reg[`CP0_STATUS][`STATUS_IE];
    
    always @(posedge clk)
        begin
            if (rst)
                begin
                    for (i = 0; i < 32; i = i + 1)
                        CP0_reg[i] = 32'b0;
                    CP0_reg[`CP0_EBASE] = `EXCEPTION_HANDLE_ADDR;
                    CP0_reg[`CP0_STATUS][`STATUS_IE] = 1;
                    CP0_reg[`CP0_STATUS][`STATUS_IM7:`STATUS_IM0] = 8'b11111111;
                end
            else
                begin
                    CP0_reg[`CP0_CAUSE][`CAUSE_IP7:`CAUSE_IP0] = cause_ip_in[7:0];
                    CP0_reg[`CP0_STATUS][`STATUS_NMI]          = nmi_in;
                    
                    if (interrupt_begin)
                        begin
                            CP0_reg[`CP0_EPC]                = epc_in;
                            CP0_reg[`CP0_STATUS][`STATUS_IE] = 0;
                        end
                    else if (interrupt_finish && interrupt_state == 0)
                        CP0_reg[`CP0_STATUS][`STATUS_IE] = 1;
                    else if (interrupt_finish && interrupt_state != 0)
                            CP0_reg[`CP0_STATUS][`STATUS_IE] = 0;
                    else
                        ;

                    if (we)
                        CP0_reg[rw] = din;
                    else
                        ;
                end
        end

endmodule
