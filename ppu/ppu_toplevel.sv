/* Top level of the ppu
 * Contains the VRAM, register interface, the rendering for background
 * and sprites as well as the vga output
 */
module ppu_toplevel
(
	input clk, reset,
	input vram_WE, ppu_reg_cs,
	input [7:0] cpu_data_in,
	output logic [7:0] cpu_data_out,
	input [2:0] ppu_reg_addr,
	output logic [7:0]  VGA_R,			//VGA Red
					 	VGA_G,			//VGA Green
					 	VGA_B,			//VGA Blue
	output logic 	VGA_CLK,		//VGA Clock
					VGA_SYNC_N,	//VGA Sync signal
					VGA_BLANK_N,//VGA Blank signal
					VGA_VS,			//VGA vertical sync signal
					VGA_HS,			//VGA horizontal sync signal
	output logic NMI_enable,
	input oam_dma,
	input [7:0] oam_addr,
	input [7:0] oam_data_in
);


logic [15:0] VRAM_addr, vram_render_addr, ppu_reg_vram_addr;
logic [7:0] vram_data_out, vram_data_in, palette_out, palette_data_in;
logic VRAM_WE, palette_WE;
logic [7:0] y_idx;
logic [4:0] pixel;
logic [4:0] palette_addr, palette_mem_addr;
logic [9:0] hc, vc;
logic show_bg;
logic show_spr;
logic bg_pt_addr;
logic spr_pt_addr;
logic spr0_hit, spr_overflow;
logic vblank;	/* determines whether ppu memory is safe to access from CPU*/


VRAM VRAM
(
	.clk, .addr(VRAM_addr), .WE(VRAM_WE), .data_out(vram_data_out),
	.data_in(vram_data_in)
);


ppu_render ppu_render
(
	.*, .VRAM_addr(vram_render_addr), .x_idx(hc) ,
	.scanline(vc), .VRAM_data_in(vram_data_out)
);


palette_mem palette_mem
(
	.clk, .reset, .addr(palette_mem_addr), .data_in(palette_data_in),
	.WE(palette_WE), .data_out(palette_out)
);

vga_controller vga_controller
(
	.*,
	.palette_disp_idx(palette_out[5:0]), .hs(VGA_HS), .vs(VGA_VS),
	.sync(VGA_SYNC_N), .blank(VGA_BLANK_N), .pixel_clk(VGA_CLK)
);



ppu_reg	ppu_register_interface
(
	.clk, .reset, .WE(vram_WE), .cs_in(ppu_reg_cs), .reg_addr(ppu_reg_addr),
	.cpu_data_in, .cpu_data_out, .VGA_VS, .vram_WE(VRAM_WE),
	.vram_data_out, .vram_data_in, .vram_addr_out(ppu_reg_vram_addr),
	.show_bg(show_bg), .show_spr(show_spr),
	.palette_mem_addr(palette_addr), .palette_WE(palette_WE),
	.palette_data_in(palette_out), .palette_data_out(palette_data_in),
	.NMI_enable , .bg_pt_addr, .spr_pt_addr, .spr0_hit
);


assign vblank = (show_bg) ? (vc > 10'd280) : 1'b1;
assign VRAM_addr = (vblank) ?  ppu_reg_vram_addr : vram_render_addr;
assign palette_mem_addr = (vblank) ? palette_addr : pixel;



endmodule
