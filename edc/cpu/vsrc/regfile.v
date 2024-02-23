module regfile(clk, rst, regwr, rw, ra, rb, busa, busb, busw);
  input [4:0] ra;
  input [4:0] rb;
  input [4:0] rw;
  input [31:0] busw;
  input regwr;
  input clk;
  input rst;
  output [31:0] busa;
  output [31:0] busb;

  reg [31:0] regfile[31:0];
  reg wrclk;

  parameter x0 = 32'd0;

  always @(posedge clk)
  begin
      wrclk <= ~wrclk;
  end

  always @(negedge wrclk)
  begin
    if(rst)
      regfile[0] <= x0;
    else if(regwr)
    begin
      if(rw != 5'b0)
        regfile[rw] <= busw;
      else
        regfile[rw] <= x0;
    end
    else
      regfile[rw] <= regfile[rw];
  end

  assign busa = regfile[ra];
  assign busb = regfile[rb];

endmodule

