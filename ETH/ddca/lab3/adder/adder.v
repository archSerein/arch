/*
module adder (
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output wire [3:0] out,
    output [6:0] seg0,
    output [6:0] seg1,
    output wire [2:0] led
);
  
    // 加法
    wire [4:0] add = x + y;
    wire add_over_flow = (x[3] == y[3]) && (add[3] != x[3]);

    // 减法
    wire [3:0] t_add_Cin = {4{select[0]}} ^ y;
    wire [4:0] sub = x + t_add_Cin + {3'b000, select[0]};
    wire sub_over_flow = (x[3] == t_add_Cin[3]) && (sub[3] != x[3]);

    // 取反
    wire [3:0] notl = ~x;

    // and
    wire [3:0] andl = x & y;

    // or
    wire [3:0] orl = x | y;

    // xor
    wire [3:0] xorl = x ^ y;

    // 比较大小
    wire not_equal = ((x[2:0] < y[2:0]) && (x[3] == y[3])) || (x[3] > y[3]);

    // 是否相等
    wire equal = (x == y);

    assign out =  (select == 3'b000)  ? add[3:0]  :
                  (select == 3'b001)  ? sub[3:0]  :
                  (select == 3'b010)  ? notl      :
                  (select == 3'b011)  ? andl      :
                  (select == 3'b100)  ? orl       :
                  (select == 3'b101)  ? xorl      :
                  (select == 3'b110)  ? {3'b000, not_equal} :
                  (select == 3'b111)  ? {3'b000, equal} :
                  4'b0000;
    assign led =  (select == 3'b000)  ? {add_over_flow, add[4], zero}  :
                  (select == 3'b001)  ? {sub_over_flow, sub[4], zero}  :
                  3'b000;                                    
    
    wire zero = ~(| out);
    seg segl(
        .out(out),
        .seg0(seg0),
        .seg1(seg1)
    );
endmodule
*/



module adder(
    input [3:0] a,
    input [3:0] b,
    input ci,
    output [3:0] s,
    output [6:0] seg0,
    output [6:0] seg1,
    output co
);

    wire [2:0] cot;
    fulladder1 fulladder_0(a[0], b[0], ci, s[0], cot[0]);
    fulladder1 fulladder_1(a[1], b[1], cot[0], s[1], cot[1]);
    fulladder1 fulladder_2(a[2], b[2], cot[1], s[2], cot[2]);
    fulladder1 fulladder_3(a[3], b[3], cot[2], s[3], co);
	
    seg segl(.out_s(s), .seg0(seg0), .seg1(seg1));
endmodule

module fulladder1(
    input a,
    input b,
    input ci,
    output s,
    output co
);

    wire t;
    xnor xnor1(t, a, b);
    xnor xnor2(s, t, ci);

    wire c1, c2, c3, c4;
    and and1(c1, a, b);
    and and2(c2, a, ci);
    and and3(c3, b, ci);
    or  or1 (c4, c1, c2);
    or  or2 (co, c4, c3);

endmodule
