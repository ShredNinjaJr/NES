
/* Top level module of the cpu connects the WRAM to the CPU*/

module cpu_toplevel
(
	input clk, reset, nres_in,
	input nmi,	/* Non maskable interrupt from the PPU during VBLank. Active Low*/
	input rdy,		/* signal from system/PPu to suspend the cpu clock. Active low */
	output logic [2:0] ppu_reg_addr,
	output logic [7:0] vram_data_out,
	output logic vram_WE,
	input [7:0] vram_data_in,
	output logic ppu_reg_cs,			/* Chip select for ppu registers. Active low */ 
	output reg [7:0]		acc, instr,
   output logic [15:0]    pc,
	output logic oam_dma,			/* Is high during oam_dma */
	output logic [7:0]oam_addr

);

logic [7:0] wram_data_in, wram_data_out;
logic [15:0] wram_addr;
logic wram_WE;


cpu cpu(
  .clk_in(clk),         // 100MHz system clock
  .rst_in(reset),         // reset signal
  .ready_in(rdy),       // ready signal

  // Interrupt lines.
  .nnmi_in(nmi),        // /nmi interrupt signal (active low)
  .nres_in(nres_in),        // /res interrupt signal (console reset, active low)
	.nirq_in(1'b1),        // /irq intterupt signal (active low)

  // Memory bus.
  .d_in(wram_data_in),           // data input bus
  .d_out(wram_data_out),          // data output bus
  .a_out(wram_addr),          // address bus
  .r_nw_out(wram_WE),   // R/!W signal
  .PC(pc)
 );

WRAM WRAM(.*, .addr(wram_addr), .WE(~wram_WE), .data_out(wram_data_in), .data_in(wram_data_out));

endmodule
