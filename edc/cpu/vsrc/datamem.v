module datamem( clk, 
                byteena_a,
                data,
                rdaddress,
                wraddress,
                wren,
                q);

  input       clk;
  input       [3:0] byteena_a;
  input       [31:0]  data;
  input       [14:0]  rdaddress;
  input       [14:0]  wraddress;
  input       wren;
  output reg  [31:0]  q;

  reg  [31:0] tempout;
  wire [31:0] tempin;
  reg [31:0] ram [63:0];
  reg rdclock, wrclock;

  always @(posedge clk)
  begin
    rdclock <= ~rdclock;
    wrclock <= ~wrclock;
  end

  always @(posedge rdclock)
  begin
    if(wren)
      tempout<=ram[wraddress[5:0]];
    else
      q <= ram[rdaddress[5:0]];
  end

    assign tempin[7:0]   = (byteena_a[0])? data[7:0]  : tempout[7:0];
    assign tempin[15:8]  = (byteena_a[1])? data[15:8] : tempout[15:8];
    assign tempin[23:16] = (byteena_a[2])? data[23:16]: tempout[23:16];
    assign tempin[31:24] = (byteena_a[3])? data[31:24]: tempout[31:24];

  always@(posedge wrclock)
  begin
    if(wren)
    begin
      ram[wraddress[5:0]]<=tempin;
    end
    else
    begin
    end
  end
endmodule
