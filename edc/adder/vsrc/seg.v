module seg (
    input [3:0] out,
    output wire [6:0] seg0,
    output wire [6:0] seg1
);
    reg [2:0] out_s;
    
    assign seg1 = (out[3] == 1) ? 7'b1111110 : 7'b1111111;
    assign out_s = (out[3] == 1) ? (~out[2:0] + 3'b001) : out[2:0];
    
    assign seg0 = (out_s == 3'b000) ? 7'b0000001 :
                  (out_s == 3'b001) ? 7'b1001111 :
                  (out_s == 3'b010) ? 7'b0010010 :
                  (out_s == 3'b011) ? 7'b0000110 :
                  (out_s == 3'b100) ? 7'b1001100 :
                  (out_s == 3'b101) ? 7'b0100100 :
                  (out_s == 3'b110) ? 7'b0100000 :
                  (out_s == 3'b111) ? 7'b0001111 :
                  7'b1111111;
endmodule

