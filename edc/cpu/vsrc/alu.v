module alu(a, b, aluc, out, zero, less);
  input [31:0] a, b;
  input [3:0] aluc;
  output [31:0] out;
  output zero;
  output less;

  // 拓展成32位
  wire [31:0] extend = {32{aluc[3]}};
  
  // 与B异或运算
  wire [31:0] xorb = b ^ extend;

  // adder
  wire [32:0] sum = {1'b0, a} + {1'b0, xorb} + {32'b0, aluc[3]};

  wire carry = sum[32];

  wire zero = (sum[31:0] == 32'd0);

  wire overflow = sum[32] ^ sum[31];

  // AND
  wire [31:0] andu = a & b;

  // OR
  wire [31:0] oru = a | b;

  // XOR
  wire [31:0] xoru = a ^ b;
  
  wire [4:0] distance = b[4:0];
  
  // left shift
  wire [31:0] leftshift = a << distance;
  
  // right logic shift
  wire [31:0] rightlogicshift = a >> distance;

  // right arithmetic shift
  wire [31:0] rightarithmeticshift = a >>> distance;

  wire [31:0] rightshift = (aluc[3] == 1'b1) ? rightarithmeticshift : rightlogicshift;
  // less
  wire [31:0] xor1 = {32{1'b1}} ^ b;
  wire [32:0] lessm = {1'b0, a} + {1'b0, xor1} + {32'b0, 1'b1};
  wire less = (aluc[3] == 1'b1) ? (carry ^ aluc[3]) : (overflow ^ lessm[31]);

  assign out =  (aluc[2:0] == 3'd0) ? sum[31:0] :
                (aluc[2:0] == 3'd1) ? leftshift :
                (aluc[2:0] == 3'd2) ? {31'd0, less} :
                (aluc[2:0] == 3'd3) ? b :
                (aluc[2:0] == 3'd4) ? xoru: 
                (aluc[2:0] == 3'd5) ? rightshift :
                (aluc[2:0] == 3'd6) ? oru :
                (aluc[2:0] == 3'd7) ? andu :
                32'd0;
endmodule
