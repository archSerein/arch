module seg(
    input clk,
    input rst,
    input [2:0] y,
    output reg [6:0] seg0 
);
    always @ (posedge clk)
    begin
        case (y)
            3'b000: seg0 = 7'b0000001;
            3'b001: seg0 = 7'b1001111;
            3'b010: seg0 = 7'b0010010;
            3'b011: seg0 = 7'b0000110;
            3'b100: seg0 = 7'b1001100;
            3'b101: seg0 = 7'b0100100;
            3'b110: seg0 = 7'b0100000;
            3'b111: seg0 = 7'b0001111;
        endcase
    end

endmodule
