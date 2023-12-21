module clockl(
    input clk,
    input rst,
    input BTNL,
    input [2:0] sw,
    output [6:0] seg0,
    output [6:0] seg1,
    output [6:0] seg2,
    output [6:0] seg3,
    output [6:0] seg4,
    output [6:0] seg5,
    output [15:0] led
);

    reg clk_c, clk_m;
    reg [24:0] count_clk_c;
    reg [17:0] count_clk_m;
    reg [6:0] hour, min, sec, temp;
    reg [3:0] x, y, a, b, c, d;
    reg [23:0] alarm;
    reg [15:0] ledl;

    initial         // 初始化变量
    begin
        x = 0; y = 0; a = 0; b = 0; c = 0; d = 0;
        hour = 0; min = 0; sec = 0; count_clk_m = 0; count_clk_c = 0;
        alarm = 0;
    end

    always @ (posedge clk)
    begin
        if (count_clk_c == 25000000)
        begin
            count_clk_c <= 0;
            clk_c <= ~clk_c;
        end
        else
        begin
            count_clk_c <= count_clk_c + 1;
        end
        if (count_clk_m == 250000)
        begin
            count_clk_m <= 0;
            clk_m <= ~clk_m;
        end
        else
        begin
            count_clk_m <= count_clk_m + 1;
        end
    end
    
    // 秒表 
    always @ (posedge clk_m)
    begin
        if (sw == 3'b001)
        begin
            if (sec <= 7'b1100011)
            begin
                sec = sec + 1;
                temp = sec % 10;
                x = temp[3:0];
                temp = sec / 10;
                y = temp[3:0];
            end
            else if (min <= 7'b0111011)
            begin
                sec = 0; x = 0; y = 0;
                min = min + 1;
                temp = min % 10;
                a = temp[3:0];
                temp = min / 10;
                b = temp[3:0];
            end
            else if(hour < 7'b1100010)
            begin
                sec = 0; min = 0;
                x = 0; y = 0; a = 0; b = 0;
                temp = hour % 10;
                c = temp[3:0];
                temp = hour / 10;
                d = temp[3:0];
            end
            else
            begin
                min = 0; sec = 0; hour = 0;
                a = 0; b = 0; c = 0; d = 0; x = 0; y = 0;
            end
        end
        else if (sw == 3'b111)
        begin
            min = 0; sec = 0; hour = 0;
            a = 0; b = 0; c = 0; d = 0; x = 0; y = 0;
        end
        else
        begin
            // 计时功能暂停，状态不发生改变 
        end
    end

    // 时钟
    always @ (clk_c)
    begin
        if (sw == 3'b000)
        begin
            if (sec < 7'b0111011)
            begin
                sec = sec + 1;
                temp = sec % 10;
                x = temp[3:0];
                temp = sec / 10;
                y = temp[3:0];
                if (d == alarm[23:20] && c == alarm[19:16] && b == alarm[15:12] && a == alarm[11:8] && y == alarm[7:4] && x == alarm[3:0])
                    ledl = 16'b1111111111111111;
                else
                    ledl = 16'b0000000000000000;
            end
            else if (min <= 7'b0111011)
            begin
                sec = 0; x = 0; y = 0;
                min = min + 1;
                temp = min % 10;
                a = temp[3:0];
                temp = min / 10;
                b = temp[3:0];
            end
            else if(hour < 7'b0010111)
            begin
                sec = 0; min = 0;
                x = 0; y = 0; a = 0; b = 0;
                temp = hour % 10;
                c = temp[3:0];
                temp = hour / 10;
                d = temp[3:0];
            end
            else
            begin
                min = 0; sec = 0; hour = 0;
                a = 0; b = 0; c = 0; d = 0; x = 0; y = 0;
            end
        end
        else if (sw == 3'b010)
        begin
            if (BTNL == 1'b1)
            begin
                if (sec < 7'b0111011)
                begin
                    sec = sec + 1;
                    temp = sec % 10;
                    x = temp[3:0];
                    temp = sec / 10;
                    y = temp[3:0];
                end
                else
                begin
                    sec = 0; x = 0; y = 0; 
                end
            end
            else
            begin
                // 未检测到BTNL按下，sec状态不改变
            end
        end
        else if (sw == 3'b100)
        begin
            if (BTNL == 1'b1)
            begin
                if (min <= 7'b0111011)
                begin
                    min = min + 1;
                    temp = min % 10;
                    a = temp[3:0];
                    temp = min / 10;
                    b = temp[3:0];
                end
                else
                begin
                    min = 0; a = 0; b = 0;
                end
            end
            else
            begin
                // 未检测到BTNL按下，min状态不改变
            end
        end
        else
        begin
            if(BTNL == 1'b1)
            begin
                if(hour < 7'b0010111)
                begin
                    hour = hour + 1;
                    temp = hour % 10;
                    c = temp[3:0];
                    temp = hour / 10;
                    d = temp[3:0];
                end
                else
                begin
                    hour = 0; c = 0; d = 0;
                end
            end
            else
            begin
                // 未检测到BTNL按下，hour状态不改变
            end
        end
    end

    seg segl(
        .x(x),
        .y(y),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4),
        .seg5(seg5),
        .led(led),
        .ledl(ledl)
    );
endmodule
