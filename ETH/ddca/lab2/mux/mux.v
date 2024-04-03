module mux(
    input a,
    input b,
    input x,
    input y,
    input [1:0] c,
    output o
);

    wire t1, t2;
    mux21 mux_a_b(a, b, c[0], t1);
    mux21 mux_x_y(x, y, c[0], t2);
    mux21 mux_o(t1, t2, c[1], o);

endmodule

module mux21 (
    input a,
    input b,
    input c,
    output o
);

    assign o = c == 1'b1 ? a : b;
endmodule
