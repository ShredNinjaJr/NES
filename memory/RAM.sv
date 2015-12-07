module RAM #(parameter w = 8, parameter n = 16)
(
input clk, WE,
input [n-1:0] addr,
input [w-1:0] data_in,
output logic[w-1:0] data_out
);
// Start module here!
reg [w-1:0] reg_array [2**n-1:0];


always @(negedge(clk)) begin
    if( WE == 1 )
        reg_array[addr] <= data_in;
    data_out <= reg_array[addr];
end
endmodule  