module ppu_spr
(
	input clk, reset,
	input spr_pt_addr,
	input [7:0] VRAM_data_in,
	output logic [15:0] VRAM_addr,
	output logic [3:0] pixel,
	input [9:0] x_idx,
	input [9:0] scanline,
	input [7:0] oam_addr,
	input [7:0] oam_data_in,
	input oam_dma,
	output logic spr0_hit, spr_overflow, spr_priority
);

logic p_oam_WE, s_oam_WE;
logic [7:0] p_oam_data_in, p_oam_data_out, s_oam_data_in, s_oam_data_out;
logic [7:0] p_oam_addr;
logic [4:0] s_oam_addr;
logic [2:0] s_oam_idx;
logic [5:0] n;		/* counter for the sprite number */
logic [1:0] m;		/* byte number */
logic [9:0] y_idx;
assign y_idx = (scanline);
assign p_oam_addr = (oam_dma) ? oam_addr :{n,m};
/* Checks if sprite is in range */
logic spr_in_range;
assign spr_in_range = (y_idx >= p_oam_data_out) && (y_idx < (10'd8 + p_oam_data_out));
logic [2:0] sprite_y; /* Row number inside the sprite */

logic spr0_found;	/* Flag that asserts that spr0 is on this scanline */

logic [7:0] spr_tile_num;
/* Shift registers, counters and latches for the 8 sprites on the scanline */
logic [7:0] spr_bmp_low[7:0];		/* Bitmap of lower bytes */
logic [7:0] spr_bmp_high[7:0];	/* Bitmap of higher bytes */
logic [7:0] spr_attr[7:0];			/* attributes of sprite */
logic [7:0] spr_x_pos[7:0];		/* X position of sprites */
logic spr_bmp_shift[7:0];			/* If x position is 0, shift sprites */

/* states for sprites evaluation */
enum logic [2:0] {IDLE, READ_Y, COPY_SPR, INC_N, SPR_OVERFLOW}state, next_state;
logic [7:0] pr_oam_addr;


assign p_oam_data_in = oam_data_in;
assign pr_oam_addr = (oam_dma) ? (oam_addr) : (p_oam_addr);
assign p_oam_WE = oam_dma;
/* Primary OAM*/
RAM #(.w(8), .n(8)) p_oam (.*, .WE(p_oam_WE), .data_in(p_oam_data_in),
					.data_out(p_oam_data_out), .addr(pr_oam_addr));
					
/* Secondary OAM */
RAM #(.w(8), .n(5)) s_oam (.*, .WE(s_oam_WE), .data_in(s_oam_data_in),
					.data_out(s_oam_data_out), .addr(s_oam_addr));

			
