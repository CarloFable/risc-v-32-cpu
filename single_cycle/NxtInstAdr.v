module NxtInstAdr(
    input wire[31:0]pc,
    input wire[31:0]imm,
    input wire[31:0]base,
    input wire[1:0]op,
    output wire[31:0]pc4,
    output wire[31:0]npc
    );
    
    assign pc4 = pc + 32'd4;                    // pc+4
    
    assign npc = get_npc(pc, imm, base, op);    // calculate npc
    function [31:0]get_npc(input [31:0]pc, input [31:0]imm, input [31:0]base, input [1:0]op);
    begin
        case(op)
            2'd0:       get_npc = pc + 32'd4;               // pc+4 or branch false: pc+4
            2'd1:       get_npc = pc + imm;                 // jal or branch true: pc+imm
            2'd2:       get_npc = (base + imm) & (~32'd1);  // jalr: (base+imm)&~1
            default:    get_npc = pc + 32'd4;
        endcase
    end
    endfunction
             
endmodule
