module RAM #(parameter w = 8, parameter n = 16)
(
input clk, WE,
input [n-1:0] addr,
input [w-1:0] data_in,
output logic[w-1:0] data_out
);
// Start module here!
reg [w-1:0] reg_array [2**n-1:0];


assign data_out = reg_array[addr];
always @(posedge(clk)) begin
    if( WE == 1 )
        reg_array[addr] <= data_in;
end
endmodule  