module shift(en, in, coda, seg1, seg0);
  input en;
  input [7:0] in;
  output reg [7:0] coda;
  output wire [6:0] seg1;
  output wire [6:0] seg0;

  reg x8;
  
  assign x8 = coda[4] ^ coda[3] ^ coda[2] ^ coda[0];
  
  always @(posedge en) 
  begin
    if (coda == 8'b00000000 && in != 8'b00000000)
    begin
      coda <= in;
    end 
    else 
    begin
      coda <= {x8, coda[7:1]};
    end
  end

  seg segl(
    .coda(coda),
    .seg0(seg0),
    .seg1(seg1)
  );
endmodule

