module decode(
    input [1:0] in,
    output [3:0] out
);

    wire a, b, c, d, e;
    and and1(out[3], in[0], in[1]);
    not not1(a, in[0]);
    not not2(b, in[1]);
    and and2(out[2], in[1], a);
    and and3(out[1], b, in[0]);
    and and4(out[0], a, b);
endmodule
