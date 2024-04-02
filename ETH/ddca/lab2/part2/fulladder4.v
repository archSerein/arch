module fulladder4(
    input [3:0] a,
    input [3:0] b,
    input ci,
    output [3:0] s,
    output co
);

    wire [2:0] cot;
    fulladder1 fulladder_0(a[0], b[0], ci, s[0], cot[0]);
    fulladder1 fulladder_1(a[1], b[1], cot[0], s[1], cot[1]);
    fulladder1 fulladder_2(a[2], b[2], cot[1], s[2], cot[2]);
    fulladder1 fulladder_3(a[3], b[3], cot[2], s[3], co);

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
