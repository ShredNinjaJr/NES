module RAM(clk, addr, WE, data_out, data_in);
parameter n = 16;
parameter w = 8;

input clk, WE;
input [n-1:0] addr;
input [w-1:0] data_in;
output logic[w-1:0] data_out;

// Start module here!
reg [w-1:0] reg_array [2**n-1:0];

initial
begin
    $readmemh("mario_chr.txt", reg_array);
end

always @(negedge(clk)) begin
    if( WE == 1 )
        reg_array[addr] <= data_in;
    data_out <= reg_array[addr];
end
endmodule  