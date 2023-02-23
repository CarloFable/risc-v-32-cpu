module Mux4_1(
    input wire[31:0]a0,
    input wire[31:0]a1,
    input wire[31:0]a2,
    input wire[31:0]a3,
    input wire[1:0]sel,
    output wire[31:0]b
    );
    
    assign b = mux(a0, a1, a2, a3, sel);    // 4-1 mux
    function [31:0]mux(input [31:0]a0, input [31:0]a1, input [31:0]a2, input [31:0]a3, input [1:0]sel);
    begin
        case(sel)
            2'd0:       mux = a0;
            2'd1:       mux = a1;
            2'd2:       mux = a2;
            2'd3:       mux = a3;
            default:    mux = a0;
        endcase
    end
    endfunction
          
endmodule
