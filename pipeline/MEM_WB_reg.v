module MEM_WB_reg(
    input wire clk,
    input wire rst_n,
    
    input wire[31:0]MEMpc,
    input wire[31:0]MEMinst,
    
    input wire MEMrf_we,
    input wire[31:0]MEMrf_wd,
    
    output reg[31:0]WBpc,
    output reg[31:0]WBinst,
    
    output reg WBrf_we,
    output reg[31:0]WBrf_wd
    );
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  WBpc <= 32'b0;
        else        WBpc <= MEMpc;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  WBinst <= 32'b0;
        else        WBinst <= MEMinst;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  WBrf_we <= 1'b0;
        else        WBrf_we <= MEMrf_we;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  WBrf_wd <= 32'b0;
        else        WBrf_wd <= MEMrf_wd;
    end
    
endmodule
