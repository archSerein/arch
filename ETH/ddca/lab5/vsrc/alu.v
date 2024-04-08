module alu(
    input [31:0] x,
    input [31:0] y,
    input [3:0] fn,
    output [31:0] out,
    output zero
);

    // 连接中间信号
    wire [31:0] a, S, b, cmp;
    wire Z, V, N, carry;

    // 算术模块 
    arith arith_module(
        .x(x),
        .y(y),
        .AFN(fn[1]),
        .S(S),
        .Z(Z),
        .V(V),
        .N(N),
        .carry(carry)
    );

    // 比较模块
    cmp cmp_module(
        .Z(Z),
        .V(V),
        .N(N),
        .fn(fn[3:2]),
        .cmp(cmp)
    );

    // 移位模块
    shift shift_module(
        .x(x),
        .y(y[4:0]),
        .fn(fn[1:0]),
        .out(b)
    );

    // 布尔计算模块
    bool bool_module(
        .a(x),
        .b(y),
        .fn(fn[3:0]),
        .S(a)
    );

    // 选择需要的输出
    
    wire [31:0] shift_out, cmp_out, arith_out, bool_out;
    assign cmp_out = fn[3:2] == 2'b10 ? cmp : 32'h0;
    assign arith_out = fn[3:2] == 2'b00 ? S : 32'h0;
    assign bool_out = fn[3:2] == 2'b01 ? a : 32'h0;
    assign shift_out = fn[3:2] == 2'b11 ? b : 32'h0;

    assign out = cmp_out | arith_out | bool_out | shift_out;
    assign zero = N;
endmodule

module bool(
    input [31:0] a,
    input [31:0] b,
    input [3:0] fn,
    output [31:0] S 
);

    wire [3:0] fn1;
    assign  fn1 = (fn == 4'b0100) ? 4'b1000 :
                  (fn == 4'b0101) ? 4'b1110 :
                  (fn == 4'b0110) ? 4'b0110 :
                  4'b0001;
    genvar i;

    generate
        for(i = 0; i < 32; i = i + 1)
        begin   :   bool
            MuxKey #(4, 2, 1) mux (S[i], {a[i], b[i]}, {
                2'b00, fn1[0],
                2'b01, fn1[1],
                2'b10, fn1[2],
                2'b11, fn1[3]
                });
        end
    endgenerate
endmodule

