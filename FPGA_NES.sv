module  FPGA_NES		( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  input[16:0]   SW,
							  output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  //output [8:0]  LEDG,
							  //output [17:0] LEDR,
							  // VGA Interface 
                       output logic [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output logic  VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS				//VGA horizontal sync signal
											);
    
    logic clk, reset;
	 assign clk = CLOCK_50;	 
	 assign reset = ~KEY[0];
	logic [3:0] hex_4[7:0]; 
	HexDriver hex_drivers[7:0] (hex_4, {HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0});
	
	assign {hex_4[3], hex_4[2], hex_4[1], hex_4[0]} = SW[15:0];
	
	//VRAM vram(.clk(Clk), .addr(SW), .WE(SW[16]), .data_out({hex_4[5],hex_4[4]}));

   ppu_toplevel ppu_toplevel(.*);
	 
	 
	
endmodule