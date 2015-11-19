/* Palette memory
 *  Asynchronous reads -- because the VGA controller needs to read this asynchronously
 *  Synchronous writes
 * 32 byte address space
 */

module palette_mem ( input 			clk,
                     input  [4:0]  addr,
							input   [7:0] data_in,
							output logic [7:0] data_out,
                     input          WE );
												
   parameter size = 32; // expand memory as needed (current is 64 words)
	 
   logic [7:0] mem_array [size-1:0];
	 
assign data_out = mem_array[addr];

			

always_ff @ (posedge clk)
begin
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