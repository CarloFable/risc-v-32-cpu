module mini_rv(
    input wire clk,   
    input wire rst_n,
    // IF
    input wire[31:0]IFinst,
    output wire[31:0]IFpc,
    // MEM
    input wire[31:0]MEMdm_rd,
    output wire MEMdram_we,
    output wire[31:0]MEMalu_c,
    output wire[31:0]MEMrf_rD2,
    // debug
    output wire debug_wb_have_inst,
    output wire[31:0]debug_wb_pc,
    output wire debug_wb_ena,
    output wire[4:0]debug_wb_reg,
    output wire[31:0]debug_wb_value
    );
    
    // IF
    wire[31:0]IDpc;
    wire Dpc_ctrl;
    wire[31:0]IDnpc;
    wire[31:0]IFnpc;
    wire[31:0]IDinst;
    BranchHazard BHCheck(
        .IFpc       (IFpc),  
        .IDpc       (IDpc),    
                               
        .Dpc_ctrl   (Dpc_ctrl),    
        .IFinst     (IFinst),
        .IDinst     (IDinst),
                               
        .IDnpc      (IDnpc), 
                  
        .IFnpc      (IFnpc)  
    );
    ProgCnt PC(
        .clk        (clk),
        .rst_n      (rst_n),
        
        .npc        (IFnpc),
        .pc_reg     (IFpc) 
    );  // pc reg
    IF_ID_reg reg0(
        .clk        (clk),
        .rst_n      (rst_n),
        
        .Dpc_ctrl   (Dpc_ctrl),    
        
        .IFpc       (IFpc),
        .IFinst     (IFinst),
        
        .IDpc       (IDpc),
        .IDinst     (IDinst)
    );
    
    // ID
    wire re1;           // read regfile reg1 enable 
    wire re2;           // read regfile reg2 enable 
    wire[2:0]br_ctrl;   // beq bne blt bge
    wire br_true;       // branch true or false (1/0)
    wire[1:0]IDwd_sel;  // rf_wd input select
    wire IDrf_we;       // reg file write enable
    wire IDdram_we;
    wire[2:0]sext_op;   // I B J S U
    wire[1:0]npc_op;    // npc=pc+4 npc=pc+imm npc=base+imm
    wire[2:0]IDalu_op;
    wire[1:0]alub_sel;  // alu_b input select
    Control CU(
        .inst       (IDinst),
        .re1        (re1),
        .re2        (re2),
        .br_true    (br_true),
        .br_ctrl    (br_ctrl),
        .npc_op     (npc_op),
        .sext_op    (sext_op),
        .alub_sel   (alub_sel),
        .alu_op     (IDalu_op),
        .wd_sel     (IDwd_sel),
        .rf_we      (IDrf_we),
        .dram_we    (IDdram_we)
    );  // cu
    wire[31:0]EXpc;
    wire[31:0]EXinst;
    wire[1:0]EXwd_sel;
    wire EXrf_we;
    wire[31:0]EXrf_wd;
    wire[31:0]MEMinst;
    wire MEMrf_we;
    wire[31:0]MEMrf_wd;
    wire[31:0]WBinst;
    wire WBrf_we;       // reg file write enable
    wire[31:0]WBrf_wd;  // reg file write data
    wire[1:0]rd1_sel;
    wire[1:0]rd2_sel;
    wire[31:0]fw1;      // data forward rs1
    wire[31:0]fw2;      // data forward rs2
    DataHazard DHCheck(
        .IDinst     (IDinst),
        .EXinst     (EXinst),
        .MEMinst    (MEMinst),
        .WBinst     (WBinst),
        
        .EXrf_we    (EXrf_we),
        .MEMrf_we   (MEMrf_we),
        .WBrf_we    (WBrf_we),
        
        .IDpc       (IDpc),
        .EXpc       (EXpc),
                   
        .re1        (re1),
        .re2        (re2),
        .EXwd_sel   (EXwd_sel),
                  
        .EXrf_wd    (EXrf_wd),
        .MEMrf_wd   (MEMrf_wd),
        .WBrf_wd    (WBrf_wd),
        
        .Dpc_ctrl   (Dpc_ctrl),
        .rd1_sel    (rd1_sel),
        .rd2_sel    (rd2_sel),
                    
        .fw1        (fw1),
        .fw2        (fw2)
    );
    wire[31:0]IDext;     // sext imm
    wire[31:0]IDrf_rD1;
    wire[31:0]IDpc4;     // npc=pc+4
    NxtInstAdr NPC(
        .pc     (IDpc),
        .pc4    (IDpc4),
        .npc    (IDnpc),
        .op     (npc_op),
        .imm    (IDext),
        .base   (IDrf_rD1)
    );  // calculate next inst addr
    SextImm SEXT(
        .din    (IDinst[31:7]),
        .op     (sext_op),
        .ext    (IDext)
    );  // imm sext generate 32-bit
    wire[31:0]IDrf_rD1_pre; // reg file reg1 read data
    wire[31:0]IDrf_rD2_pre; // reg file reg2 read data
    RegFile RF(
        .clk    (clk),
        .rst_n  (rst_n),
        
        .rR1    (IDinst[19:15]),
        .rR2    (IDinst[24:20]),
        .rD1    (IDrf_rD1_pre),
        .rD2    (IDrf_rD2_pre),
        
        .wen    (WBrf_we),
        .wR     (WBinst[11:7]),
        .wD     (WBrf_wd)
    );  // 32-bit 32-num reg file
    Mux4_1 toRS1(
        .sel    (rd1_sel),
        .a0     (IDrf_rD1_pre),
        .a1     (fw1),
        .a2     (0),
        .a3     (0),
        .b      (IDrf_rD1)
    );
    wire[31:0]IDrf_rD2;
    Mux4_1 toRS2(
        .sel    (rd2_sel),
        .a0     (IDrf_rD2_pre),
        .a1     (fw2),
        .a2     (0),
        .a3     (0),
        .b      (IDrf_rD2)
    );
    BranchComp BC(
        .a          (IDrf_rD1),
        .b          (IDrf_rD2),
        .br_ctrl    (br_ctrl),
        .br_true    (br_true)   // output
    );  // branch compare
    wire[31:0]IDalu_b;
    Mux4_1 toALU_B2(
        .sel    (alub_sel),
        .a0     (IDrf_rD2),
        .a1     (IDext),
        .a2     (0),
        .a3     (0),
        .b      (IDalu_b)
    );  // 2-1 Mux to alu_b
    wire[31:0]EXpc4;
    wire EXdram_we;
    wire[31:0]EXext;
    wire[31:0]EXrf_rD1;
    wire[31:0]EXrf_rD2;
    wire[31:0]EXalu_b;
    wire[2:0]EXalu_op;
    ID_EX_reg reg1(
        .clk            (clk),
        .rst_n          (rst_n),
        
        .IDpc           (IDpc),
        .IDpc4          (IDpc4),
        .IDinst         (IDinst),
                        
        .IDwd_sel       (IDwd_sel),
        .IDrf_we        (IDrf_we),
        .IDdram_we      (IDdram_we),
                        
        .IDext          (IDext),
                        
        .IDrf_rD1       (IDrf_rD1),
        .IDrf_rD2       (IDrf_rD2),
                        
        .IDalu_b        (IDalu_b),
        .IDalu_op       (IDalu_op),
                        
        .EXpc           (EXpc),
        .EXpc4          (EXpc4),
        .EXinst         (EXinst),
                        
        .EXwd_sel       (EXwd_sel),
        .EXrf_we        (EXrf_we),
        .EXdram_we      (EXdram_we),
                        
        .EXext          (EXext),
                        
        .EXrf_rD1       (EXrf_rD1),
        .EXrf_rD2       (EXrf_rD2),
                        
        .EXalu_b        (EXalu_b),
        .EXalu_op       (EXalu_op)
    );
    
    // EX
    wire[31:0]EXalu_c;
    ALU ALU(
        .a          (EXrf_rD1),
        .b          (EXalu_b),
        .c          (EXalu_c),
        .op         (EXalu_op)
    );  // alu
    Mux4_1 toEXrf_wd(
        .sel    (EXwd_sel),
        .a0     (EXalu_c),
        .a1     (EXpc4),
        .a2     (EXext),
        .a3     (0),
        .b      (EXrf_wd)
    );  // 4-1 Mux to rf_wd
    wire[31:0]MEMpc;
    wire[31:0]MEMpc4;
    wire[1:0]MEMwd_sel;
    wire[31:0]MEMext;
    EX_MEM_reg reg2(
        .clk            (clk),
        .rst_n          (rst_n),
        
        .EXpc           (EXpc),
        .EXpc4          (EXpc4),
        .EXinst         (EXinst),
                        
        .EXwd_sel       (EXwd_sel),
        .EXrf_we        (EXrf_we),
        .EXdram_we      (EXdram_we),
                        
        .EXext          (EXext),
        .EXrf_rD2       (EXrf_rD2),
        .EXalu_c        (EXalu_c),
                        
        .MEMpc          (MEMpc),
        .MEMpc4         (MEMpc4),
        .MEMinst        (MEMinst),
                        
        .MEMwd_sel      (MEMwd_sel),
        .MEMrf_we       (MEMrf_we),
        .MEMdram_we     (MEMdram_we),
                        
        .MEMext         (MEMext),
        .MEMrf_rD2      (MEMrf_rD2),               
        .MEMalu_c       (MEMalu_c)
    );
    
    // MEM
    Mux4_1 toRF_wD4(
        .sel    (MEMwd_sel),
        .a0     (MEMalu_c),
        .a1     (MEMpc4),
        .a2     (MEMext),
        .a3     (MEMdm_rd),
        .b      (MEMrf_wd)
    );  // 4-1 Mux to rf_wd
    wire[31:0]WBpc;
    MEM_WB_reg reg3(
        .clk            (clk),
        .rst_n          (rst_n),
        
        .MEMpc          (MEMpc),
        .MEMinst        (MEMinst),
                        
        .MEMrf_we       (MEMrf_we),
        .MEMrf_wd       (MEMrf_wd),
                        
        .WBpc           (WBpc),
        .WBinst         (WBinst),
                        
        .WBrf_we        (WBrf_we),
        .WBrf_wd        (WBrf_wd)
    );
    
    // debug
    assign debug_wb_have_inst   =   (MEMpc != WBpc);    // except inst excute itself twice or more but not bubble
    assign debug_wb_pc          =   WBpc;
    assign debug_wb_ena         =   WBrf_we;
    assign debug_wb_reg         =   WBinst[11:7];
    assign debug_wb_value       =   WBrf_wd;
    
endmodule
