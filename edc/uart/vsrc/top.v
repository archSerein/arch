module top(
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    input uart_rx,
    output uart_tx,
    output VGA_CLK,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_BLANK_N,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B
);


assign VGA_CLK = clk;

wire [9:0] h_addr;
wire [9:0] v_addr;
wire [23:0] vga_data;

vga my_vga_ctrl(
    .pclk(clk),
    .reset(rst),
    .vga_data(vga_data),
    .h_addr(h_addr),
    .v_addr(v_addr),
    .hsync(VGA_HSYNC),
    .vsync(VGA_VSYNC),
    .valid(VGA_BLANK_N),
    .vga_r(VGA_R),
    .vga_g(VGA_G),
    .vga_b(VGA_B)
);

ps2_keyboard my_keyboard(
    .clk(clk),
    .resetn(~rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data)
);


vmem my_vmem(
    .h_addr(h_addr),
    .v_addr(v_addr[8:0]),
    .vga_data(vga_data)
);

uart my_uart(
  .tx(uart_tx),
  .rx(uart_rx)
);

endmodule

module vmem(
    input [9:0] h_addr,
    input [8:0] v_addr,
    output [23:0] vga_data
);

reg [23:0] vga_mem [524287:0];

initial begin
    $readmemh("/home/serein/ysyx/arch/edc/uart/resource/picture.hex", vga_mem);
end

assign vga_data = vga_mem[{h_addr, v_addr}];

endmodule
