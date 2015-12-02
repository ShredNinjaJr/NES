
/* Memory mapper module for the VRAM. It is responsible for mirroring as well as choosing
	the right module */

module WRAM_mapper
(
	input WE,
	input [15:0] addr,
	input [7:0] PRG_ROM_out, CPU_RAM_out,
	output logic CPU_RAM_WE, vram_WE,
	output logic [10:0] CPU_RAM_addr,
	output logic [14:0] PRG_ROM_addr,
	
	output logic[7:0] data_out, vram_data_out,
	output logic ppu_reg_cs,
	output logic [2:0] ppu_reg_addr
);

assign PRG_ROM_addr = addr[14:0];
assign CPU_RAM_addr = addr[10:0];
assign ppu_reg_addr = addr[2:0];

/* 0x0000- 0x1FFF is mapped to the internal RAM*/
always_comb
begin
	CPU_RAM_WE = 0;
	ppu_reg_cs = 1;
	vram_WE = 0;
	 if(addr < 16'h2000)	/* It is inside the cartridge */
	 begin
				data_out = CPU_RAM_out;
				CPU_RAM_WE = WE;
	 end
	 else if(addr < 16'h4000 && addr >= 16'h2000)
	 /* if writing/reading from registers */
	 begin
			ppu_reg_cs = 0;
			data_out = vram_data_out;
			vram_WE = WE;
	 end
	 else if(addr[15])
	 begin
			data_out = PRG_ROM_out;
			
	 end
	 else
			data_out = 0;
	 
end


endmodule
