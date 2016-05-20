/* Palette memory
 *  Asynchronous reads -- because the VGA controller needs to read this asynchronously
 *  Synchronous writes
 * 32 byte address space
 */

module palette_mem ( input 			clk,
							input 			reset,
                     input  [4:0]  addr,
							input   [7:0] data_in,
							output logic [7:0] data_out,
                     input          WE );
												
   parameter size = 32; // expand memory as needed (current is 64 words)
	 
   logic [7:0] mem_array [size-1:0];
	 
assign data_out = mem_array[addr];

			

always_ff @ (negedge clk /*or posedge reset*/)
begin
	/*if(reset)
	begin
	mem_array[0] <= 8'h22;
	mem_array[1] <= 8'h29;
	mem_array[2] <= 8'h1A;
	mem_array[3] <= 8'h0F;
	mem_array[4] <= 8'h22;
	mem_array[5] <= 8'h36;
	mem_array[6] <= 8'h17;
	mem_array[7] <= 8'h0F;
	mem_array[8] <= 8'h22;
	mem_array[9] <= 8'h30;
	mem_array[10] <= 8'h21;
	mem_array[11] <= 8'h0F;
	mem_array[12] <= 8'h22;
	mem_array[13] <= 8'h27;
	mem_array[14] <= 8'h17;
	mem_array[15] <= 8'h0F;
	end
	else */
	if(WE)
	begin
		case(addr)
		/* mirrored palette */
		6'h00, 6'h10: 
		begin
			mem_array[6'h00] <= data_in;
			mem_array[6'h10] <= data_in;
		end
		default: mem_array[addr] <= data_in;
		endcase
	end
end
	  
	  
endmodule