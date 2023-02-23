module top(
    input wire clk,     // 100MHz
    input wire rst_n,   // low level reset
    // debug
    output wire debug_wb_have_inst,
    output wire[31:0]debug_wb_pc,
    output wire debug_wb_ena,
    output wire[4:0]debug_wb_reg,
    output wire[31:0]debug_wb_value//,
    // I/O
    /*input wire [23:0]sw,
    output wire [23:0]led,
    output wire led0_en,
    output wire led1_en,
    output wire led2_en,
    output wire led3_en,
    output wire led4_en,
    output wire led5_en,
    output wire led6_en,
    output wire led7_en,
    output wire led_ca ,
    output wire led_cb ,
    output wire led_cc ,
    output wire led_cd ,
    output wire led_ce ,
    output wire led_cf ,
    output wire led_cg ,
    output wire led_dp*/
    );
    
    // IF
    wire[31:0]pc;
    wire[31:0]inst;
    // MEM
    wire[31:0]alu_c;    // alu result
    wire[31:0]rf_rD2;   // reg file reg2 read data
    wire dram_we;
    wire[31:0]dm_rd;
    wire dram_we0;      // datamemory write enable
    wire[31:0]dm_rd0;   // data memory read data
    
    // set global clock
    /*wire globalclk;  // 25MHz
    cpuclk cpuclk(
        .clk_in1    (clk),
        .clk_out1   (globalclk)
    );*/
    
    mini_rv mini_rv_u(
        .clk                    (/*global*/clk),
        .rst_n                  (rst_n),
        // IF
        .IFinst                 (inst),
        .IFpc                   (pc),
        // MEM
        .MEMdm_rd               (dm_rd),
        .MEMdram_we             (dram_we),
        .MEMalu_c               (alu_c),
        .MEMrf_rD2              (rf_rD2),
        // debug
        .debug_wb_have_inst     (debug_wb_have_inst),
        .debug_wb_pc            (debug_wb_pc),
        .debug_wb_ena           (debug_wb_ena),
        .debug_wb_reg           (debug_wb_reg),
        .debug_wb_value         (debug_wb_value)
    );
    
    // I/O select (datamemory, switch, led)
    /*IOSel dsl(
        .clk        (globalclk),
        .rst_n      (rst_n),
        // MEM
        .addr       (alu_c),
        .dm_we      (dram_we),
        .dm_rd0     (dm_rd0),
        .sw         (sw),
        .din        (rf_rD2),
        .dm_rd      (dm_rd),
        .led        (led),
        .dm_we0     (dram_we0)
    );*/
    
    // IF
    // 64KB IROM
    inst_mem imem(
        .a      (pc[15:2]),
        .spo    (inst)
    );
    
    // MEM
    // 64KB DRAM
    data_mem dmem(
        .clk    (/*global*/clk),
        .we     (dram_we/*0*/),
        .a      (alu_c[15:2]),
        .d      (rf_rD2),
        .spo    (dm_rd/*0*/)
    );
    
    // I/O
    /*wire clk_o;                     // 1kHz
    divider dvd(globalclk, clk_o);  // 25MHz to 1kHz
    display dp(clk_o, 1, pc,
        led0_en, led1_en, led2_en, led3_en,
        led4_en, led5_en, led6_en, led7_en,
        led_ca, led_cb, led_cc, led_cd,
        led_ce, led_cf, led_cg, led_dp
    );*/
    
endmodule
