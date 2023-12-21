module encode(
    input  [7:0] sw,
    input en,
    input clk,
    input rst,
    output reg [4:0] led,
    output reg [2:0] y,
    output [6:0] seg0
);
    integer i;
    always @(*)
    begin
        if(en == 1'b1)
        begin
            casez (sw)
                8'b00000000: y = 3'b000;
                8'b0000001?: y = 3'b001;
                8'b000001??: y = 3'b010;
                8'b00001???: y = 3'b011;
                8'b0001????: y = 3'b100;
                8'b001?????: y = 3'b101;
                8'b01??????: y = 3'b110;
                8'b1???????: y = 3'b111;
                default: y = 3'b000;
            endcase
        end 
        else y = 3'b000;
    end 
    always @ (posedge clk)
    begin
        if(rst)
            led <= 5'b00000;
        else
        begin
            if(sw == 8'b00000000)
                led[3:3] <= 1'b0;
            else led[3:3] <= 1'b1;
            led[2:0] <= y;
            led[4:4] <= en;
        end 
    end 
    seg seg1(
        .clk(clk),
        .rst(rst),
        .y(y),
        .seg0(seg0)
    );
endmodule




