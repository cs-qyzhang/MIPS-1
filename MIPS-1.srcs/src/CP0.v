`timescale 1ns / 1ps
`include "MIPS-1.vh"

module CP0(clk,rst,we,din,dout,rw,ra,
           status_im,cause_ip_in,cause_ip_out,ebase,
           interrupt_en_in,interrupt_en_out,nmi_in,nmi_out,
           epc_in,epc_out,interrupt_begin,interrupt);

    input       clk, rst, we, interrupt_en_in, interrupt_begin, interrupt;
    input[4:0]  ra, rw;
    input[31:0] din;
    input       nmi_in;
    input[31:0] epc_in;
    input[7:0]  cause_ip_in;

    output[31:0]dout, ebase;
    output[7:0] cause_ip_out, status_im;
    output      interrupt_en_out;
    output      nmi_out;
    output[31:0] epc_out;

    reg[31:0]   CP0_reg[31:0];
    integer     i;

    assign  cause_ip_out[7:0] = CP0_reg[`CP0_CAUSE][`CAUSE_IP7:`CAUSE_IP0];
    assign  status_im[7:0]    = CP0_reg[`CP0_STATUS][`STATUS_IM7:`STATUS_IM0];
    assign  nmi_out           = CP0_reg[`CP0_STATUS][`STATUS_NMI];
    assign  interrupt_en_out  = CP0_reg[`CP0_STATUS][`STATUS_IE];
    assign  epc_out           = CP0_reg[`CP0_EPC];
    assign  dout              = CP0_reg[ra];
    //assign ebase            = CP0_reg[`CP0_EBASE];
    assign ebase            = `EXCEPTION_HANDLE_ADDR;

    initial
        begin
            for (i = 0; i < 32; i = i + 1)
                CP0_reg[i] = 32'b0;
            CP0_reg[`CP0_EBASE] = `EXCEPTION_HANDLE_ADDR;
            CP0_reg[`CP0_STATUS][`STATUS_IE] = 1;
            CP0_reg[`CP0_STATUS][`STATUS_IM7:`STATUS_IM0] = 8'b11111111;
        end

    always @(negedge clk)
        begin
            CP0_reg[`CP0_STATUS][`STATUS_IE]              = interrupt_en_in;
            CP0_reg[`CP0_CAUSE][`CAUSE_IP7:`CAUSE_IP0]    = cause_ip_in[7:0];
            CP0_reg[`CP0_STATUS][`STATUS_NMI]             = nmi_in;
            
            if (!interrupt)
                CP0_reg[`CP0_STATUS][`STATUS_IM7:`STATUS_IM0] = 8'b11111111;

            if (interrupt_begin)
                CP0_reg[`CP0_EPC] = epc_in;
            else
                ;

            if (we)
                CP0_reg[rw] = din;
            else
                ;
        end

endmodule
