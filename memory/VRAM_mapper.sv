
/* Memory mapper module for the VRAM. It is responsible for mirroring as well as choosing
	the right module */

module VRAM_mapper
(
	input WE,
	input [15:0] addr,
	input [7:0] CHR_ROM_out, CIRAM_out, palette_out,
	output logic[7:0] data_out,
	output logic CIRAM_WE, palette_WE,
	
	output logic [10:0] CIRAM_addr,
	output logic [12:0] CHR_ROM_addr
);





assign CHR_ROM_addr = addr[12:0];

/* assuming vertical mirroring,  */
wire V_MIRRORING = 1;
assign CIRAM_addr[10] = V_MIRRORING ? addr[10] : addr[11];
assign CIRAM_addr[9:0] = addr[9:0];


/* 0x0000- 0x1FFF is mapped to the CHR ROM in the cart which starts at 0x8000*/
always_comb
begin
	CIRAM_WE = 0;
	palette_WE = 0;
	
	 if(addr[13:0] < 14'h2000)	/* It is inside the cartridge */
				data_out = CHR_ROM_out;

	
	 else if(addr[13:0] >= 14'h2000 && addr[13:0] < 14'h3F00)
	 begin
			data_out = CIRAM_out;
			CIRAM_WE = WE;
	 end
	 
	 else		/* It is addressing the palette */
	 begin
				palette_WE = WE;
				data_out = palette_out;
	 end
	 
end

	


endmodule
