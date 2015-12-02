/* Actual VRAM, it is only 2KiB */
module CIRAM(clk, addr, WE, data_out, data_in);
parameter n = 11;	/* Only 11 bits required the rest is mirrored */
parameter w = 8;

input clk, WE;
input [n-1:0] addr;
input [w-1:0] data_in;
output logic[w-1:0] data_out;

// Start module here!
reg [w-1:0] reg_array [2**n-1:0];

initial begin

 //$readmemh("../ROMs/nametable.txt", reg_array, 0 , 1023);
end

always @(negedge(clk)) begin
    if( WE == 1 )
	 begin
        reg_array[addr] <= data_in;
	 end
    data_out <= reg_array[addr];
end
endmodule  