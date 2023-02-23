module ALU(
    input wire[31:0]a,
    input wire[31:0]b,
    input wire[2:0]op,       // cu.alu_op
    input wire[2:0]br_ctrl,  // cu.br_ctrl
    output wire br_true,     // to set cu.br_true
    output wire[31:0]c
    );
    
    assign c = decoder(a, b, op);                           // op decoder
    function [31:0]decoder(input [31:0]a, input [31:0]b, input [2:0]op);
    begin
        case(op)
            3'd0:       decoder = a + b;                    // add
            3'd1:       decoder = a + ((~b) + 32'b1);       // sub
            3'd2:       decoder = a & b;                    // and
            3'd3:       decoder = a | b;                    // or
            3'd4:       decoder = a ^ b;                    // xor
            3'd5:       decoder = a << b[4:0];              // sll
            3'd6:       decoder = a >> b[4:0];              // srl
            3'd7:       decoder = ($signed(a)) >>> b[4:0];  // sra
            default:    decoder = 32'b0;
        endcase
    end
    endfunction
    
    assign br_true = branch(br_ctrl, c);     // branch control
    function branch(input [2:0]br_ctrl, input [31:0]c);
    begin
        case(br_ctrl)
            3'd0:       branch = 1'b0;          // no branch
            3'd1:       branch = (c == 32'b0);  // beq
            3'd2:       branch = (c != 32'b0);  // bne
            3'd3:       branch = c[31];         // blt
            3'd4:       branch = ~c[31];        // bge
            default:    branch = 1'b0;
        endcase
    end
    endfunction
               
endmodule
