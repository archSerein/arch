module selector(
    input clk,
    input rst,
    input [9:0] sw,
    output reg [1:0] led
);
    
    reg [1:0] X0,X1,X2,X3,Y,F;
    assign Y = sw[1:0];
    assign X0 = sw[3:2];
    assign X1 = sw[5:4];
    assign X2 = sw[7:6];
    assign X3 = sw[9:8];
    always @ (X0, X1, X2, X3, F, Y)
        begin
            case(Y)
                2'b00: F = X0;
                2'b01: F = X1;
                2'b10: F = X2;
                2'b11: F = X3;
                default: F = 2'b00;
            endcase
        end
    always @ (posedge clk)
        begin 
            if(rst) begin
                led <= 0;
            end 
            else begin 
                led <= F;
            end 
        end 

endmodule
        

