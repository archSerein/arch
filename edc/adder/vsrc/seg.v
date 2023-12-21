module seg (
    input [3:0] out,
    output reg [6:0] seg0,
    output reg [6:0] seg1
);
    reg [2:0] out_s;

    always @(out)
        begin
            if(out[3])
            begin
                seg1 = 7'b1111110;
                out_s = ~out[2:0] + 3'b001;
            end
            else
            begin
                seg1 = 7'b1111111;
                out_s = out[2:0];
            end

            case (out_s)
                3'b000: seg0 = 7'b0000001;
                3'b001: seg0 = 7'b1001111;
                3'b010: seg0 = 7'b0010010;
                3'b011: seg0 = 7'b0000110;
                3'b100: seg0 = 7'b1001100;
                3'b101: seg0 = 7'b0100100;
                3'b110: seg0 = 7'b0100000;
                3'b111: seg0 = 7'b0001111;
                default: seg0 = 7'b1111111;
            endcase
        end
endmodule

