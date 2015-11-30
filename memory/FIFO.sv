/* Synchronous FIFO Module used to buffer I/O between dissimlar clocks. */
/* Can read and write on the same cycle */
module FIFO #(parameter w = 6, parameter n = 8)
(
	input r_clk,  reset, WE, RE,
	input logic [w-1:0] data_in,
	output logic [w-1:0] data_out,
	output logic empty, full
);

logic [n-1:0] r_addr, w_addr;
logic [w-1:0] mem_array [2**n-1:0];

assign empty = (r_addr == w_addr);
assign full = (r_addr == (w_addr + 1));
 

always_ff @(posedge r_clk, posedge reset)
begin

	if(reset)
	begin
		w_addr <= 0;
	end
	else
	begin
		if(WE)
		begin: Write
			if(~full)
			begin
				mem_array[w_addr] <= data_in;
				w_addr <= w_addr + 1;
			end
		end		
	end
end

always_ff @ ( posedge r_clk, posedge reset)
begin
	if(reset)
	begin
		r_addr <= 0;
	end
	else
	begin
		if(RE)
		begin: Read
			if(~empty)
			begin
				data_out <= mem_array[r_addr];
				r_addr <= r_addr + 1;
			end
		end
		
	end
end

endmodule
