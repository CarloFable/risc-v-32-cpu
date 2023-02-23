module DataHazard(
    input wire[31:0]IDinst,
    input wire[31:0]EXinst,
    input wire[31:0]MEMinst,
    input wire[31:0]WBinst,
    
    input wire EXrf_we,
    input wire MEMrf_we,
    input wire WBrf_we,
    
    input wire[31:0]IDpc,
    input wire[31:0]EXpc,
    
    input wire re1,
    input wire re2,
    input wire[1:0]EXwd_sel,
    
    input wire[31:0]EXrf_wd,
    input wire[31:0]MEMrf_wd,
    input wire[31:0]WBrf_wd,
    
    output reg Dpc_ctrl,
    output reg[1:0]rd1_sel,
    output reg[1:0]rd2_sel,
    
    output reg[31:0]fw1,    // data forward
    output reg[31:0]fw2
    );
    
    // pc control for lw-use
    always@(*)begin
        if(IDpc == EXpc)    Dpc_ctrl = 1'b0;
        else if(IDinst[19:15] != 5'd0 && IDinst[19:15] == EXinst[11:7] && EXrf_we && re1 && EXwd_sel == 2'd3)
                            Dpc_ctrl = 1'b1;
        else if(IDinst[24:20] != 5'd0 && IDinst[24:20] == EXinst[11:7] && EXrf_we && re2 && EXwd_sel == 2'd3)
                            Dpc_ctrl = 1'b1;
        else                Dpc_ctrl = 1'b0;
    end
    
    // rd1_sel
    always@(*)begin
        if(IDinst[19:15] == 5'd0)   rd1_sel = 2'd0;
        else if(IDpc != EXpc && IDinst[19:15] == EXinst[11:7] && EXrf_we && re1 && EXwd_sel != 2'd3)    
                                    rd1_sel = 2'd1;
        else if(IDinst[19:15] == MEMinst[11:7] && MEMrf_we && re1)                      
                                    rd1_sel = 2'd1;
        else if(IDinst[19:15] == WBinst[11:7] && WBrf_we && re1)                        
                                    rd1_sel = 2'd1;
        else                        rd1_sel = 2'd0;
    end
    
    // rd2_sel
    always@(*)begin
        if(IDinst[24:20] == 5'd0)   rd2_sel = 2'd0;
        else if(IDpc != EXpc && IDinst[24:20] == EXinst[11:7] && EXrf_we && re2 && EXwd_sel != 2'd3)   
                                    rd2_sel = 2'd1;
        else if(IDinst[24:20] == MEMinst[11:7] && MEMrf_we && re2)                      
                                    rd2_sel = 2'd1;
        else if(IDinst[24:20] == WBinst[11:7] && WBrf_we && re2)                        
                                    rd2_sel = 2'd1;
        else                        rd2_sel = 2'd0;
    end
    
    // forward1
    always@(*)begin
        if(IDinst[19:15] == 5'd0)   fw1 = 32'b0;
        else if(IDpc != EXpc && IDinst[19:15] == EXinst[11:7] && EXrf_we && re1 && EXwd_sel != 2'd3)   
                                    fw1 = EXrf_wd;
        else if(IDinst[19:15] == MEMinst[11:7] && MEMrf_we && re1)                      
                                    fw1 = MEMrf_wd;
        else if(IDinst[19:15] == WBinst[11:7] && WBrf_we && re1)                        
                                    fw1 = WBrf_wd;
        else                        fw1 = 32'b0;
    end
    
    // forward2
    always@(*)begin
        if(IDinst[24:20] == 5'd0)   fw2 = 32'b0;
        else if(IDpc != EXpc && IDinst[24:20] == EXinst[11:7] && EXrf_we && re2 && EXwd_sel != 2'd3)    
                                    fw2 = EXrf_wd;
        else if(IDinst[24:20] == MEMinst[11:7] && MEMrf_we && re2)                      
                                    fw2 = MEMrf_wd;
        else if(IDinst[24:20] == WBinst[11:7] && WBrf_we && re2)                        
                                    fw2 = WBrf_wd;
        else                        fw2 = 32'b0;
    end
    
endmodule
