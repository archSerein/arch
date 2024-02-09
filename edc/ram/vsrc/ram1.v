module ram1(clk, seg0, seg1, en, inputaddr, outputaddr, in, out);

  input clk;
  input en;
  input [3:0] inputaddr;
  input [3:0] outputaddr;
  input [7:0] in;
  output reg [7:0] out;
  output [6:0] seg0;
  output [6:0] seg1;

  reg [7:0] ram1 [15:0];

  initial
  begin
    $readmemh("/home/serein/ysyx/yosys-sta/edc/ram/vsrc/ram.txt", ram1);
  end

  always @ (posedge clk)
  begin
    if(en)
      ram1[inputaddr] <= in;
    else
      out <= ram1[outputaddr];
  end

  seg segl(
    .data(out),
    .seg0(seg0),
    .seg1(seg1)
  );
endmodule
