/* Test bench to make sure the VRAM mapper works correctly */

module spr_render_testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic clk = 0;	
logic reset;
logic [7:0] VRAM_data_in;
logic [15:0] VRAM_addr;
logic [9:0] x_idx, scanline;
logic spr_pt_addr = 0;
logic spr0_hit, spr_overflow;
logic [3:0] pixel;

ppu_spr spr(.*);
	
// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#2 clk = ~clk;

#2 x_idx = x_idx + 1;

end

initial begin: CLOCK_INITIALIZATIONff
    clk = 0;
	 scanline = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS

#2 reset = 1;

#2 reset = 0;


#2 x_idx = 0;


	

end
endmodule
