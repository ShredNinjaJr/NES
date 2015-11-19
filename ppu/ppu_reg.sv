/* Register interface for the PPU */
/* Things to do: Finish up the OAM and PPU registers! */
module ppu_reg
(
	input reset,
	input clk, WE,
	input [7:0] cpu_data_in,
	input [15:0] cpu_addr_in,
	output logic [7:0] ppu_data_out,
	output logic [15:0] ppu_addr_out,
	output logic [7:0] OAM_data_out,
	output logic [7:0] OAM_addr_out,
	output logic [7:0]cpu_data_out
);

/* register numbers in the mem array */
parameter PPUCTRL = 3'd0;
parameter PPUMASK = 3'd1;
parameter PPUSTATUS = 3'd2;
parameter OAMADDR = 3'd3;
parameter OAMDATA = 3'd4;
parameter PPUSCROLL = 3'd5;
parameter PPUADDR = 3'd6;
parameter PPUDATA = 3'd7;


logic [7:0] reg_array[7:0];	/* 8 registers 0x2000 - 0x2007 */

logic [2:0]reg_addr;
assign reg_addr = cpu_addr_in[2:0];

logic counter;

always_ff @(posedge clk)
begin
	if(reset)
	begin
		reg_array[0] <= 0;
		reg_array[1] <= 0;
		reg_array[2] <= 0;
		reg_array[3] <= 0;
		reg_array[4] <= 0;
		reg_array[5] <= 0;
		reg_array[6] <= 0;
		reg_array[7] <= 0;
		counter <= 0;
		ppu_addr_out <= 0;
	end
	
	else
	begin
		

		/* Special cases that happen if some registers are read from/written to */
		case(reg_addr)
			PPUSTATUS: 
			begin
				/* If reading from the register, clear bit 7 */
				if(~WE)
					reg_array[reg_addr] <= reg_array[reg_addr] & 8'h8F;
			end
			
			OAMDATA: /*IF OAMDATA is written to, increment OAMADDR */
			begin
				if(WE)
					reg_array[reg_addr] <= reg_array[reg_addr] + 1;
			end
			
			PPUSCROLL:	/********************PLACE HOLDER */
			begin
			end
			
			PPUADDR:
			
			default: begin
				cpu_data_out <= reg_array[reg_addr];
				if(WE)
					reg_array[reg_addr] <= cpu_data_in;
			end
		endcase	
	end
end

endmodule