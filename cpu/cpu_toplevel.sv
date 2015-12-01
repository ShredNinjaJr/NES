
/* Top level module of the cpu connects the WRAM to the CPU*/

module cpu_toplevel
(
	input clk, reset,
	input nmi,	/* Non maskable interrupt from the PPU during VBLank. Active Low*/
	input rdy,		/* signal from system/PPu to suspend the cpu clock. Active low */
	output logic [2:0] ppu_reg_addr,
	output logic [7:0] vram_data_out,
	output logic vram_WE,
	input [7:0] vram_data_in,
	output logic ppu_reg_cs			/* Chip select for ppu registers. Active low */
);

logic [7:0] wram_data_in, wram_data_out;
logic [15:0] wram_addr;
logic wram_WE;

cpu6502 cpu(.clk(clk), .reset(reset), .addr(wram_addr), .data_out(wram_data_in), .data_in(wram_data_out), .irq(1'b1));

WRAM WRAM(.*, .addr(wram_addr), .WE(wram_WE), .data_out(wram_data_in), .data_in(wram_data_out));

endmodule
