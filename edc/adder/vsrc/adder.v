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




