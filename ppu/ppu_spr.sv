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
logic [3:0] s_oam_idx;
logic [5:0] n;		/* counter for the sprite number */
logic [1:0] m;		/* byte number */
logic [9:0] y_idx;
assign y_idx = (scanline - 10'd1);
assign p_oam_addr = {n,m};

logic [2:0] sprite_y; /* Row number inside the sprite */
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
		p_oam_data_in <= 0;
		s_oam_addr <= 0;
		s_oam_data_in <= 0;
		spr0_hit <= 0;
		n <= 0;
		m <= 0;
		s_oam_idx <= 0;
	end
	else
	begin
		s_oam_WE <= 0;
		/* Clear spr0_hit at prerender scanline */
		if(scanline == 10'd0 && x_idx == 10'd0)
			spr0_hit <= 0;
		
		/* for the first 64 cycles, initialize the secondary OAM to $FF */
		if(x_idx < 10'd64)
		begin
			s_oam_addr <= x_idx[5:1];
			s_oam_data_in <= 8'hff;
			s_oam_WE <= 1;
			
			if(x_idx == 10'd63)
			begin
				n <= 0;
				m <= 0;
			end
		end
		/* Cycles 64-256: Sprite evaluation */
		else if(x_idx >= 10'd64 && x_idx <= 10'd256)
		begin: Sprite_evaluation
			if(x_idx[0])	/* on odd cycles write to secondary OAM */
			begin: odd_cycle

					s_oam_addr <= {s_oam_idx[2:0], m};
					s_oam_data_in <= p_oam_data_out;
					s_oam_WE <= 1;
					
					if( m != 2'd0)	/* Copy the remaining OAM bytes if in range */
						m <= m + 1;
						if( m == 2'd3)
							n <= n+1;
					else
					begin
						/* If y coordinate is within 8 scanlines, copy the rest */
						if((y_idx >= p_oam_data_out) && (y_idx < (10'd8 + p_oam_data_out)))
						begin
							m <= m + 1;
						end
						else
						begin
							n <= n+ 1;
							m <= 0;
						end
					end
			
					/* If m is not 0, the sprite is in range, copy the remaining bytes */
					
				end:odd_cycle
				else/* on even cycle, wait for primary OAM read */
				begin: even_cycle
					;
				end:even_cycle
			
		end: Sprite_evaluation
	end
end

endmodule
