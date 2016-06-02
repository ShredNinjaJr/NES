/* Top Level module */
module  FPGA_NES
(
    input CLOCK_50,  /* Internal clock */
    input[3:0]  KEY, /*PUSH Buttons */
    input[16:0]   SW, /* Switches*/
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, /* Hex display*/
    input PS2_KBCLK, PS2_KBDAT,
    //output [8:0]  LEDG,
    //output [17:0] LEDR,
    // VGA Interface
    output logic [7:0]  VGA_R,	//VGA Red
                        VGA_G,	//VGA Green
                        VGA_B,	//VGA Blue
    output logic        VGA_CLK,	//VGA Clock
                        VGA_SYNC_N,	//VGA Sync signal
                        VGA_BLANK_N,	//VGA Blank signal
                        VGA_VS,		//VGA virtical sync signal
                        VGA_HS		//VGA horizontal sync signal
);
    
    logic clk, reset;
    assign reset = ~KEY[0];
    logic [7:0]		acc, instr;
    logic [15:0] pc;

    /* Clock divide by 2 */
    always_ff @ (posedge CLOCK_50 or posedge reset )
    begin: clock_divider
        if (reset)
            clk <= 1'b0;
        else
            clk <= ~ (clk);
    end

    /* Initialize Hex drivers/displays*/
	logic [3:0] hex_4[7:0];
	HexDriver hex_drivers[7:0] (hex_4, {HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0});

	assign {hex_4[3], hex_4[2], hex_4[1], hex_4[0]} = pc;
	assign {hex_4[5], hex_4[4]} = instr;
	assign {hex_4[7], hex_4[6]} = keycode;

	logic NMI_enable;
	logic nres_in;
	logic oam_dma;
	assign nres_in	= KEY[1];
	logic rdy, ppu_reg_cs, vram_WE;
	logic [2:0] ppu_reg_addr;
	logic [7:0] vram_data_out, vram_data_in;
	logic nmi;

	assign nmi = (NMI_enable) ? VGA_VS : 1'b1;

	assign rdy = (~oam_dma);// & KEY[2];
	logic [7:0] oam_addr, oam_data_in;

	logic [7:0] keycode, keystates;
	logic keypress;

	//assign {hex_4[7], hex_4[6]} = keystates;

	/*keyboard the_keyboard(.Clk(CLOCK_50), .psClk(PS2_KBCLK), .psData(PS2_KBDAT), .reset(reset),
					 .keyCode(keycode),
					 .press(keypress)); */
	assign keycode = SW[7:0];//
	cpu_toplevel cpu_toplevel( .*);


   ppu_toplevel ppu_toplevel(.*, .cpu_data_in(vram_data_out), .cpu_data_out(vram_data_in));
	 
	 
	
endmodule
