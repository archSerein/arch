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
