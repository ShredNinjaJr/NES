module ppu_bg
(
	input clk, reset, 
	input [7:0] VRAM_data_in,
	output logic [15:0] VRAM_addr,
	output logic [4:0] pixel,		/* Palette address for the pixel */
	input [9:0] x_idx,
	input [9:0] scanline,
	input bg_pt_addr
);

logic shift_en;

logic [7:0] PT_in_low, PT_in_high;				/* temporary registers to hold the values fetched from memory*/
logic [7:0] PT_index;								/* index ofthe pattern table retrieved from the nametable */
logic next_AT_low, next_AT_high; 				/* 1 bit registers to hold the value of the AT*/

logic [9:0] y_idx;
assign y_idx = (x_idx < 9'd256) ? (scanline - 10'd1) : scanline;
logic [15:0] temp_VRAM_addr;	/* Address for starting address of rendering */
assign temp_VRAM_addr = 16'h2000 + ((y_idx & 8'hF8) << 2);
logic [5:0] AT_idx;		/* register to hold the value of AT index */

/* Shift registers that hold the pattern table and attribute table data  */
logic [15:0] PT_low_reg, PT_high_reg;
logic [8:0] AT_low_reg, AT_high_reg;

assign pixel = {1'b0, AT_high_reg[0], AT_low_reg[0], PT_high_reg[0], PT_low_reg[0]};

always_ff @ (posedge clk, posedge reset)
begin
	if(reset)
	begin
		PT_in_low <= 0;
		PT_in_high <= 0;
		PT_index <= 0;
		next_AT_low <= 0;
		next_AT_high <= 0;
		AT_idx <= 0;
		PT_low_reg <= 0;
		PT_high_reg <= 0;
		AT_high_reg <= 0;
		AT_low_reg <= 0;
		VRAM_addr <= 0;
	end
	else
	begin
		
		if((x_idx < 9'd256) )
		begin
		
			/* Shift the resgisters */
			PT_low_reg[14:0] <= PT_low_reg[15:1];
			PT_high_reg[14:0] <= PT_high_reg[15:1];
			AT_low_reg[7:0] <= AT_low_reg[8:1];
			AT_high_reg[7:0] <= AT_high_reg[8:1];
			
			/* depending on the x_idx, do a coressponding fetch */
			case(x_idx[2:0])
				/* FETCH_NT_2 */
				3'h0: begin
					VRAM_addr <= temp_VRAM_addr + ((x_idx) >> 3) + 2;
				end
				3'h1: begin
					PT_index <= VRAM_data_in;
					AT_idx <= {VRAM_addr[9:7], VRAM_addr[4:2]};
				end
				 3'h2:	VRAM_addr <= 16'h23C0 +  AT_idx;
				/* FETCH_AT_2 */
				3'h3: begin
			
					unique case({y_idx[4], x_idx[4]})
					
					2'b11: begin
						next_AT_high <= VRAM_data_in[7];
						next_AT_low <= VRAM_data_in[6];
					end
					2'b10: begin
						next_AT_high <= VRAM_data_in[5];
						next_AT_low <= VRAM_data_in[4];
					end
					2'b01: begin
						next_AT_high <= VRAM_data_in[3];
						next_AT_low <= VRAM_data_in[2];
					end
					2'b00: begin
						next_AT_high <= VRAM_data_in[1];
						next_AT_low <= VRAM_data_in[0];
					end
					endcase
				end
				3'h4:begin
					VRAM_addr <= {4'b0, bg_pt_addr, PT_index, 1'b0, y_idx[2:0]};
				end
				/* FETCH_PT_LOW_2 */	
				3'h5:begin
					PT_in_low <= VRAM_data_in;
					VRAM_addr <= {4'b0, bg_pt_addr, PT_index, 1'b1, y_idx[2:0]};
				end
				
				3'h6:begin
					PT_in_high <= VRAM_data_in;
				end
				3'h7: begin
					/* load the registers */
					PT_low_reg[8] <= PT_in_low[7];
					PT_high_reg[8] <= PT_in_high[7];
					PT_low_reg[9] <= PT_in_low[6];
					PT_high_reg[9] <= PT_in_high[6];
					PT_low_reg[10] <= PT_in_low[5];
					PT_high_reg[10] <= PT_in_high[5];
					PT_low_reg[11] <= PT_in_low[4];
					PT_high_reg[11] <= PT_in_high[4];
					PT_low_reg[12] <= PT_in_low[3];
					PT_high_reg[12] <= PT_in_high[3];
					PT_low_reg[13] <= PT_in_low[2];
					PT_high_reg[13] <= PT_in_high[2];
					PT_low_reg[14] <= PT_in_low[1];
					PT_high_reg[14] <= PT_in_high[1];
					PT_low_reg[15] <= PT_in_low[0];
					PT_high_reg[15] <= PT_in_high[0];
					
					AT_high_reg[8] <= next_AT_high;
					AT_low_reg[8] <= next_AT_low;
				end
				
			endcase
		end
		
		else if ( x_idx >= 9'd320 && x_idx < 9'd336 )
		begin
					
			/* Shift the resgisters */
			PT_low_reg[14:0] <= PT_low_reg[15:1];
			PT_high_reg[14:0] <= PT_high_reg[15:1];
			AT_low_reg[7:0] <= AT_low_reg[8:1];
			AT_high_reg[7:0] <= AT_high_reg[8:1];
			
			/* depending on the x_idx, do a coressponding fetch */
			case(x_idx[2:0])
				/* FETCH_NT_2 */
				3'h0: begin
					VRAM_addr <= temp_VRAM_addr + ((x_idx[3:0]) >> 3);
				end
				3'h1: begin
					PT_index <= VRAM_data_in;
					AT_idx <= {VRAM_addr[9:7], VRAM_addr[4:2]};
				end
				 3'h2:	VRAM_addr <= 16'h23C0 +  AT_idx;
				/* FETCH_AT_2 */
				3'h3: begin
			
					unique case({y_idx[4], x_idx[4]})
					
					2'b11: begin
						next_AT_high <= VRAM_data_in[7];
						next_AT_low <= VRAM_data_in[6];
					end
					2'b10: begin
						next_AT_high <= VRAM_data_in[5];
						next_AT_low <= VRAM_data_in[4];
					end
					2'b01: begin
						next_AT_high <= VRAM_data_in[3];
						next_AT_low <= VRAM_data_in[2];
					end
					2'b00: begin
						next_AT_high <= VRAM_data_in[1];
						next_AT_low <= VRAM_data_in[0];
					end
					endcase
				end
				3'h4:begin
					VRAM_addr <= {4'b0, bg_pt_addr, PT_index, 1'b0, y_idx[2:0]};
				end
				/* FETCH_PT_LOW_2 */	
				3'h5:begin
					PT_in_low <= VRAM_data_in;
					VRAM_addr <= {4'b0, bg_pt_addr, PT_index, 1'b1, y_idx[2:0]};
				end
				
				3'h6:begin
					PT_in_high <= VRAM_data_in;
				end
				3'h7: begin
					/* load the registers */
					PT_low_reg[8] <= PT_in_low[7];
					PT_high_reg[8] <= PT_in_high[7];
					PT_low_reg[9] <= PT_in_low[6];
					PT_high_reg[9] <= PT_in_high[6];
					PT_low_reg[10] <= PT_in_low[5];
					PT_high_reg[10] <= PT_in_high[5];
					PT_low_reg[11] <= PT_in_low[4];
					PT_high_reg[11] <= PT_in_high[4];
					PT_low_reg[12] <= PT_in_low[3];
					PT_high_reg[12] <= PT_in_high[3];
					PT_low_reg[13] <= PT_in_low[2];
					PT_high_reg[13] <= PT_in_high[2];
					PT_low_reg[14] <= PT_in_low[1];
					PT_high_reg[14] <= PT_in_high[1];
					PT_low_reg[15] <= PT_in_low[0];
					PT_high_reg[15] <= PT_in_high[0];
					
					AT_high_reg[8] <= next_AT_high;
					AT_low_reg[8] <= next_AT_low;
				end
				
			endcase
		end
	end
end







endmodule 
