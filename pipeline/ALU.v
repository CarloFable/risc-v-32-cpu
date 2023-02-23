module ALU(
    input wire[31:0]a,
    input wire[31:0]b,
    input wire[2:0]op,       // cu.alu_op
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
               
endmodule
