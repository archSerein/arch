module adder (
    input [3:0] x,
    input [3:0] y,
    input clk,
    input rst,
    input [2:0] select,
    output reg [3:0] out,
    output [6:0] seg0,
    output [6:0] seg1,
    output reg [2:0] led
);
    reg [3:0] to_add;
    always @(x or y or select)
    begin
        case (select)
            3'b000:
                begin
                    to_add = 4'b0000;
                    {led[1], out} = x + y;
                    led[0] = (x[3] == y[3]) && (out[3] != x[3]);
                    led[2] = ~(| out);
                end
            3'b001:
                begin
                    to_add = {4{select[0]}} ^ y;
                    {led[1], out} = x + to_add + {3'b000, select[0]};
                    led[0] = (x[3] == to_add[3]) && (out[3] != x[3]);
                    led[2] = ~(| out);
                end
            3'b010:
                begin
                    out = ~x;
                    led = 3'b000;
                    to_add = 4'b0000;
                end
            3'b011:
                begin
                    out = x & y;
                    led =3'b000;
                    to_add = 4'b0000;
                end
            3'b100:
                begin
                    out = x | y;
                    led = 3'b000;
                    to_add = 4'b0000;
                end
            3'b101:
                begin
                    out = x ^ y;
                    led = 3'b000;
                    to_add = 4'b0000;
                end
            3'b110:
                begin
                    if(((x[2:0] < y[2:0]) && (x[3] == y[3])) || (x[3] > y[3]))
                    begin
                        out = 4'b0001;
                        led = 3'b000;
                        to_add = 4'b0000;
                    end
                    else
                    begin
                        out = 4'b0000;
                        led = 3'b000;
                        to_add = 4'b0000;
                    end
                end
            3'b111:
                begin
                    if(x == y)
                    begin
                        out = 4'b0001;
                        led = 3'b000;
                        to_add = 4'b0000;
                    end
                    else
                    begin
                        out = 4'b0000;
                        led = 3'b000;
                        to_add = 4'b0000;
                    end
                end
        endcase
    end
    seg segl(
        .out(out),
        .seg0(seg0),
        .seg1(seg1)
    );
endmodule




