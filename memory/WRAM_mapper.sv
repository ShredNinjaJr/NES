
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
	output logic [7:0]oam_addr
);

logic [15:0] oam_dma_addr;
logic [8:0] oam_counter;

assign PRG_ROM_addr = addr[14:0];
assign CPU_RAM_addr = (oam_dma) ? oam_dma_addr[10:0]  :addr[10:0];
assign ppu_reg_addr = addr[2:0];
assign ppu_reg_cs  = (addr[15:13] == 3'b001) ? 1'b0 : 1'b1;
assign oam_addr = oam_counter[8:1];
/* 0x0000- 0x1FFF is mapped to the internal RAM*/
always_comb
begin
	CPU_RAM_WE = 0;
	vram_WE = 0;
	vram_data_out = data_in;

	 if(addr < 16'h2000)	/* It is inside the cartridge */
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
	end
	else
	begin
		if(addr == 16'h4014 && WE)
		begin
			if(oam_counter <= 9'd511)
				oam_dma <= 0;
			else
				oam_dma <= 1;
				
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
