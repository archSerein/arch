module part2(
    input a,
    input b,
    output [2:0] O
);

    wire nota, notb;
    not not_1(nota, a);
    not not_2(notb, b);

    and and_1(O[0], a, notb);
    and and_2(O[2], nota, b);
    xnor xnor_1(O[1], a, b);

endmodule
