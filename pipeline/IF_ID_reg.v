module IF_ID_reg(
    input wire clk,
    input wire rst_n,
    
    input wire Dpc_ctrl,
    
    input wire[31:0]IFpc,
    input wire[31:0]IFinst,
    
    output reg[31:0]IDpc = 0,
    output reg[31:0]IDinst = 0
    );
    
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)          IDpc <= 32'b0;
        else if(Dpc_ctrl)   IDpc <= IDpc;       // dataHazard bubble
        else                IDpc <= IFpc;
    end
    
    reg cnt = 0;    // if reset pc in a cycle, next cycle IDinst = 0 (for Branch Hazard Control when begining)
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            IDinst <= 32'b0;
            cnt <= 1'b0;
        end
        else if(!cnt)begin
            IDinst <= 32'b0;
            cnt <= 1'b1;
        end
        else if(Dpc_ctrl)   IDinst <= IDinst;   // dataHazard bubble
        else                IDinst <= IFinst;
    end
    
endmodule
