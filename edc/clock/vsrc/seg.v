module seg(
    input [3:0] x,
    input [3:0] y,
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output reg [15:0] ledl,
    output reg [6:0] seg0,
    output reg [6:0] seg1,
    output reg [6:0] seg2,
    output reg [6:0] seg3,
    output reg [6:0] seg4,
    output reg [6:0] seg5,
    output reg [15:0] led
);

     function [6:0] get_seg;
          input [3:0] value;
          begin
               case(value)
                    4'b0000: get_seg = 7'b0000001;
                    4'b0001: get_seg = 7'b1001111;
                    4'b0010: get_seg = 7'b0010010;
                    4'b0011: get_seg = 7'b0000110;
                    4'b0100: get_seg = 7'b1001100;
                    4'b0101: get_seg = 7'b0100100;
                    4'b0110: get_seg = 7'b0100000;
                    4'b0111: get_seg = 7'b0001111;
                    4'b1000: get_seg = 7'b0000000;
                    4'b1001: get_seg = 7'b0000100;
                    default: get_seg = 7'b1111111;
               endcase
          end
     endfunction

     always @ (*)
     begin
          seg0 = get_seg(x);
          seg1 = get_seg(y);
          seg2 = get_seg(a);
          seg3 = get_seg(b);
          seg4 = get_seg(c);
          seg5 = get_seg(d);
     end
     assign led = ledl;
endmodule

