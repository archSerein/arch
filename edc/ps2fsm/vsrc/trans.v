module trans(data, ascii);
  input [7:0] data;
  output [7:0] ascii;

  reg [7:0] rom[0:255]; // 256个8位宽的存储单元

  initial
  begin
      // 数字
      rom[8'h45] = 8'h30; // '0'
      rom[8'h16] = 8'h31; // '1'
      rom[8'h1E] = 8'h32; // '2'
      rom[8'h26] = 8'h33; // '3'
      rom[8'h25] = 8'h34; // '4'
      rom[8'h2E] = 8'h35; // '5'
      rom[8'h36] = 8'h36; // '6'
      rom[8'h3D] = 8'h37; // '7'
      rom[8'h3E] = 8'h38; // '8'
      rom[8'h46] = 8'h39; // '9'
      
      // 大写字母
      rom[8'h1C] = 8'h41; // 'A'
      rom[8'h32] = 8'h42; // 'B'
      rom[8'h21] = 8'h43; // 'C'
      rom[8'h23] = 8'h44; // 'D'
      rom[8'h24] = 8'h45; // 'E'
      rom[8'h2B] = 8'h46; // 'F'
      rom[8'h34] = 8'h47; // 'G'
      rom[8'h33] = 8'h48; // 'H'
      rom[8'h43] = 8'h49; // 'I'
      rom[8'h3B] = 8'h4A; // 'J'
      rom[8'h42] = 8'h4B; // 'K'
      rom[8'h4B] = 8'h4C; // 'L'
      rom[8'h3A] = 8'h4D; // 'M'
      rom[8'h31] = 8'h4E; // 'N'
      rom[8'h44] = 8'h4F; // 'O'
      rom[8'h4D] = 8'h50; // 'P'
      rom[8'h15] = 8'h51; // 'Q'
      rom[8'h2D] = 8'h52; // 'R'
      rom[8'h1B] = 8'h53; // 'S'
      rom[8'h2C] = 8'h54; // 'T'
      rom[8'h3C] = 8'h55; // 'U'
      rom[8'h2A] = 8'h56; // 'V'
      rom[8'h1D] = 8'h57; // 'W'
      rom[8'h22] = 8'h58; // 'X'
      rom[8'h35] = 8'h59; // 'Y'
      rom[8'h1A] = 8'h5A; // 'Z'
  end

  assign ascii = rom[data];
endmodule

