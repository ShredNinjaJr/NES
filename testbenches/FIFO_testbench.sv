module FIFO_testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic r_clk = 0, w_clk = 0;	
logic WE, RE;
logic reset;
logic [5:0] data_out, data_in;
logic empty, full;
integer ErrorCnt  = 0;


FIFO fifo_module(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 w_clk = ~w_clk;
end

always begin
#2 r_clk = ~r_clk;
end

initial begin: CLOCK_INITIALIZATION
    r_clk = 1;
	 w_clk = 1;
	 reset = 0;
	 RE = 0;
	 WE = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS

	reset = 1;
#2 reset = 0;
	if(!empty)
		$display("FIFO NOT EMPTY ON RESET!");
		
#4 data_in = 6'h20;
	WE = 1;
#2	data_in = 6'h02;

#2 data_in = 6'h34;

#2 data_in = 6'h0F;

#2 data_in = 6'h0F;
RE = 1;
#2 data_in = 6'h10;

#2 data_in = 6'h11;

#2 data_in = 6'h12;

#2 data_in = 6'h13;

#2 data_in = 6'h14;

#2 data_in = 6'h15;

#2 data_in = 6'h16;

#2 data_in = 6'h17;

	
#3 
	WE = 0;

end


endmodule
