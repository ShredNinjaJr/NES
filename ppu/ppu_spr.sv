module ppu_spr
(
	input clk, reset,
	input spr_pt_addr,
	input [7:0] VRAM_data_in,
	output logic [15:0] VRAM_addr,
	output logic [3:0] pixel,
	input [9:0] x_idx,
	input [9:0] scanline,
	output logic spr0_hit
);

logic p_oam_WE, s_oam_WE;
logic [7:0] p_oam_data_in, p_oam_data_out, s_oam_data_in, s_oam_data_out;
logic [7:0] p_oam_addr;
logic [4:0] s_oam_addr;

logic [9:0] y_idx;
assign y_idx = (scanline - 10'd1);
/* Primary OAM*/
RAM #(.width(8), .n(8)) p_oam (.*, .WE(p_oam_WE), .data_in(p_oam_data_in),
					.data_out(p_oam_data_out), .addr(p_oam_addr));
					
/* Secondary OAM */
RAM #(.width(8), .n(5)) s_oam (.*, .WE(s_oam_WE), .data_in(s_oam_data_in),
					.data_out(s_oam_data_out), .addr(s_oam_addr));

always_ff @ (posedge clk, posedge reset)
begin
	if(reset)
	begin
		VRAM_addr <= 0;
		p_oam_addr <= 0;
		p_oam_data_in <= 0;
		s_oam_addr <= 0;
		s_oam_data_in <= 0;
		spr0_hit <= 0;
	end
	else
	begin
		s_oam_WE <= 0;
		/* Clear spr0_hit at prerender scanline */
		if(scanline == 10'd0)
			spr0_hit <= 0;
		
		/* for the first 64 cycles, initialize the secondary OAM to $FF */
		if(x_idx < 10'd64)
		begin
			s_oam_addr <= x_idx[5:1];
			s_oam_data_in <= 8'hff;
			s_oam_WE <= 1;
		end
		/* Cycles 64-256: Sprite evaluation */
		else if(x_idx >= 10'd64 && x_idx <= 10'd256)
		begin
			 ;
		end
	end
end

endmodule