always_ff @ (posedge clk, posedge reset)
begin
	if(reset)
	begin
		VRAM_addr <= 0;
		s_oam_addr <= 0;
		s_oam_data_in <= 0;
		spr0_hit <= 0;
		n <= 0;
		m <= 0;
		s_oam_idx <= 0;
		spr0_found <= 0;
		spr_tile_num <= 0;
		state <= IDLE;
	end
	else
	begin
		s_oam_WE <= 0;
		state <= next_state;
		/* Clear spr0_hit at prerender scanline */
		if(scanline == 10'd0 && x_idx == 10'd0)
		begin
			spr_overflow <= 0;
			spr0_found <= 0;
		end
		
		/* for the first 64 cycles, initialize the secondary OAM to $FF */
		if(x_idx < 10'd64)
		begin
			s_oam_addr <= x_idx[5:1];
			s_oam_data_in <= 8'hff;
			s_oam_WE <= 1;
			s_oam_idx <= 0;
			
			/* Reset parameters for the next stage */
			if(x_idx == 10'd63)
			begin
				n <= 0;
				m <= 0;
			end
			
			/* Every cycle decrement the xposition of all 8 sprite_x_pos */
			for(logic[3:0] i = 0; i < 4'd8; i = i+ 4'd1)
			begin
				if(spr_x_pos[i] != 8'd0)
					spr_x_pos[i] <= spr_x_pos[i] - 8'd1;
				else	/* If it is zero begin shifting the bitmaps */
					spr_bmp_shift[i] <= 1'b1;
			end
			
			/* Shift the bmps if high */
			for(logic[3:0] i = 0; i < 4'd8; i = i+ 4'd1)
			begin
				if(spr_bmp_shift[i])
				begin
					spr_bmp_low[i] <= {spr_bmp_low[i][6:0], 1'b0};
					spr_bmp_high[i] <= {spr_bmp_high[i][6:0], 1'b0};
				end
			end
		end
		/* Cycles 64-256: Sprite evaluation */
		else if(x_idx >= 10'd64 && x_idx < 10'd256)
		begin: Sprite_evaluation
		
		
			/* Every cycle decrement the xposition of all 8 sprite_x_pos */
			for(logic[3:0] i = 0; i < 4'd8; i = i+ 4'd1)
			begin
				if(spr_x_pos[i] != 8'd0)
					spr_x_pos[i] <= spr_x_pos[i] - 8'd1;
				else	/* If it is zero begin shifting the bitmaps */
					spr_bmp_shift[i] <= 1'b1;
			end
			
			/* Shift the bmps if high */
			for(logic[3:0] i = 0; i < 4'd8; i = i+ 4'd1)
			begin
				if(spr_bmp_shift[i])
				begin
					spr_bmp_low[i] <= {spr_bmp_low[i][6:0], 1'b0};
					spr_bmp_high[i] <= {spr_bmp_high[i][6:0], 1'b0};
				end
			end
			
			
			
			if(x_idx == 10'd255)
			begin
					s_oam_idx <= 0;
					m <= 0;
					for(logic[3:0] i = 0; i < 4'd8; i = i+ 4'd1)
						spr_bmp_shift[i] <= 1'b0;
					spr0_hit <= 0;
			end
			
			if(x_idx[0])	/* on odd cycles write to secondary OAM */
			begin: odd_cycle
				 case (state)
					READ_Y: begin
						s_oam_addr <= {s_oam_idx, m};
						s_oam_data_in <= p_oam_data_out;
						s_oam_WE <= 1;
						
						if(spr_in_range)
						begin
							m <= m+ 2'd1;
						end
						else
						begin
							n <= n + 6'd1;
							m <= 0;
						end
					end
					
					COPY_SPR: begin
						/* If fetching 0th sprite, set spr0 hit */
						if( n == 6'd0)
							spr0_found <= 1;
							
						s_oam_addr <= {s_oam_idx[2:0], m};
						s_oam_data_in <= p_oam_data_out;
						s_oam_WE <= 1;
						m <= m+ 2'd1;
						if( m == 2'd3)
						begin
							n <= n+ 6'd1;
							s_oam_idx <= s_oam_idx + 3'd1;
						end
					end
					
					INC_N: begin
						;
					end
					
					/* checks for extra sprites */
					SPR_OVERFLOW: begin
						if(spr_in_range)
						begin
							spr_overflow <= 1;
							m <= m + 2'd1;
							if( m == 2'd3)
								n <= n + 6'd1;
															
						end
						else
						begin
							n <= n + 6'd1;
							m <= m + 2'd1; /* Hardware bug that incorrectly checks for overflow */
						end
							
					end
					
					default: ;
				
				endcase
			end:odd_cycle
			else/* on even cycle, wait for primary OAM read */
			begin: even_cycle
				;
			end:even_cycle
			
		end: Sprite_evaluation
		
		if(x_idx >= 256 && x_idx < 320)
		begin: Sprite_fetch
			/* Fetch the name table entries in the secondary OAM */
			case(x_idx[2:0])
				/* FETCH_NT_2 */
				3'h0: begin
					VRAM_addr <= 0;
					s_oam_addr <= {s_oam_idx, 2'd1};
					
				end
				3'h1: begin
					spr_tile_num <= s_oam_data_out;
					s_oam_addr <= {s_oam_idx, 2'd2};
				end
				 3'h2:	begin
					spr_attr[s_oam_idx] <= s_oam_data_out;
					s_oam_addr <= {s_oam_idx, 2'd3};
				 end
				 
				/* FETCH_AT_2 */
				3'h3: begin
					/* If it is sprite 0, set attr bit 2 to 1 */
					if(spr0_found)
						spr_attr[s_oam_idx][2] <= 1'b1;
					else
						spr_attr[s_oam_idx][2] <= 1'b0;
					spr_x_pos[s_oam_idx] <= s_oam_data_out;
					
				end
				3'h4:begin
				/* If vertically flipped, get a different sliver */
				if(spr_attr[s_oam_idx][7] == 1'b1)
					VRAM_addr <= {3'b0, spr_pt_addr, spr_tile_num, 1'b0, ~(y_idx[2:0])};
				else
					VRAM_addr <= {3'b0, spr_pt_addr, spr_tile_num, 1'b0, y_idx[2:0]};
				end
				/* FETCH_PT_LOW_2 */	
				3'h5:begin
					if(spr_tile_num == 8'hFF)
						spr_bmp_low[s_oam_idx] <= 8'h0;
					else
					begin
						/* Flip a tile horizontally if needed */
						if(spr_attr[s_oam_idx][6] == 1'b1)
						begin
							spr_bmp_low[s_oam_idx][7] <= VRAM_data_in[0];
							spr_bmp_low[s_oam_idx][6] <= VRAM_data_in[1];
							spr_bmp_low[s_oam_idx][5] <= VRAM_data_in[2];
							spr_bmp_low[s_oam_idx][4] <= VRAM_data_in[3];
							spr_bmp_low[s_oam_idx][3] <= VRAM_data_in[4];
							spr_bmp_low[s_oam_idx][2] <= VRAM_data_in[5];
							spr_bmp_low[s_oam_idx][1] <= VRAM_data_in[6];
							spr_bmp_low[s_oam_idx][0] <= VRAM_data_in[7];
						end
						else
							spr_bmp_low[s_oam_idx] <= VRAM_data_in;
					end
						
					if(spr_attr[s_oam_idx][7] == 1'b1)
						VRAM_addr <= {3'b0, spr_pt_addr, spr_tile_num, 1'b0, ~(y_idx[2:0])};
					else
						VRAM_addr <= {3'b0, spr_pt_addr, spr_tile_num, 1'b1, y_idx[2:0]};
				end
				
				3'h6:begin
					if(spr_tile_num == 8'hFF)
						spr_bmp_high[s_oam_idx] <= 8'h0;
					else
					begin
						if(spr_attr[s_oam_idx][6] == 1'b1)
						begin
							spr_bmp_high[s_oam_idx][7] <= VRAM_data_in[0];
							spr_bmp_high[s_oam_idx][6] <= VRAM_data_in[1];
							spr_bmp_high[s_oam_idx][5] <= VRAM_data_in[2];
							spr_bmp_high[s_oam_idx][4] <= VRAM_data_in[3];
							spr_bmp_high[s_oam_idx][3] <= VRAM_data_in[4];
							spr_bmp_high[s_oam_idx][2] <= VRAM_data_in[5];
							spr_bmp_high[s_oam_idx][1] <= VRAM_data_in[6];
							spr_bmp_high[s_oam_idx][0] <= VRAM_data_in[7];
						end
						else
						spr_bmp_high[s_oam_idx] <= VRAM_data_in;
					end
					
				end
				3'h7: begin
					s_oam_idx <= s_oam_idx + 3'd1;
				end
				
			endcase
		end: Sprite_fetch
	end
end


always_comb
begin: next_state_logic
	next_state = state;
		unique case (state)
		
			IDLE: begin 
				if(x_idx == 10'd63)
					next_state = READ_Y;
			end
			READ_Y: begin
				if(spr_in_range)
					next_state = COPY_SPR;
				else if (x_idx[0])
					next_state = INC_N;
				
				if(n == 6'h3f)
					next_state = IDLE;
			end
			
			COPY_SPR: begin
				if(m == 2'd3 & x_idx[0])
					next_state = INC_N;
			end
			
			INC_N: begin
				if(s_oam_idx < 3'd7)
					next_state = READ_Y;
				else if(s_oam_idx == 3'd7)
					next_state = SPR_OVERFLOW;
			end
			
			SPR_OVERFLOW: begin
				if(spr_in_range)
					next_state = IDLE;
				if(x_idx >= 10'd256)
					next_state = IDLE;
			end
			default: next_state = IDLE;
		
		endcase
end:next_state_logic



assign pixel = {spr_attr[0][1:0], spr_bmp_high[0][7], spr_bmp_low[0][7]};
assign spr_priority = spr_attr[0][5];
endmodule
