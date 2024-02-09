module vga( clk, rst, h_addr, v_addr,
            VGA_HSYNC, VGA_VSYNC, VGA_BLANK_N, 
            vga_r, vga_g, vga_b);

  input clk, rst;
  output [9:0] h_addr;
  output [9:0] v_addr;
  output VGA_HSYNC;
  output VGA_VSYNC;
  output VGA_BLANK_N;
  output [7:0] vga_r;
  output [7:0] vga_g;
  output [7:0] vga_b;


  parameter h_frontporch = 96;
  parameter h_active = 144;
  parameter h_backporch = 784;
  parameter h_total = 800;
  
  parameter v_frontporch = 2;
  parameter v_active = 35;
  parameter v_backporch = 515;
  parameter v_total = 525;
  
  reg [9:0] x_cnt;
  reg [9:0] y_cnt;
  wire h_valid;
  wire v_valid;
  wire [23:0] vga_data;

  vmem vmeml(
    .h_addr(h_addr),
    .v_addr(v_addr[8:0]),
    .vga_data(vga_data)
  );

  always @ (posedge clk)
  begin
    if (rst)
    begin
      x_cnt <= 1;
      y_cnt <= 1;
    end
    else
    begin
      if (x_cnt == h_total)
      begin
          x_cnt <= 1;
        if (y_cnt == v_total)
          y_cnt <= 1;
        else
          y_cnt <= y_cnt + 1;
      end
      else
        x_cnt <= x_cnt + 1;
    end
  end

  // 同步时钟信号
  assign VGA_VSYNC = (y_cnt > v_frontporch);
  assign VGA_HSYNC = (x_cnt > h_frontporch);

  // 消隐信号
  assign h_valid = (x_cnt > h_active) & (x_cnt <= h_backporch);
  assign v_valid = (y_cnt > v_active) & (y_cnt <= v_backporch);
  assign VGA_BLANK_N = h_valid & v_valid;

  //像素坐标 
  assign h_addr = h_valid ? (x_cnt - 10'd145) : {10{1'b0}};
  assign v_addr = v_valid ? (y_cnt - 10'd36) : {10{1'b0}};

  // 颜色值
  assign {vga_r, vga_g, vga_b} = vga_data;

endmodule
