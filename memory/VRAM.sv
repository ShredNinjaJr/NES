module VRAM(clk, addr, WE, data_out, data_in);

input clk, WE;
input [15:0] addr;
input [7:0] data_in;
output logic[7:0] data_out;


logic [10:0] CIRAM_addr;
logic [15:0] ROM_addr;
logic [7:0] ROM_out, CIRAM_out, palette_out;

logic CIRAM_WE, palette_WE;

VRAM_mapper vram_mapper(.*);

CIRAM ciram(.clk(clk), .data_out(CIRAM_out), .addr(CIRAM_addr), .WE(CIRAM_WE), .data_in(data_in));

cart ROM(.clk(clk), .data_out(ROM_out), .addr(ROM_addr));

palette_mem palette_mem(.clk(clk), .addr(addr[4:0]), .data_in(data_in), .WE(palette_WE), .data_out(palette_out));
							


endmodule  