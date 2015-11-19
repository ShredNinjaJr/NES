module cart(clk, addr,data_out);
parameter n = 16;	
parameter w = 8;

input clk;
input [n-1:0] addr;
output logic[w-1:0] data_out;

initial
begin
    $readmemh("../ROMs/mario_ROM.txt", reg_array);
end

// Start module here!
reg [w-1:0] reg_array [2**n-1:0];


always @(negedge(clk)) begin
    data_out = reg_array[addr];
end
endmodule  