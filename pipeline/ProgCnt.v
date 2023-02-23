module ProgCnt(
    input clk,
    input rst_n,
    input wire[31:0]npc,
    output reg[31:0]pc_reg = 0  // 32-bit pc reg
    );
    
    reg cnt = 0;    // if reset pc in a cycle, next cycle execute the first inst
    // update pc
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin                     // goto first inst
            pc_reg <= 32'h0;
            cnt <= 1'b0;
        end
        else if(!cnt)           cnt <= cnt + 1;     // wait a cycle
        else                    pc_reg <= npc;
    end
    
endmodule
