module shift(
    input [31:0] x,
    input [4:0] y,
    input [1:0] fn,
    output [31:0] out
);

    // shift left
    wire [31:0] Q, R, S, T, SL;

    assign Q = y[4] == 1'b1 ? {x[15:0], {16{1'b0}}} : x;
    assign R = y[3] == 1'b1 ? {Q[23:0], {8{1'b0}}} : Q;
    assign S = y[2] == 1'b1 ? {R[27:0], {4{1'b0}}} : R;
    assign T = y[1] == 1'b1 ? {S[29:0], {2{1'b0}}} : S;
    assign SL = y[0] == 1'b1 ? {T[30:0], {1{1'b0}}} : T;

    // shift right logic
    wire [31:0] Q1, R1, S1, T1, SR;

    assign Q1 = y[4] == 1'b1 ? {{16{1'b0}}, x[31:16]} : x;
    assign R1 = y[3] == 1'b1 ? {{8{1'b0}}, Q1[31:8]} : Q1;
    assign S1 = y[2] == 1'b1 ? {{4{1'b0}}, R1[31:4]} : R1;
    assign T1 = y[1] == 1'b1 ? {{2{1'b0}}, S1[31:2]} : S1;
    assign SR = y[0] == 1'b1 ? {{1{1'b0}}, T1[31:1]} : T1;

    // shift right arithmetic
    wire [31:0] Q2, R2, S2, T2, SA;

    assign Q2 = y[4] == 1'b1 ? {{16{x[31]}}, x[31:16]} : x;
    assign R2 = y[3] == 1'b1 ? {{8{x[31]}}, Q2[31:8]} : Q2;
    assign S2 = y[2] == 1'b1 ? {{4{x[31]}}, R2[31:4]} : R2;
    assign T2 = y[1] == 1'b1 ? {{2{x[31]}}, S2[31:2]} : S2;
    assign SA = y[0] == 1'b1 ? {{1{x[31]}}, T2[31:1]} : T2;

    // Output logic
    wire [31:0] out_SL, out_SR, out_SA;

    assign out_SL = fn == 2'b00 ? SL : 32'b0;
    assign out_SR = fn == 2'b01 ? SR : 32'b0;
    assign out_SA = fn == 2'b11 ? SA : 32'b0;

    assign out = out_SL | out_SR | out_SA;

endmodule
