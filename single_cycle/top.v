module top(
    input wire clk,
    input wire rst_n,
    output wire debug_wb_have_inst,
    output wire[31:0]debug_wb_pc,
    output wire debug_wb_ena,
    output wire[4:0]debug_wb_reg,
    output wire[31:0]debug_wb_value
);
    wire[31:0]inst;
    wire dram_we;       // datamemory write enable
    wire ram_clk;       // because of address delay
    assign ram_clk = ~clk;
    wire[31:0]pc;
    wire[31:0]alu_c;    // alu result
    wire[31:0]dm_rd;    // data memory read data
    wire[31:0]rf_rD2;   // reg file reg2 read data

    mini_rv mini_rv_u (
        .clk                    (clk),
        .rst_n                  (rst_n),
        .inst                   (inst),
        .dm_rd                  (dm_rd),
        .pc                     (pc),
        .dram_we                (dram_we),
        .alu_c                  (alu_c),
        .rf_rD2                 (rf_rD2),
        .debug_wb_have_inst     (debug_wb_have_inst),
        .debug_wb_pc            (debug_wb_pc),
        .debug_wb_ena           (debug_wb_ena),
        .debug_wb_reg           (debug_wb_reg),
        .debug_wb_value         (debug_wb_value)
    );

    // 64KB IROM
    inst_mem imem(
        .a      (pc[15:2]),
        .spo    (inst)
    );
    
    // 64KB DRAM
    data_mem dmem(
        .clk    (ram_clk),
        .we     (dram_we),
        .a      (alu_c[15:2]),
        .d      (rf_rD2),
        .spo    (dm_rd)
    );
    
endmodule
