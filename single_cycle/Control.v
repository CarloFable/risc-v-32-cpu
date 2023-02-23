module Control(
    input wire[31:0]inst,
    input wire br_true,
    output wire[2:0]br_ctrl,
    output wire[1:0]npc_op,
    output wire[2:0]sext_op,
    output wire[2:0]alu_op,
    output wire[1:0]alub_sel,
    output wire[1:0]wd_sel,
    output wire rf_we,
    output wire dram_we
    );
    
    wire [16:0]out;     // all outputs
    assign out = opdec(inst[30], inst[14:12], inst[6:0]);   // operation decoder
    function [16:0]opdec(input f7, input [2:0]f3, input [6:0]op);
    begin
        case(op)
            7'b0110011:begin    // R
                case(f3)
                    3'b000:begin    // add/sub
                        if(!f7) opdec = {3'd0, 2'd0, 3'd0, 3'd0, 2'd0, 2'd0, 1'd1, 1'd0};   // add
                        else    opdec = {3'd0, 2'd0, 3'd0, 3'd1, 2'd0, 2'd0, 1'd1, 1'd0};   // sub
                    end
                    3'b111: opdec = {3'd0, 2'd0, 3'd0, 3'd2, 2'd0, 2'd0, 1'd1, 1'd0};       // and
                    3'b110: opdec = {3'd0, 2'd0, 3'd0, 3'd3, 2'd0, 2'd0, 1'd1, 1'd0};       // or
                    3'b100: opdec = {3'd0, 2'd0, 3'd0, 3'd4, 2'd0, 2'd0, 1'd1, 1'd0};       // xor
                    3'b001: opdec = {3'd0, 2'd0, 3'd0, 3'd5, 2'd0, 2'd0, 1'd1, 1'd0};       // sll
                    3'b101:begin    // srl/sra
                        if(!f7) opdec = {3'd0, 2'd0, 3'd0, 3'd6, 2'd0, 2'd0, 1'd1, 1'd0};   // srl
                        else    opdec = {3'd0, 2'd0, 3'd0, 3'd7, 2'd0, 2'd0, 1'd1, 1'd0};   // sra
                    end
                    default:    opdec = {3'd0, 2'd0, 3'd4, 3'd5, 2'd1, 2'd2, 1'd1, 1'd0};   // lui
                endcase
            end
            7'b0010011:begin    // I (addi...srai)
                case(f3)
                    3'b000: opdec = {3'd0, 2'd0, 3'd0, 3'd0, 2'd1, 2'd0, 1'd1, 1'd0};   // addi
                    3'b111: opdec = {3'd0, 2'd0, 3'd0, 3'd2, 2'd1, 2'd0, 1'd1, 1'd0};   // andi
                    3'b110: opdec = {3'd0, 2'd0, 3'd0, 3'd3, 2'd1, 2'd0, 1'd1, 1'd0};   // ori
                    3'b100: opdec = {3'd0, 2'd0, 3'd0, 3'd4, 2'd1, 2'd0, 1'd1, 1'd0};   // xori
                    3'b001: opdec = {3'd0, 2'd0, 3'd0, 3'd5, 2'd1, 2'd0, 1'd1, 1'd0};   // slli
                    3'b101:begin    // srli/srai
                        if(!f7) opdec = {3'd0, 2'd0, 3'd0, 3'd6, 2'd1, 2'd0, 1'd1, 1'd0};   // srli
                        else    opdec = {3'd0, 2'd0, 3'd0, 3'd7, 2'd1, 2'd0, 1'd1, 1'd0};   // srai
                    end
                    default:    opdec = {3'd0, 2'd0, 3'd4, 3'd5, 2'd1, 2'd2, 1'd1, 1'd0};   // lui
                endcase
            end
            7'b0000011: opdec = {3'd0, 2'd0, 3'd0, 3'd0, 2'd1, 2'd3, 1'd1, 1'd0};   // lw
            7'b1100111: opdec = {3'd0, 2'd2, 3'd0, 3'd0, 2'd1, 2'd1, 1'd1, 1'd0};   // jalr
            7'b0100011: opdec = {3'd0, 2'd0, 3'd3, 3'd0, 2'd1, 2'd0, 1'd0, 1'd1};   // S
            7'b1100011:begin    // B
                case(f3)
                    3'b000: opdec = {3'd1, 2'd0, 3'd1, 3'd1, 2'd0, 2'd0, 1'd0, 1'd0};       // beq
                    3'b001: opdec = {3'd2, 2'd0, 3'd1, 3'd1, 2'd0, 2'd0, 1'd0, 1'd0};       // bne
                    3'b100: opdec = {3'd3, 2'd0, 3'd1, 3'd1, 2'd0, 2'd0, 1'd0, 1'd0};       // blt
                    3'b101: opdec = {3'd4, 2'd0, 3'd1, 3'd1, 2'd0, 2'd0, 1'd0, 1'd0};       // bge
                    default:    opdec = {3'd0, 2'd0, 3'd4, 3'd5, 2'd1, 2'd2, 1'd1, 1'd0};   // lui
                endcase
            end
            7'b0110111: opdec = {3'd0, 2'd0, 3'd4, 3'd5, 2'd1, 2'd2, 1'd1, 1'd0};   // lui
            7'b1101111: opdec = {3'd0, 2'd1, 3'd2, 3'd0, 2'd1, 2'd1, 1'd1, 1'd0};   // jal
            default:    opdec = {3'd0, 2'd0, 3'd4, 3'd5, 2'd1, 2'd2, 1'd1, 1'd0};   // lui
        endcase
    end
    endfunction
    
    assign br_ctrl  =   out[16:14];
    assign npc_op   =   (br_ctrl == 3'd0) ? out[13:12] : {out[13], br_true};
    assign sext_op  =   out[11:9];
    assign alu_op   =   out[8:6];
    assign alub_sel =   out[5:4];
    assign wd_sel   =   out[3:2];
    assign rf_we    =   out[1];
    assign dram_we  =   out[0];
    
endmodule
