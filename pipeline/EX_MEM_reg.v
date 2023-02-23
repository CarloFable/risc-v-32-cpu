module EX_MEM_reg(
    input wire clk,
    input wire rst_n,
    
    input wire[31:0]EXpc,
    input wire[31:0]EXpc4,
    input wire[31:0]EXinst,
    
    input wire[1:0]EXwd_sel,
    input wire EXrf_we,
    input wire EXdram_we,
    
    input wire[31:0]EXext,
    input wire[31:0]EXrf_rD2,
    input wire[31:0]EXalu_c,
    
    output reg[31:0]MEMpc,
    output reg[31:0]MEMpc4,
    output reg[31:0]MEMinst,
    
    output reg[1:0]MEMwd_sel,
    output reg MEMrf_we,
    output reg MEMdram_we,
    
    output reg[31:0]MEMext, 
    output reg[31:0]MEMrf_rD2,
    output reg[31:0]MEMalu_c
    );
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMpc <= 32'b0;
        else        MEMpc <= EXpc;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMpc4 <= 32'b0;
        else        MEMpc4 <= EXpc4;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMinst <= 32'b0;
        else        MEMinst <= EXinst;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMwd_sel <= 2'd0;
        else        MEMwd_sel <= EXwd_sel;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMrf_we <= 1'b0;
        else        MEMrf_we <= EXrf_we;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMdram_we <= 1'b0;
        else        MEMdram_we <= EXdram_we;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMext <= 32'b0;
        else        MEMext <= EXext;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMrf_rD2 <= 32'b0;
        else        MEMrf_rD2 <= EXrf_rD2;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  MEMalu_c <= 32'b0;
        else        MEMalu_c <= EXalu_c;
    end
    
endmodule
