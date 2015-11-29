module VRAM(clk, addr, WE, data_out, data_in);

input clk, WE;
input [15:0] addr;
input [7:0] data_in;
output logic[7:0] data_out;


logic [10:0] CIRAM_addr;
logic [12:0] CHR_ROM_addr;
logic [7:0] CHR_ROM_out, CIRAM_out;

logic CIRAM_WE;

VRAM_mapper vram_mapper(.*);

CIRAM ciram(.clk(clk), .data_out(CIRAM_out), .addr(CIRAM_addr), .WE(CIRAM_WE), .data_in(data_in));

CHR_ROM CHR_ROM(.clk(clk), .data_out(CHR_ROM_out), .addr(CHR_ROM_addr));


							


endmodule  