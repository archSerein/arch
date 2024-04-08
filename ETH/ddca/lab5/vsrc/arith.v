// 32位超前进位加法器
// 有两个16位的加法器构成
// 使用cla生成进位信号

module arith(
    input [31:0] x,
    input [31:0] y,
    input AFN,
    output [31:0] S,
    output Z,
    output V,
    output N,
    output carry
);

    wire [1:0] px, gx;
    wire c_16;
    wire[31:0] Y;

    fulladder16 adder16_1(
        .x(x[15:0]),
        .y(Y[15:0]),
        .c16(AFN),
        .s(S[15:0]),
        .pm(px[0]),
        .gm(gx[0])
    );

    fulladder16 adder16_2(
        .x(x[31:16]),
        .y(Y[31:16]),
        .c16(c_16),
        .s(S[31:16]),
        .pm(px[1]),
        .gm(gx[1])
    );

    // AFN 用于判断是加法还是减法
    // 两者公用一个32位加法器
    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1)
        begin : add_or_sub
            assign Y[i] = y[i] ^ AFN;
        end
    endgenerate

    assign c_16 = gx[0] | (px[0] & AFN);
    assign carry = gx[1] | (px[1] & px[0]) | (px[1] & px[0] & AFN);

    assign Z = (S == 32'h0) ? 1'b1 : 1'b0;
    assign V = (x[31] == Y[31]) && (x[31] != S[31]);
    assign N = S[31];
endmodule

module fulladder16(
    input [15:0] x,
    input [15:0] y,
    input c16,
    output [15:0] s,
    output pm,
    output gm
);

    // 16位的加法器通过将4个四位的加法器并联
    // 实现组间并联
    wire [3:0] px,  gx;
    wire [3:0] c;
    fulladder4 adder4_1(
        .x(x[3:0]),
        .y(y[3:0]),
        .cin(c[0]),
        .pn(px[0]),
        .gn(gx[0]),
        .s(s[3:0])
    );
    fulladder4 adder4_2(
        .x(x[7:4]),
        .y(y[7:4]),
        .cin(c[1]),
        .pn(px[1]),
        .gn(gx[1]),
        .s(s[7:4])
    );
    fulladder4 adder4_3(
        .x(x[11:8]),
        .y(y[11:8]),
        .cin(c[2]),
        .pn(px[2]),
        .gn(gx[2]),
        .s(s[11:8])
    );
    fulladder4 adder4_4(
        .x(x[15:12]),
        .y(y[15:12]),
        .cin(c[3]),
        .pn(px[3]),
        .gn(gx[3]),
        .s(s[15:12])
    );

    
    assign   c[0] = c16;
    assign   c[1] = gx[0] ^ (px[0] & c16);
    assign   c[2] = gx[1] ^ (px[1] & gx[0]) ^ (px[1] & px[0] & c16);
    assign   c[3] = gx[2] ^ (px[2] & gx[1]) ^ (px[2] & px[1] & gx[0]) ^ (px[2] & px[1] & px[0] & c16);

    assign  pm = px[0] & px[1] & px[2] & px[3];
    assign  gm = gx[3] ^ (px[3] & gx[2]) ^ (px[3] & px[2] & gx[1]) ^ (px[3] & px[2] & px[1] & gx[0]);

endmodule

// 四位加法器，通过四个一位加法器构建
// 使用cla超前进位
module fulladder4(
    input [3:0] x,
    input [3:0] y,
    input cin,
    output pn,
    output gn,
    output [3:0] s
);

    parameter NUM = 4;

    wire [3:0] p, g;
    wire [3:0] c;

    fulladder adder_1(
        .x(x[0]),
        .y(y[0]),
        .c(c[0]),
        .s(s[0])
    );

    fulladder adder_2(
        .x(x[1]),
        .y(y[1]),
        .c(c[1]),
        .s(s[1])
    );

    fulladder adder_3(
        .x(x[2]),
        .y(y[2]),
        .c(c[2]),
        .s(s[2])
    );

    fulladder adder_4(
        .x(x[3]),
        .y(y[3]),
        .c(c[3]),
        .s(s[3])
    );
    CLA carry_in(
        .cin(cin),
        .p(p),
        .g(g),
        .c(c)
    );

    genvar j;
    generate
        for(j = 0; j < NUM; j = j + 1)
        begin : p_g
            assign p[j] = x[j] ^ y[j];
            assign g[j] = x[j] & y[j];
        end
    endgenerate

    assign pn = p[0] & p[1] & p[2] & p[3];
    assign gn = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule

module CLA(
    input [3:0] p,
    input [3:0] g,
    input cin,
    output [3:0] c
);

    // 分别产生每一位加法需要的进位信号
    // c[4] 用于提供给下一级的CLA作为cin
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
endmodule

module fulladder(
    input x,
    input y,
    input c,
    output s
);

    wire t;
    xor xor1(t, x, y);
    xor xor2(s, t, c);
endmodule
