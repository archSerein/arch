module fsm(
    input clk,
    input reset,
    input left,
    input right,
    output [5:0] out
);

    parameter init_state = 6'd0;
    parameter state_l_1 = 6'd1;
    parameter state_l_2 = 6'd3;
    parameter state_l_3 = 6'd7;
    parameter state_r_1 = 6'd8;
    parameter state_r_2 = 6'd24;
    parameter state_r_3 = 6'd56;

    reg [5:0] state_holding_reg;
    wire [5:0] next_state_reg;
    reg [23:0] count;


    always @(posedge clk)
    begin
        if(reset)
        begin
            state_holding_reg <= init_state;
            count <= 0;
        end
        else if(count < 24'hffffff)
        begin
            count <= count + 1;
        end
        else
        begin
            state_holding_reg <= next_state_reg;
            count <= 0;
        end
    end

	 wire [5:0] left_or_right;
    assign left_or_right = (left == 1'b1)   ?   state_l_1 :
                                 (right == 1'b1)    ?   state_r_1:
                                 init_state;
    assign next_state_reg = (state_holding_reg == init_state)   ?   left_or_right   :
                            (state_holding_reg == state_l_1)    ?   state_l_2       :
                            (state_holding_reg == state_l_2)    ?   state_l_3       :
                            (state_holding_reg == state_l_3)    ?   init_state      :
                            (state_holding_reg == state_r_1)    ?   state_r_2       :
                            (state_holding_reg == state_r_2)    ?   state_r_3       :
                            init_state;

    reg [5:0] out_r;

    // 将led显示的整个时间段分为三个阶段
    // 使用3个计数器，分别记录每个阶段的间隔时间
    // 通过这三哪个计数器的值判断是否需要点亮
    // 从而达到控制led灯亮度的效果
    always @(posedge clk)
    begin
        if(reset)
            out_r <= init_state;
        else if(state_holding_reg != init_state)
            out_r <= next_state_reg;
        else if(left)
            out_r <= state_l_1;
        else
            out_r <= state_r_1;
    end

    assign out = out_r;
endmodule

