module encode(
    input  [7:0] sw,
    input en,
    input clk,
    input rst,
    output reg [4:0] led,
    output reg [2:0] y,
    output [6:0] seg0
);
    assign y =  (en == 1'b0) ? 3'b000 :
                (sw == 8'b00000000) ? 3'b000 :
                (sw[7:1] == 7'b0000001) ? 3'b001 :
                (sw[7:2] == 6'b000001) ? 3'b010 :
                (sw[7:3] == 5'b00001) ? 3'b011 :
                (sw[7:4] == 4'b0001) ? 3'b100 :
                (sw[7:5] == 3'b001) ? 3'b101 :
                (sw[7:6] == 2'b01) ? 3'b110 :
                (sw[7] == 1'b1) ? 3'b111 :
                3'b000;
    
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




