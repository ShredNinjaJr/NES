/* Register interface for the PPU */
/* Responsible between communication between CPU and PPU*/
/* NOTES: */
module ppu_reg
(
	input reset,
	input clk, WE,
	input cs_in,	/* Chip select for the register interface, Active low*/
	input [7:0] cpu_data_in,		/* Databus of  CPU read*/
	output logic [7:0]cpu_data_out,	/* CPU databus write*/
	input [2:0] reg_addr,		/* Addr of register being chosen*/
	input logic [7:0] vram_data_out,	/* Data in to  the ppu if writing to VRAM */
	output logic [7:0] vram_data_in,	/* Data out from the ppu if reading from VRAM */
	output logic [15:0] vram_addr_out,	/* Vram addr_out to write/read data to VRAM */	
	output logic [7:0] oam_data_out,		/* OAM data if writing to OAM (0x2004 writes)*/
	output logic [7:0] oam_data_in,		/* OAM data if reading from OAM (0x2004 reads)*/
	output logic [7:0] oam_addr_out,		/* OAM addr to read/write to*/
	output logic oam_WE, vram_WE,
	output logic [4:0]palette_mem_addr,
	output logic palette_WE,
	output logic [7:0] palette_data_out,
	input [7:0] palette_data_in,
	
	/* register bit outputs */
	
	/*		PPUCTRL (0x2000) write only
	 7  bit  0
	---- ----
	VPHB SINN
	|||| ||||
	|||| ||++- Base nametable address
	|||| ||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
	|||| |+--- VRAM address increment per CPU read/write of PPUDATA
	|||| |     (0: add 1, going across; 1: add 32, going down)
	|||| +---- Sprite pattern table address for 8x8 sprites
	||||       (0: $0000; 1: $1000; ignored in 8x16 mode)
	|||+------ Background pattern table address (0: $0000; 1: $1000)
	||+------- Sprite size (0: 8x8; 1: 8x16)
	|+-------- PPU master/slave select
	|          (0: read backdrop from EXT pins; 1: output color on EXT pins)
	+--------- Generate an NMI at the start of the
			  vertical blanking interval (0: off; 1: on)
	*/
	output logic NMI_enable,		/* bit 7 */
	output logic sprite_size,		/* bit 5 */
	output logic bg_pt_addr,		/* bit 4 */
	output logic spr_pt_addr,		/* bit 3*/
	output logic vram_addr_inc,		/* bit 2*/
	output logic [1:0] base_nt_addr,	/* bits 1, 0*/
	
	/*  PPUMASK ( 0x2001) write_only
			7  bit  0
		---- ----
		BGRs bMmG
		|||| ||||
		|||| |||+- Grayscale (0: normal color, 1: produce a greyscale display)
		|||| ||+-- 1: Show background in leftmost 8 pixels of screen, 0: Hide
		|||| |+--- 1: Show sprites in leftmost 8 pixels of screen, 0: Hide
		|||| +---- 1: Show background
		|||+------ 1: Show sprites
		||+------- Emphasize red*
		|+-------- Emphasize green*
		+--------- Emphasize blue*
	*/
	output logic [2:0] color_emph_bgr, /* bits 7, 6, 5*/
	output logic show_spr,	/* Bit 4*/
	output logic show_bg,	/* bit 3*/
	output logic show_spr_left, /* bit 2*/
	output logic show_bg_left, /* bit 1*/
	output logic grayscale, /* bit 0*/
	
	/* PPU_STATUS (0x2002) read only
	
	7  bit  0
	---- ----
	VSO. ....
	|||| ||||
	|||+-++++- Least significant bits previously written into a PPU register
	|||        (due to register not being updated for this address)
	||+------- Sprite overflow. The intent was for this flag to be set
	||         whenever more than eight sprites appear on a scanline, but a
	||         hardware bug causes the actual behavior to be more complicated
	||         and generate false positives as well as false negatives; see
	||         PPU sprite evaluation. This flag is set during sprite
	||         evaluation and cleared at dot 1 (the second dot) of the
	||         pre-render line.
	|+-------- Sprite 0 Hit.  Set when a nonzero pixel of sprite 0 overlaps
	|          a nonzero background pixel; cleared at dot 1 of the pre-render
	|          line.  Used for raster timing.
	+--------- Vertical blank has started (0: not in vblank; 1: in vblank).
				  Set at dot 1 of line 241 (the line *after* the post-render
				  line); cleared after reading $2002 and at dot 1 of the
				  pre-render line.
	 */
	 
	input spr_overflow,	/* bit 5*/
	input spr0_hit,		/* bit 6*/
	input VGA_VS	/* bit 7*/
);

