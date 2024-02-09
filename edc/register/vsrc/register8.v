module register8 (clk, wr, data, addr, out, led);
    input clk;
    input wr;
    input [7:0] data;
    input [3:0] addr;
    output reg [7:0] out;
    output reg [7:0] led;
    
    reg [7:0] ram [15:0];
    initial
    begin
        $readmemh("/home/serein/ysyx/yosys-sta/edc/register/mem.txt", ram, 0, 15);
    end

    always @ (posedge clk)
    begin
        if (wr == 1'b1)
        begin
            ram[addr] <= data;
        end
        else
        begin
            // wr 为0, 标志着进行读取的操作
        end
    end


    assign out =  (wr == 1'b0) ? ram[addr] :
                  8'b00000000;

    assign led = out;

endmodule
