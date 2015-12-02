/* Top level of the ppu
 * Contains the VRAM, register interface, the rendering for background and sprites as well as the vga output
 * 
 */
module ppu_toplevel
(
	input clk, reset,
	output logic [7:0]  VGA_R,			//VGA Red
					 VGA_G,					//VGA Green
					 VGA_B,					//VGA Blue
  output logic  VGA_CLK,				//VGA Clock
					 VGA_SYNC_N,			//VGA Sync signal
					 VGA_BLANK_N,			//VGA Blank signal
					 VGA_VS,					//VGA vertical sync signal	
					 VGA_HS					//VGA horizontal sync signal
);


logic [15:0] VRAM_addr;
logic [7:0] VRAM_data_out, VRAM_data_in, palette_out, palette_data_in;
logic VRAM_WE, palette_WE;
logic [7:0] y_idx;
logic [4:0] pixel;
logic render, render_ready, scanline_done;

logic [5:0] FIFO_out, FIFO_in;
logic FIFO_WE, FIFO_RE, FIFO_empty, FIFO_full;

VRAM VRAM(.clk(clk), .addr(VRAM_addr), .WE(VRAM_WE), .data_out(VRAM_data_out), .data_in(VRAM_data_in));

ppu_render render_block(.*,  .VRAM_data_in(VRAM_data_out));

/* FIFO buffer for VGA */
FIFO vga_FIFO(.clk(clk),  .reset(reset), .WE(FIFO_WE), .RE(FIFO_RE), 	.data_in(palette_out[5:0]), 
					.data_out(FIFO_out), .empty(FIFO_empty), .full(FIFO_full));


palette_mem palette_mem(.clk(clk), .reset(reset), .addr(pixel), .data_in(palette_data_in), .WE(palette_WE), .data_out(palette_out));

vga_controller vga_controller( .palette_disp_idx(FIFO_out), .hs(VGA_HS), .vs(VGA_VS), .sync(VGA_SYNC_N),
										.blank(VGA_BLANK_N), .pixel_clk(VGA_CLK), .*);
always_comb
begin: FIFO_logic
	if(reset)
	begin
		FIFO_WE = 0;
	end
	else
	begin
		if(render)
		begin
			FIFO_WE = 1;
		end
		else
		begin
			FIFO_WE = 0;
		end
	end
end


/* State machine for top level controller that controls the current scanline and vblank period */
enum logic [2:0] {IDLE, HBLANK, HBLANK_0, VBLANK, RENDER} state, next_state;	
always_ff@(posedge VGA_CLK, posedge reset)
begin:Scanline_logic
	if(reset)
	begin
		render <= 1;
		y_idx <= 0;
		state <= IDLE;
	end
	else
	begin
		state <= next_state;
		
		
		case(state)
			IDLE:begin
				render <= 0;
			end
			RENDER: begin
				render <= 1;
				if(!render_ready)
					y_idx <= y_idx+1;
			end
			HBLANK_0,
			HBLANK:begin
				render <= 0;
			end
			VBLANK: begin
				render <= 0;
				y_idx <= 0;
			end
		endcase
	end
end

always_comb
begin: next_state_logic
	next_state = state;
	unique case(state)
	IDLE: begin
		if(VGA_VS)
			next_state = RENDER;
	end
	
	RENDER: begin
	if(!VGA_VS)
		next_state = VBLANK;
	if(scanline_done)
		next_state = HBLANK;
	if(y_idx >= 8'd240)
		next_state = VBLANK;
	
	end
	
	HBLANK:begin
		if(!VGA_HS && VGA_VS)
			next_state = HBLANK_0;
		if(!VGA_VS)
			next_state = VBLANK;
	end
	HBLANK_0:begin
		if(VGA_BLANK_N && VGA_VS)
			next_state = RENDER;
		if(!VGA_VS)
			next_state = VBLANK;
	end
	
	VBLANK:begin
		if(VGA_VS)
			next_state = RENDER;
	end
	default: next_state = IDLE;
	endcase

end
endmodule
