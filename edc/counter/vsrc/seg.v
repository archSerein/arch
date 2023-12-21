module seg(
    input [3:0] x,
    input [3:0] y,
    input ledl,
    output reg [6:0] seg0,
    output reg [6:0] seg1,
    output reg led
);

     always @ (x or seg0)
     begin
        case(x)
             4'b0000: seg0 = 7'b0000001;
             4'b0001: seg0 = 7'b1001111;
             4'b0010: seg0 = 7'b0010010;
             4'b0011: seg0 = 7'b0000110;
             4'b0100: seg0 = 7'b1001100;
             4'b0101: seg0 = 7'b0100100;
             4'b0110: seg0 = 7'b0100000;
             4'b0111: seg0 = 7'b0001111;
             4'b1000: seg0 = 7'b0000000;
             4'b1001: seg0 = 7'b0000100;
             default: seg0 = 7'b1111111;
         endcase
     end
     always @ (y or seg1)
     begin
         case(y)
              4'b0000: seg1 = 7'b0000001;
              4'b0001: seg1 = 7'b1001111;
              4'b0010: seg1 = 7'b0010010;
              4'b0011: seg1 = 7'b0000110;
              4'b0100: seg1 = 7'b1001100;
              4'b0101: seg1 = 7'b0100100;
              4'b0110: seg1 = 7'b0100000;
              4'b0111: seg1 = 7'b0001111;
              4'b1000: seg1 = 7'b0000000;
              4'b1001: seg1 = 7'b0000100;
              default: seg1 = 7'b1111111;
          endcase
     end
     assign led = ledl;
endmodule

