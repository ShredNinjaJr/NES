/* Module that contains the logic to render scanlines on the ppu */

module ppu_render
(
	input clk, reset, 
	input [7:0] VRAM_data_in,
	output logic [15:0] VRAM_addr,
	output logic [4:0] pixel,		/* Palette address for the pixel */
	input [9:0] x_idx,
	input [9:0] scanline,
	input bg_pt_addr, spr_pt_addr,
	output logic spr0_hit, spr_overflow
);

logic [3:0] bg_pixel, spr_pixel;
logic [15:0] bg_VRAM_addr, spr_VRAM_addr; 
ppu_bg bg_render(.*, .pixel(bg_pixel), .VRAM_addr(bg_VRAM_addr));

ppu_spr spr_render(.*, .VRAM_addr(spr_VRAM_addr), .pixel(spr_pixel) );

assign VRAM_addr = (x_idx > 10'd255 && x_idx < 10'd320) ? (spr_VRAM_addr) : bg_VRAM_addr;
assign pixel[4] = 1'b0;

endmodule
