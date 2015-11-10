module  FPGA_NES		( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  input[15:0]   SW,
							 // output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
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
    
    logic Reset_h, Clk;
	 assign Clk = CLOCK_50;	 
	

	 

    vga_controller vgasync_instance
	 (
		.Clk(Clk),       // 50 MHz clock
      .Reset(Reset_h),     // reset signal
      .hs(VGA_HS),        // Horizontal sync pulse.  Active low
		.vs(VGA_VS),        // Vertical sync pulse.  Active low
		.pixel_clk(VGA_CLK), // 25 MHz pixel clock output
		.blank(VGA_BLANK_N),     // Blanking interval indicator.  Active low.
		.sync(VGA_SYNC_N),      // Composite Sync signal.  Active low.  We don't use it in this lab,
												             //   but the video DAC on the DE2 board requires an input for it.
		.VGA_R(VGA_R), .VGA_B(VGA_B), .VGA_G(VGA_G)
	 );
	 
	 
	 /*********************************************************************************************************/
	 /* test code to check the Memory */
	/*  logic [7:0] data_out;
	  logic [15:0] addr;
	  RAM VRAM(.clk(Clk), .data_out(data_out), .addr(addr), .WE(0));
	  
	  assign addr = SW;
	   
	  HexDriver hex_driver0 (data_out[3:0],HEX0);
	  HexDriver hex_driver1 (data_out[7:4],HEX1);
	  HexDriver hex_driver2 (0,HEX2);
	  HexDriver hex_driver3 (0,HEX3);
	  HexDriver hex_driver4 (addr[3:0],HEX4);
	  HexDriver hex_driver5 (addr[7:4],HEX5);
	  HexDriver hex_driver6 (addr[11:8],HEX6);
	  HexDriver hex_driver7 (addr[15:12],HEX7);
*/
endmodule