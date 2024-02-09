module ps2keyboard( clk, clrn, ps2_data, ready,overflow, ps2_clk,
                    seg0, seg1, seg2, seg3, seg4, seg5, led);

  input clk, clrn, ps2_clk, ps2_data;
  output reg ready;
  output reg overflow;    // fifo overflow
  output [6:0] seg0, seg1, seg2, seg3, seg4, seg5;
  output reg [7:0] led;

  reg [7:0] times[0:255];
  reg [9:0] buffer;
  reg [7:0] fifo[7:0];
  reg [2:0] w_ptr, r_ptr;
  reg [3:0] count;
  reg nextdata_n;
  
  reg [2:0] ps2_clk_sync;
  
  wire [7:0] counts;
  wire [7:0] data;
  wire [7:0] ascii;

  genvar i;
  generate
      for (i = 0; i < 256; i = i + 1) begin : init_loop
          initial begin
              times[i] = 0;
          end
      end
  endgenerate

  trans transl(
    .data(data),
    .ascii(ascii)
  );

  seg segl(
      .data(data),
      .ascii(ascii),
      .counts(counts),
      .seg0(seg0),
      .seg1(seg1),
      .seg2(seg2),
      .seg3(seg3),
      .seg4(seg4),
      .seg5(seg5)
    );

  always @ (posedge clk)
  begin
      ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
  end

  wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

  always @ (posedge clk)
  begin
    if(clrn == 0)
    begin
      count <= 0;
      w_ptr <= 0;
      r_ptr <= 0;
      overflow <= 0;
      ready <= 0;
    end
    else
    begin
      if(ready)
      begin
        if(nextdata_n == 1'b0)
        begin
          r_ptr <= r_ptr + 3'b1;
          if(w_ptr == (r_ptr + 1'b1))
          begin
            nextdata_n <= 1'b1;
            ready <= 1'b0;
          end
        end
      end

      if(sampling)
      begin
        if(count == 4'b1010)
        begin
          if((buffer[0] == 0) && 
              (ps2_data)      &&
              (^buffer[9:1]))
          begin
            fifo[w_ptr] <= buffer[8:1];
            if(fifo[w_ptr - 1] == 8'hf0)
              times[buffer[8:1]] <= times[buffer[8:1]] + 1;
            w_ptr <= w_ptr + 3'b001;
            ready <= 1'b1;
            nextdata_n <= 1'b0;
            overflow <= overflow | (r_ptr == (w_ptr + 3'b001));
          end
          count <= 0;
        end
        else
          begin
            buffer[count] <= ps2_data;
            count <= count + 3'b001;
          end
        end
      end
    end

    assign data = fifo[r_ptr];    // always set output data
    assign counts = data == 8'b11110000 ? 0 : times[data];
    assign led = fifo[w_ptr] == 8'b11110000 ? 8'b11110000 : 8'b00001111;

endmodule
