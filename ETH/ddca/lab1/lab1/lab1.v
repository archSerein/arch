module lab1(
    input [3:0] a,
    input [3:0] b,
    output out
);

    wire [3:0] equal;
    wire [1:0] out_s;
    comp_1 comp1(a[3], b[3], equal[3]);
    comp_1 comp2(a[2], b[2], equal[2]);
    comp_1 comp3(a[1], b[1], equal[1]);
    comp_1 comp4(a[0], b[0], equal[0]);

    or out_s1(out_s[0], equal[0], equal[1]);
    or out_s2(out_s[1], out_s[0], equal[2]);
    or out_s3(out, out_s[1], equal[3]);

endmodule

module comp_1(
    input a,
    input b,
    output equal
);
    xor equal_a_b(equal, a, b);

endmodule
