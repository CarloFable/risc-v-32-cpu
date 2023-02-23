module mini_rv(
    input wire clk,   
    input wire rst_n , // low level reset
    input wire[31:0]inst,
    input wire[31:0]dm_rd,
    output wire[31:0]pc,
    output wire dram_we,
    output wire[31:0]alu_c,
    output wire[31:0]rf_rD2,
    output wire debug_wb_have_inst,
    output wire[31:0]debug_wb_pc,
    output wire debug_wb_ena,
    output wire[4:0]debug_wb_reg,
    output wire[31:0]debug_wb_value
    );
    
    // pc reg
    wire[31:0]npc;
    ProgCnt PC(
        .clk    (clk),
        .rst_n  (rst_n),
        .pc_reg (pc),   // output
        .npc    (npc)
    );
    
    // calculate next inst addr
    wire[31:0]ext;     // sext imm
    wire[31:0]rf_rD1;  // reg file reg1 read data
    wire[1:0]npc_op;   // npc=pc+4 npc=pc+imm npc=base+imm
    wire[31:0]pc4;     // npc=pc+4
    NxtInstAdr NPC(
        .pc     (pc),
        .pc4    (pc4),  // output
        .npc    (npc),  // output
        .op     (npc_op),
        .imm    (ext),
        .base   (rf_rD1)
    );
    
    // imm sext generate 32-bit
    wire[2:0]sext_op;  // I B J S U
    SextImm SEXT(
        .din    (inst[31:7]),
        .op     (sext_op),
        .ext    (ext)
    );
    
    // 4-1 Mux to rf_wd
    wire[31:0]rf_wd;  // reg file write data
    wire[1:0]wd_sel;  // rf_wd input select
    Mux4_1 toRF_wD4(
        .sel    (wd_sel),
        .a0     (alu_c),
        .a1     (pc4),
        .a2     (ext),
        .a3     (dm_rd),
        .b      (rf_wd)
    );
        
    // 32-bit 32-num reg file
    wire rf_we;        // reg file write enable
    RegFile RF(
        .clk    (clk),
        .rst_n  (rst_n),
        .rR1    (inst[19:15]),
        .rR2    (inst[24:20]),
        .rD1    (rf_rD1),   // output
        .rD2    (rf_rD2),   // output
        .wen    (rf_we),
        .wR     (inst[11:7]),
        .wD     (rf_wd)
    );
    
    // 2-1 Mux to alu_b
    wire[1:0]alub_sel;  // alu_b input select
    wire[31:0]alu_b;
    Mux4_1 toALU_B2(
        .sel    (alub_sel),
        .a0     (rf_rD2),
        .a1     (ext),
        .b      (alu_b)
    );
    
    // alu
    wire[2:0]alu_op;
    wire[2:0]br_ctrl;  // beq bne blt bge
    wire br_true;      // branch true or false (1/0)
    ALU ALU(
        .a          (rf_rD1),
        .b          (alu_b),
        .c          (alu_c),    // output
        .op         (alu_op),
        .br_ctrl    (br_ctrl),
        .br_true    (br_true)   // output
    );
    
    // cu
    Control CU(
        .inst       (inst),
        .br_true    (br_true),
        .br_ctrl    (br_ctrl),
        .npc_op     (npc_op),
        .sext_op    (sext_op),
        .alu_op     (alu_op),
        .alub_sel   (alub_sel),
        .wd_sel     (wd_sel),
        .rf_we      (rf_we),
        .dram_we    (dram_we)
    );
    
    // debug
    assign debug_wb_have_inst   =   1'b1;
    assign debug_wb_pc          =   pc;
    assign debug_wb_ena         =   rf_we;
    assign debug_wb_reg         =   inst[11:7];
    assign debug_wb_value       =   rf_wd;
    
endmodule
