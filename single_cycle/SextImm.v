module SextImm(
    input wire[24:0]din,  // irom.inst[31:7]
    input wire[2:0]op,    // cu.sext_op
    output wire[31:0]ext  // SEXT.ext
    );
    
    assign ext = sext(din, op);  // sext imm for i/b/j/s/u
    function [31:0]sext(input [24:0]din, input [2:0]op);
    begin
        case(op)
            3'd0:       sext = {{20{din[24]}}, din[24:13]};                                     // I-type
            3'd1:       sext = {{19{din[24]}}, din[24], din[0], din[23:18], din[4:1], 1'b0};    // B-type
            3'd2:       sext = {{11{din[24]}}, din[24], din[12:5], din[13], din[23:14], 1'b0};  // J-type
            3'd3:       sext = {{20{din[24]}}, din[24:18], din[4:0]};                           // S-type
            3'd4:       sext = {din[24:5], 12'b0};                                              // U-type
            default:    sext = 32'b0;
        endcase
    end
    endfunction

endmodule
