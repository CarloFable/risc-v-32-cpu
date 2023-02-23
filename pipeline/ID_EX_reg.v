module ID_EX_reg(
    input wire clk,
    input wire rst_n,
    
    input wire[31:0]IDpc,
    input wire[31:0]IDpc4,
    input wire[31:0]IDinst,
    
    input wire[1:0]IDwd_sel,
    input wire IDrf_we,
    input wire IDdram_we,
    
    input wire[31:0]IDext,
    
    input wire[31:0]IDrf_rD1,
    input wire[31:0]IDrf_rD2,
    
    input wire[31:0]IDalu_b,
    input wire[2:0]IDalu_op,
    
    output reg[31:0]EXpc,
    output reg[31:0]EXpc4,
    output reg[31:0]EXinst,
    
    output reg[1:0]EXwd_sel,
    output reg EXrf_we,
    output reg EXdram_we,
    
    output reg[31:0]EXext,
    
    output reg[31:0]EXrf_rD1,
    output reg[31:0]EXrf_rD2,
    
    output reg[31:0]EXalu_b,
    output reg[2:0]EXalu_op
    );
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXpc <= 32'b0;
        else        EXpc <= IDpc;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXpc4 <= 32'b0;
        else        EXpc4 <= IDpc4;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXinst <= 32'b0;
        else        EXinst <= IDinst;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXwd_sel <= 2'd0;
        else        EXwd_sel <= IDwd_sel;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXrf_we <= 1'b0;
        else        EXrf_we <= IDrf_we;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXdram_we <= 1'b0;
        else        EXdram_we <= IDdram_we;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXext <= 32'b0;
        else        EXext <= IDext;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXrf_rD1 <= 32'b0;
        else        EXrf_rD1 <= IDrf_rD1;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXrf_rD2 <= 32'b0;
        else        EXrf_rD2 <= IDrf_rD2;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXalu_b <= 32'b0;
        else        EXalu_b <= IDalu_b;
    end
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)  EXalu_op <= 3'd0;
        else        EXalu_op <= IDalu_op;
    end
    
endmodule