logic[7:0] dummy;	/* dummy register*/
/* register numbers in the mem array */
parameter PPUCTRL = 3'd0;
parameter PPUMASK = 3'd1;
parameter PPUSTATUS = 3'd2;
parameter OAMADDR = 3'd3;
parameter OAMDATA = 3'd4;
parameter PPUSCROLL = 3'd5;
parameter PPUADDR = 3'd6;
parameter PPUDATA = 3'd7;

logic vram_inc;
logic vblank_start, vblank_clear;
logic [4:0] lsb_last_write;	/* lsb of last byte written to a register */
logic vblank_start_reg;
logic cs_in_reg;
logic ppu_addr_counter;		/* Counter that signifies which byte(lower or upper)
										of the PPU address is being written to. 
										0 is upper, 1 is lower */
always_ff @( negedge VGA_VS, posedge vblank_clear)
begin
	if(vblank_clear)
		vblank_start <= 0;
	else
		vblank_start <= 1;
end

assign palette_mem_addr = vram_addr_out[4:0];

always_ff @(posedge clk, posedge reset)
begin
	if(reset)
	begin
		cpu_data_out <= 0;
		vblank_start_reg <= 0;
		oam_data_out <= 0;
		vram_WE <= 0;
		ppu_addr_counter <= 0;
		show_bg <= 0;
		palette_data_out <= 0;
		palette_WE <= 0;
	end
	else
	begin
		cs_in_reg <= cs_in;
		vblank_start_reg <= vblank_start;
		vblank_clear <= 0;
		vram_WE <= 0;
		palette_WE <= 0;
		oam_WE <= 0;
		if(~cs_in & cs_in_reg)
		begin:Chipselect
			if(vram_inc)
					begin
						vram_addr_out <= vram_addr_out + ((vram_addr_inc) ? 16'd32: 16'd1);
						vram_inc <= 0;
					end
			case(reg_addr)
				
				PPUCTRL:begin
						if(WE)
							{NMI_enable, dummy[0], sprite_size, bg_pt_addr, spr_pt_addr, vram_addr_inc, base_nt_addr} <= cpu_data_in;
					end
				
				PPUMASK:begin
					if(WE)
						{color_emph_bgr, show_spr, show_bg, show_spr_left, show_bg_left, grayscale} <= cpu_data_in;
				end
				
				PPUSTATUS:begin
					cpu_data_out <= {vblank_start_reg, spr0_hit, spr_overflow, lsb_last_write};
					/* Clear the vblank upon read */
					if(vblank_start_reg == 1'b1)
						vblank_clear <= 1;
				end
				OAMADDR:begin
					oam_addr_out <= cpu_data_in;
				end
				OAMDATA:begin
					if(WE)
					begin
						oam_data_out <= cpu_data_in;
						oam_WE <= WE;
						oam_addr_out <= oam_addr_out + 8'b1;
					end
					else
						cpu_data_out <= oam_data_in;
				end
				
				PPUADDR: begin
					if(ppu_addr_counter)
					begin
						vram_addr_out[7:0] <= cpu_data_in;
					end
					else
					begin
						vram_addr_out[15:8] <= cpu_data_in;
					end
					
					ppu_addr_counter <= ~ppu_addr_counter;
				end
				
				PPUDATA:begin
					if(vram_addr_out[13:8] == 6'h3F)
					begin

						palette_WE <= WE;
						palette_data_out <= cpu_data_in;
						cpu_data_out <= palette_data_in;
					end
					
					else
					begin
						vram_WE <= WE;
						if(WE)
						begin
							vram_data_in <= cpu_data_in;
							
						end
						else
						begin
							cpu_data_out <= vram_data_out;
						end
					end
					vram_inc <= 1;					
				end
				
			endcase
		end: Chipselect
	end
end




endmodule
