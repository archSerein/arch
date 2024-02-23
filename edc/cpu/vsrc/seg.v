module seg(data, seg1, seg0, seg2, seg3, seg4, seg5, seg6, seg7);
  input [31:0] data;
  output [6:0] seg1;
  output [6:0] seg0;
  output [6:0] seg2;
  output [6:0] seg3;
  output [6:0] seg4;
  output [6:0] seg5;
  output [6:0] seg6;
  output [6:0] seg7;

  function [6:0] show;
    input [3:0] data;

    reg [6:0] seg;

    begin
    seg = (data == 4'b0000) ? 7'b0000001 :
          (data == 4'b0001) ? 7'b1001111 :
          (data == 4'b0010) ? 7'b0010010 :
          (data == 4'b0011) ? 7'b0000110 :
          (data == 4'b0100) ? 7'b1001100 :
          (data == 4'b0101) ? 7'b0100100 :
          (data == 4'b0110) ? 7'b0100000 :
          (data == 4'b0111) ? 7'b0001111 :
          (data == 4'b1000) ? 7'b0000000 :
          (data == 4'b1001) ? 7'b0000100 :
          (data == 4'b1010) ? 7'b0001000 :
          (data == 4'b1011) ? 7'b1100000 :
          (data == 4'b1100) ? 7'b0110001 :
          (data == 4'b1101) ? 7'b1000010 :
          (data == 4'b1110) ? 7'b0110000 :
          (data == 4'b1111) ? 7'b0111000 :
          7'b1111111;
    show = seg;
    end
  endfunction

assign seg0 = show(data[3:0]);
assign seg1 = show(data[7:4]);
assign seg2 = show(data[11:8]);
assign seg3 = show(data[15:12]);
assign seg4 = show(data[19:16]);
assign seg5 = show(data[23:20]);
assign seg6 = show(data[27:24]);
assign seg7 = show(data[31:28]);

endmodule
