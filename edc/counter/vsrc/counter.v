module counter (
    input clk,          // 时钟源
    input rst,          // 复位端
    input [1:0] sw,     // sw[0]: 使能端    sw[1]:  清零端
    output reg [6:0]seg0,   // 数码管->十位     
    output reg [6:0]seg1,   // 数码管->个位
    output reg led          // 计时结束标志位
);
   

     reg [6:0] count;
     reg [3:0] x;
     reg [3:0] y;
     reg [24:0] count_clk;
     reg [6:0] temp;
     reg clk_ls, ledl;
    always @ (posedge clk)
    begin
        if(count_clk == 6000000)
        begin
            count_clk <= 0;
            clk_ls <= ~clk_ls; 
        end
        else 
            count_clk <= count_clk + 1;
    end
    always @ (posedge clk_ls)
    begin
        if (rst)
        begin
            x = 4'b1111;
            y = 4'b1111;
            ledl = 1'b0;
        end
        else
        begin
            if (sw[0] == 1'b1 && sw[1] == 1'b0)
            begin
                if(count <= 7'b1100011)
                begin
                    ledl = 1'b0;
                    temp = (count % 10);
                    x = temp[3:0] & 4'b1111;
                    temp = (count / 10);
                    y = temp[3:0] & 4'b1111;
                    count = count + 7'b0000001;
                end
                else
                begin
                    ledl = 1'b1;
                    count = 7'b0000000;
                    x = 4'b0000;
                    y = 4'b0000;
                end
            end
            else if(sw[0] == 1'b0 && sw[1] == 1'b0)
            begin
                count = count;
                x = x;
                y = y;
            end
            else
            begin
                count = 7'b0000000;
                x = 4'b0000;
                y = 4'b0000;
                ledl = 1'b0;
            end
        end
    end
    seg segl(
        .x(x),
        .y(y),
        .ledl(ledl),
        .seg0(seg0),
        .seg1(seg1),
        .led(led)
    );
endmodule




