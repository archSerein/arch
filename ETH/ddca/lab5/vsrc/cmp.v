module cmp(
    input Z,
    input V,
    input N,
    input [1:0] fn,
    output [31:0] cmp
);

    wire result;
    assign result = (fn == 2'b01) ? Z :
                    (fn == 2'b11) ? (N | Z) :
                    N;
    assign cmp = {{31{1'b0}}, result};
endmodule
