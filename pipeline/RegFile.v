module RegFile(
    input wire clk,         // global clk
    input wire rst_n,
    input wire[4:0]rR1,     // read reg1 addr: irom.inst[19:15]
    input wire[4:0]rR2,     // read reg2 addr: irom.inst[24:20]
    input wire[4:0]wR,      // write reg addr: irom.inst[11:7]
    input wire[31:0]wD,     // write reg data
    input wire wen,         // control regfile write enable: cu.rf_we
    output wire[31:0]rD1,   // reg1 read data goto npc.base and alu.a
    output wire[31:0]rD2    // reg2 read data goto alu.b:2-mux and dram.wdin
    );
    
    reg[31:0]regs[31:0];        // 32-bit 32 regs
    
    integer i;
    // write reg
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            for(i = 0; i < 32; i = i + 1)   regs[i]  <= 32'b0;
        end
        else if(wen)                        regs[wR] <= wD;
    end
    
    assign rD1 = (rR1 == 5'd0) ? 32'b0 : regs[rR1];  // read reg1  (x0 is zero)
    assign rD2 = (rR2 == 5'd0) ? 32'b0 : regs[rR2];  // read reg2  (x0 is zero)
    
endmodule
