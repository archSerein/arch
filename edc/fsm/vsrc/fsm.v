module fsm(clk, rst, in, u, v, led);

  input in;
  input clk;
  input rst;
  output u, v;
  output reg [4:0] led;
  reg [24:0] count_clk_c;
  reg clk_c;
  
  reg [2:0] initial_state;
  reg [2:0] current_state, next_state;
  
  initial
  begin
    initial_state = 3'b000;
    count_clk_c = 0;
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
  end
  always @ (posedge clk_c or posedge rst)
  begin
    if (rst)
    begin
      current_state <= initial_state;
      led <= {1'b0, 1'b1, current_state};
      $display("u-v-state: %b-%b %b", u, v, next_state);
    end
    else
    begin
      current_state <= next_state;
      led <= {u, v, current_state};
      $display("u-v-state: %b-%b %b", u, v, next_state);
    end
  end

  assign next_state[2] = ((~current_state[2]) & current_state[1] & (~current_state[0]) & in) | ((~current_state[2]) & current_state[1] &
                          current_state[0]) | (current_state[2] & (~current_state[1]) & (~(current_state[0] ^ in)));
  assign next_state[1] = ((~current_state[2]) & (~current_state[1]) & current_state[0]) | ((~current_state[2]) & current_state[1] &
                          (~current_state[0]) & (~in)) | (current_state[2] & (~current_state[1]) & (~current_state[0]) & in);
  assign next_state[0] = ((current_state[2] ^ current_state[1]) & ~(current_state[0] ^ in)) | ((~current_state[2]) & 
                          (~current_state[1]) & (current_state[0] ^ in));

  assign u = (current_state[2] & (~current_state[1]) & (~current_state[0])) | (((~current_state[2]) | (~current_state[1])) & current_state[0] & in);
  assign v = (current_state[2] & (~current_state[1]) & (current_state[0] ^ in)) | ((~current_state[2]) & (~current_state[1]) & 
              (~(current_state[0] ^ in)));

endmodule
