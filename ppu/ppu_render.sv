/* Module that contains the logic to render scanlines on the ppu */

module ppu_render
(
	input clk, reset, 
	input [7:0] VRAM_data_in,
	output logic [15:0] VRAM_addr,
	output logic [4:0] pixel,		/* Palette address for the pixel */
	output logic render_ready,		/* Signal that asserts the 32 tiles on the scanline have finished*/
	output logic scanline_done, 	/*signal that asserts that the scanline has finished */
	input [7:0] y_idx,
	input render, VGA_HS, VGA_VS
);

logic fine_X_scroll;
logic shift_en;
logic [7:0] PT_in_low, PT_in_high;				/* temporary shift registers to hold the values fetched */
logic [7:0] PT_low, PT_high, AT_low, AT_high;	/* Wires as inputs to the shift registers */
logic [7:0] PT_index;									/* index ofthe pattern table retrieved from the nametable */
logic next_PT_low, next_PT_high;
logic next_AT_low, next_AT_high; 				/* 1 bit registers to hold the value of the AT*/
logic load_PT_low, load_PT_high;

logic [15:0] temp_VRAM_addr;	/* Address for starting address of rendering */
logic [5:0] current_idx;		/* Counter for the current index*/

logic [5:0] AT_idx;		/* register to hold the value of AT index */


//logic AT_byte_idx = 
/* Parallel in serial out shift register for next tile pattern data */
PISO_shift_register next_PT_reg_low(.*, .load(load_PT_low), .in(PT_in_low), .out(next_PT_low));
PISO_shift_register next_PT_reg_high(.*, .load(load_PT_high), .in(PT_in_high), .out(next_PT_high));

/* Serial-in/Parallel out Shift register for current tile byte */
SIPO_shift_register PT_reg_low(.*,  .in(next_PT_low), .out(PT_low));
SIPO_shift_register PT_reg_high(.*,  .in(next_PT_high), .out(PT_high));

SIPO_shift_register AT_reg_low(.*, .in(next_AT_low), .out(AT_low));
SIPO_shift_register AT_reg_high(.*,.in(next_AT_high), .out(AT_high));


enum logic[3:0] { WAIT, FETCH_NT_1, FETCH_NT_2, FETCH_AT_1, FETCH_AT_2, 
						FETCH_PT_LOW_1, FETCH_PT_LOW_2, FETCH_PT_HIGH_1, FETCH_PT_HIGH_2} state, next_state;
						
assign temp_VRAM_addr = 16'h2000 + ((y_idx & 8'hF8) << 2);

always_ff @(posedge clk, posedge reset)
begin

if(reset)
begin
	state <= WAIT;
	VRAM_addr <= 0;	
	current_idx <= 0;
	render_ready <= 0;
end
else
begin
	state <= next_state;
	case(state)
		WAIT: begin
			shift_en <= 0;
			load_PT_high <= 0;
			load_PT_low <= 0;
			current_idx <= 0;
			scanline_done <= 0;
			render_ready <= 1;
		end
		FETCH_NT_1:begin
			shift_en <= 1;
			VRAM_addr <= temp_VRAM_addr + current_idx;
			load_PT_high <= 0;
			load_PT_low <= 0;
			render_ready <= 1;
			scanline_done <= 0;
			
		end
		
		FETCH_NT_2: begin
			PT_index <= VRAM_data_in;
			AT_idx <= {VRAM_addr[9:7], VRAM_addr[4:2]};
		end
		
		FETCH_AT_1:begin
			VRAM_addr <= 16'h23C0 +  AT_idx;
		end
		
		FETCH_AT_2: begin
			
			unique case({y_idx[4], current_idx[1]})
			
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
			default: ;
			
			endcase
			
		end
		
		FETCH_PT_LOW_1:begin
			VRAM_addr <= 16'h1000 + (PT_index << 4) + y_idx[2:0];
		end
		FETCH_PT_LOW_2:begin
			PT_in_low <= VRAM_data_in;
		end
		FETCH_PT_HIGH_1:begin
			VRAM_addr <= 16'h1000 + (PT_index << 4)+ 8+ y_idx[2:0];
			
		end
		FETCH_PT_HIGH_2:begin
			PT_in_high <= VRAM_data_in;
			load_PT_high <= 1;
			load_PT_low <= 1;
			current_idx <= current_idx + 1;
			
			if(current_idx == 6'd31)
			begin
			render_ready <= 0;
				scanline_done <= 1;
			end

		
		end
	endcase

end
end

/* next state logic */

always_comb
begin
next_state = state;
	unique case (state)
		WAIT: begin
			if(render)
				next_state = FETCH_NT_1;
			else
				next_state = WAIT;
		end
		FETCH_NT_1: next_state = FETCH_NT_2;
		
		FETCH_NT_2: next_state = FETCH_AT_1;
		
		FETCH_AT_1: next_state = FETCH_AT_2;
		
		FETCH_AT_2: next_state = FETCH_PT_LOW_1;
		
		FETCH_PT_LOW_1: next_state = FETCH_PT_LOW_2;
		
		FETCH_PT_LOW_2: next_state = FETCH_PT_HIGH_1;
		
		FETCH_PT_HIGH_1: next_state = FETCH_PT_HIGH_2;
		FETCH_PT_HIGH_2:begin
			if(current_idx == 6'd31)
			begin
				next_state = WAIT;
			end
			else
				next_state = FETCH_NT_1;
				
		end
		default:;
	endcase
end



/* Combinational logic responsible for retrieving the correct color*/
always_comb
begin
	pixel = {1'b0, AT_high[0], AT_low[0], PT_high[0], PT_low[0]};
	
end



endmodule
