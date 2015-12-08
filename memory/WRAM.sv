/* WRAM used by the CPU */

module WRAM(clk, addr, WE, data_out, data_in, vram_data_in, vram_data_out, ppu_reg_cs, ppu_reg_addr, vram_WE, keycode, keypress, keystates);

input clk, WE, keypress;
input [15:0] addr;
input [7:0] data_in, vram_data_in;
output logic[7:0] data_out, vram_data_out;
output logic ppu_reg_cs, vram_WE;
output logic [2:0] ppu_reg_addr;
input [7:0] keycode;
output logic [7:0] keystates;
/* module begin */
logic [10:0] CPU_RAM_addr;
logic [14:0] PRG_ROM_addr;
logic [7:0] PRG_ROM_out, CPU_RAM_out;

logic CPU_RAM_WE;

WRAM_mapper wram_mapper(.*);

CPU_RAM CPU_RAM(.clk(clk), .data_out(CPU_RAM_out), .addr(CPU_RAM_addr), .WE(CPU_RAM_WE), .data_in(data_in));

PRG_ROM PRG_ROM(.clk(clk), .data_out(PRG_ROM_out), .addr(PRG_ROM_addr));


							


endmodule  