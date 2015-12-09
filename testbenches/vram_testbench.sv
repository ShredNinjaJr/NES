/* Test bench to make sure the VRAM mapper works correctly */

module vram_testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic clk = 0;	
logic WE, reset, oam_dma;
logic [15:0] addr;
logic [7:0] data_out, data_in;
logic [7:0] vram_data_in;
logic [7:0] vram_data_out;
logic ppu_reg_cs, vram_WE;
logic [2:0] ppu_reg_addr;
logic [7:0] oam_addr;
WRAM wram(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
    clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS

#2 addr = 16'h0000;
	WE = 1;
	
#4 addr = 16'h2000;
	WE = 0;

#4 addr = 16'h2002;
	WE = 1;

#4 addr = 16'h3005;
	WE = 0;
	
#4 addr = 16'h3F00;
	WE = 1;
	
#4 addr = 16'h8000;
	WE = 0;

#4 addr = 16'h8f80;
	WE = 1;
	
#4 addr = 16'hA8F0;
	WE = 0;
	
#4 addr = 16'hF0F0;
	WE = 1;
	

end
endmodule