/* Module that contains the logic to render scanlines on the ppu */

module ppu_render
(
	input clk, reset, 
	input [7:0] VRAM_data_in,
	output logic [15:0] VRAM_addr,
	output logic [4:0] pixel,		/* Palette address for the pixel */
	input [9:0] x_idx,
	input [9:0] scanline,
	input bg_pt_addr, spr_pt_addr
);

ppu_bg bg_render(.*);



endmodule
