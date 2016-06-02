
/* Memory mapper module for the VRAM. It is responsible for mirroring as well as choosing
	the right module */

module WRAM_mapper
(
	input WE,clk, reset,
	input [15:0] addr,
	input [7:0] PRG_ROM_out, CPU_RAM_out, data_in,
	output logic CPU_RAM_WE, vram_WE,
	output logic [10:0] CPU_RAM_addr,
	output logic [14:0] PRG_ROM_addr,
	input [7:0] vram_data_in,
	output logic[7:0] data_out, vram_data_out,
	output logic ppu_reg_cs,
	output logic [2:0] ppu_reg_addr,

	output logic oam_dma,			/* Is high during oam_dma */
	output logic [7:0]oam_addr,
	input [7:0] keycode,
	input keypress,
	output logic [7:0] keystates
);

logic [15:0] oam_dma_addr;
logic [8:0] oam_counter;
logic q_WE;		/* Register to hold WE. Used to check for a rising edge for dma */

logic keyreg0, keyreg1, keyreg2, keyreg3, keyreg4, keyreg5, keyreg6, keyreg7; 
logic [7:0] buttons;
logic ctrl_shift;
assign ctrl_shift = (addr == 16'h4016);

assign PRG_ROM_addr = addr[14:0];
assign CPU_RAM_addr = (oam_dma) ? oam_dma_addr[10:0]  :addr[10:0];
assign ppu_reg_addr = addr[2:0];
assign ppu_reg_cs  = (addr[15:13] == 3'b001) ? 1'b0 : 1'b1;
assign oam_addr = oam_counter[8:1];
/* 0x0000- 0x1FFF is mapped to the internal RAM*/

initial
begin
	{keyreg7, keyreg6, keyreg5, keyreg4, keyreg3, keyreg2, keyreg1, keyreg0} = 8'h00;
end

always_ff @(negedge ctrl_shift)
begin

if(WE & data_in[0])
	buttons <= keycode;
	
	else if(~WE)
	buttons <= {buttons[6:0], 1'b0};

end

//set controller bits
always_ff @(posedge clk)
begin

		case(keycode)
	
		/* A (a) */
		8'h1C: begin
			if(keypress)
				keyreg7 <= 1'b1;
			else keyreg7 <= 1'b0;
		end
		
		/* B (s) */
		8'h1B: begin
			if(keypress)
				keyreg6 <= 1'b1;
			else keyreg6 <= 1'b0;
		end
	
		/* SELECT (spacebar) */
		8'h29: begin
			if(keypress)
				keyreg5 <= 1'b1;
			else keyreg5 <= 1'b0;
		end
		
		/* START (enter) */
		8'h5A: begin
			if(keypress)
				keyreg4 <= 1'b1;
			else keyreg4 <= 1'b0;
		end
		
		/* UP (i) */
		8'h43: begin
			if(keypress)
				keyreg3 <= 1'b1;
			else keyreg3 <= 1'b0;
		end
		
		/* DOWN (k) */
		8'h42:begin
			if(keypress)
				keyreg2 <= 1'b1;
			else keyreg2 <= 1'b0;
		end
		
		/* LEFT (j) */
		8'h3B: begin
			if(keypress)
				keyreg1 <= 1'b1;
			else keyreg1 <= 1'b0;
		end
		
		/* RIGHT (l) */
		8'h4B: begin
			if(keypress)
				keyreg0 <= 1'b1;
			else keyreg0 <= 1'b0;
		end
	endcase
	keystates <= {keyreg7, keyreg6, keyreg5, keyreg4, keyreg3, keyreg2, keyreg1, keyreg0};
end

always_comb
begin
	CPU_RAM_WE = 0;
	vram_WE = 0;
	vram_data_out = data_in;

	/* OAM DMA */
	if(addr == 16'h4014)
	begin
		data_out = CPU_RAM_out;
		CPU_RAM_WE = 0;
	end
	 //controller read
	 else if((addr == 16'h4016) & ~WE)
		data_out = {7'h0, buttons[7]};
	
	 else if(addr < 16'h2000)	/* It is inside the cartridge */
	 begin
				data_out = CPU_RAM_out;
				CPU_RAM_WE = WE;
	 end
	 else if(addr < 16'h4000 && addr >= 16'h2000)
	 /* if writing/reading from registers */
	 begin
			data_out = vram_data_in;
			vram_WE = WE;
	 end
	 else if(addr[15])
	 begin
			data_out = PRG_ROM_out;
			
	 end
	 else
			data_out = 0;
	 
end

always_ff @ (posedge clk, posedge reset)
begin
	if(reset)
	begin
		oam_dma <= 0;
		oam_counter <= 0;
		oam_dma_addr <= 0;
		q_WE <= 0;
	end
	else
	begin
		q_WE <= WE;
		if(addr == 16'h4014)
		begin
			if(~q_WE & WE)		/* On rising edge */
				oam_dma <= 1;
			if(oam_counter == 9'd511)
				oam_dma <= 0;
				
			oam_counter <= oam_counter + 9'd1;
			oam_dma_addr <= {data_in,oam_counter[8:1]};
		end
		else
		begin
			oam_counter <= 0;
		end
	end
end

endmodule
