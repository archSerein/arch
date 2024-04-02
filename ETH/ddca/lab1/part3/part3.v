module part3(
    input a,
    input b,
    output O1,
    output O2,
    output O3
);

    wire t0, t1, t2, t3, t4, t5;
    nand nand1(t0, a, 1'b1);
    nand nand2(t1, t0, b);
    nand nand3(O3, t1, 1'b1);

    nand nand4(t2, a, b);
    nand nand5(t3, b, 1'b1);
    nand nand6(t4, t0, t3);
    nand nand7(O2, t2, t4);

    nand nand8(t5, t3, a);
    nand nand9(O1, t5, 1'b1);
endmodule
