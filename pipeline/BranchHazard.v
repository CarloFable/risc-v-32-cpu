module BranchHazard(
    input wire[31:0]IFpc,
    input wire[31:0]IDpc,
    
    input wire Dpc_ctrl,    // from data hazard
    input wire[31:0]IFinst,
    input wire[31:0]IDinst,
    
    input wire[31:0]IDnpc,
    
    output reg[31:0]IFnpc
    );
    
    always@(*)begin
        if(Dpc_ctrl)                                IFnpc = IFpc;           // dataHazard bubble
        else if(IDpc == IFpc && IDinst[6] == 1'b1)  IFnpc = IDnpc;          // jal/jalr/B excute
        else if(IFinst[6] == 1'b1)                  IFnpc = IFpc;           // jal/jalr/B bubble
        else                                        IFnpc = IFpc + 32'd4;
    end
    
endmodule
