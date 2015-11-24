/* Top level of the ppu
 * Contains the VRAM, register interface, the rendering for background and sprites as well as the vga output
 * 
 */
module ppu_toplevel
(
	input clk, reset
);


logic [15:0] VRAM_addr;
logic [7:0] VRAM_data_out, VRAM_data_in;
logic VRAM_WE;
logic [7:0] y_idx = 0;
logic [3:0] pixel;

VRAM VRAM(.clk(clk), .addr(VRAM_addr), .WE(VRAM_WE), .data_out(VRAM_data_out), .data_in(VRAM_data_in));

ppu_render render_block(.*, .VRAM_data_in(VRAM_data_out));



endmodule
