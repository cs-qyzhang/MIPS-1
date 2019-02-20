`timescale 1ns / 1ps

module Storage_test();
    reg [11:0]Din_Addr;
    reg [31:0]Din;
    reg Mem_SignExt,WE,clk,rst;
    reg [1:0]mode;
    wire [31:0]Dout;
    
    initial
    begin
    //清零
        clk <= 0;
        Din_Addr <= 11'b00000000000;
        Din <= 32'h00000000;
        Mem_SignExt <= 0;
        WE <= 0;
        rst <= 1;
        mode <= 2'b00;
        
        //写入数据
        #30
        clk <= 1;
        Din_Addr <= 11'b00000000000;
        Din <= 32'h11111111;
        Mem_SignExt <= 0;
        WE <= 1;
        rst <= 0;
        mode <= 2'b00;
        #10 clk <= 0;
        
        #30
        clk <= 1;
        Din_Addr <= 11'b00000000000;
        Din <= 32'h000000ef;
        Mem_SignExt <= 0;
        WE <= 0;
        rst <= 0;
        mode <= 2'b00;
        #10 clk <= 0;
        
        //测试输出
        #30
        clk <= 1;
        Din_Addr <= 11'b00000000000;
        Din <= 32'h000000ff;
        Mem_SignExt <= 0;
        WE <= 0;
        rst <= 0;
        mode <= 2'b00;
        #10 clk <= 0;
        //理想输出应为11111111
        
        #30
        clk <= 1;
        Din_Addr <= 11'b00000000000;
        Din <= 32'h000000ff;
        Mem_SignExt <= 1;
        WE <= 0;
        rst <= 0;
        mode <= 2'b01;
        #10 clk <= 0;
        //理想输出应为00001111
        
        #30
        clk <= 1;
        Din_Addr <= 11'b00000000000;
        Din <= 32'h000000ff;
        Mem_SignExt <= 1;
        WE <= 0;
        rst <= 0;
        mode <= 2'b10;
        #10 clk <= 0;
        //理想输出应为00001111
        
        #30
        clk <= 1;
        Din_Addr <= 11'b00000000010;
        Din <= 32'h000000ff;
        Mem_SignExt <= 1;
        WE <= 0;
        rst <= 0;
        mode <= 2'b10;
        #10 clk <= 0;
        //理想输出应为00001111
        #30 clk <= 1;
        
    end
    
    Storage Test(
        .addr(Din_Addr),
        .din(Din),
        .mode(mode),
        .we(WE),
        .clk(clk),
        .rst(rst),
        .dout(Dout)
    );
    
endmodule
