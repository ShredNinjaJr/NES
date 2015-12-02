/* Work RAM: internal RAM used by the cpu. 2kb in size at address 0- 0x800 mirrored till 0x1FFF*/

module CPU_RAM(clk, addr, WE, data_out, data_in);
parameter n = 11;
parameter w = 8;

input clk, WE;
input [n-1:0] addr;
input [w-1:0] data_in;
output logic[w-1:0] data_out;

// Start module here!
reg [w-1:0] reg_array [2**n-1:0];


always @(negedge(clk)) begin
    if( WE == 1 )
        reg_array[addr] <= data_in;
    data_out <= reg_array[addr];
end
endmodule  