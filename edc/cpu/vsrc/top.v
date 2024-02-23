module top(
  input clk,
  input rst,
  input [31:0] a,
  input [31:0] b,
  input [3:0] aluc,
  input [3:0] byteena_a,
  input [31:0]  data,
  input [14:0]  rdaddress,
  input [14:0]  wraddress,
  input wren,
  input [4:0] ra,
  input [4:0] rb,
  input [4:0] rw,
  input [31:0] busw,
  input regwr,
  output [31:0] busa,
  output [31:0] busb,
  output zero,
  output less,
  output [31:0] out,
  output reg  [31:0]  q,
  output [6:0] seg0,
  output [6:0] seg1,
  output [6:0] seg2,
  output [6:0] seg3,
  output [6:0] seg4,
  output [6:0] seg5,
  output [6:0] seg6,
  output [6:0] seg7
);

alu myalu(
  .a(a),
  .b(b),
  .aluc(aluc),
  .zero(zero),
  .less(less),
  .out(out)
);


datamem mydatemem(
   .clk(clk), 
   .byteena_a(byteena_a),
   .data(data),
   .rdaddress(rdaddress),
   .wraddress(wraddress),
   .wren(wren),
   .q(q)
 );

regfile myreg(
  .clk(clk), 
  .rst(rst), 
  .regwr(regwr), 
  .rw(rw),
  .ra(ra), 
  .rb(rb),
  .busw(busw),
  .busa(busa), 
  .busb(busb)
);

seg myseg(
  .data(out),
  .seg0(seg0),
  .seg1(seg1),
  .seg2(seg2),
  .seg3(seg3),
  .seg4(seg4),
  .seg5(seg5),
  .seg6(seg6),
  .seg7(seg7)
);

endmodule
