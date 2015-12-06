/* module that contains the CHR_ROM of the cartridge */
module PRG_ROM(clk, addr,data_out);
parameter n = 15;	
parameter w = 8;

input clk;
input [n-1:0] addr;
output logic[w-1:0] data_out;

// Start module here!
reg [w-1:0] reg_array [2**n-1:0];
initial
begin
    $readmemh("../ROMs/colors_ROM.txt", reg_array);
end



always @(negedge(clk)) begin
    data_out <= reg_array[addr];
end
endmodule  