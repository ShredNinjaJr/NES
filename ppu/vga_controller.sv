module  vga_controller ( input        clk,       // 50 MHz clock
                                      reset,     // reset signal
								 input[5:0]		palette_disp_idx,
                         output logic hs,        // Horizontal sync pulse.  Active low
								              vs,        // Vertical sync pulse.  Active low
												  pixel_clk, // 25 MHz pixel clock output
												  blank,     // Blanking interval indicator.  Active low.
												  sync,      // Composite Sync signal.  Active low.  We don't use it in this lab,
												             //   but the video DAC on the DE2 board requires an input for it.
								 output logic [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,
								 output logic [9:0] hc, vc
										);		  
								 
    // 800 horizontal pixels indexed 0 to 799
    // 525 vertical pixels indexed 0 to 524
    parameter [9:0] hpixels = 10'b1100011111;
    parameter [9:0] vlines = 10'b1000001100;
	 
	 // horizontal pixel and vertical line counters
    
	 // signal indicates if ok to display color for a pixel
	 logic display;

    //Disable Composite Sync
    assign sync = 1'b0;

	
	 	//Runs the horizontal counter  when it resets vertical counter is incremented
   always_ff @ (posedge clk or posedge reset )
	begin: counter_proc
		  if ( reset ) 
			begin 
				 hc <= 10'b0000000000;
				 vc <= 10'b0000000000;
			end
				
		  else 
			 if ( hc == hpixels )  //If hc has reached the end of pixel count
			  begin 
					hc <= 10'b0000000000;
					if ( vc == vlines )   //if vc has reached end of line count
					begin					
						 vc <= 10'b0000000000;
					end
					else 
						 vc <= (vc + 1'b1);
			  end
			 else
			 begin
				  hc <= (hc + 1'b1);  //no statement about vc, implied vc <= vc;
			 end
	 end 
   
   
	 //horizontal sync pulse is 96 pixels long at pixels 656-752
    //(signal is registered to ensure clean output waveform)
    always_ff @ (posedge reset or posedge clk )
    begin : hsync_proc
        if ( reset ) 
            hs <= 1'b0;
        else  
            if ((((hc + 1) >= 10'b1010010000) & ((hc + 1) < 10'b1011110000))) 
                hs <= 1'b0;
            else 
				    hs <= 1'b1;
    end
	 
    //vertical sync pulse is 2 lines(800 pixels) long at line 490-491
    //(signal is registered to ensure clean output waveform)
    always_ff @ (posedge reset or posedge clk )
    begin : vsync_proc
        if ( reset ) 
           vs <= 1'b0;
        else 
            if ( ((vc + 1) == 9'b111101010) | ((vc + 1) == 9'b111101011) ) 
			       vs <= 1'b0;
            else 
			       vs <= 1'b1;
    end
       
    //only display pixels between horizontal 0-639 and vertical 0-479 (640x480)
    //(This signal is registered within the DAC chip, so we can leave it as pure combinational logic here)    
    always_comb
    begin 
        if ( (hc >= 10'd640) | (vc >= 10'd480) ) 
            display = 1'b0;
        else 
            display = 1'b1;
    end 
   
	
 always_comb
    begin:RGB_Display
	  if ((hc >= 10'd256) | (vc == 0) | (vc >= 10'd241) )
	  begin 
			VGA_R = 8'h00; 
			VGA_G = 8'h00;
			VGA_B = 8'h00;
	  end      
	  else
	  begin
		case(palette_disp_idx)
			 6'h00: {VGA_R, VGA_G, VGA_B} = {8'd84,8'd84,8'd84};  
          6'h01: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd30,8'd116};
          6'h02: {VGA_R, VGA_G, VGA_B} = {8'd8, 8'd16, 8'd144};
          6'h03: {VGA_R, VGA_G, VGA_B} = {8'd48, 8'd0, 8'd136};
          6'h04: {VGA_R, VGA_G, VGA_B} = {8'd68, 8'd0, 8'd100};
          6'h05: {VGA_R, VGA_G, VGA_B} = {8'd92, 8'd0, 8'd48};
          6'h06: {VGA_R, VGA_G, VGA_B} = {8'd84, 8'd4, 8'd0};
          6'h07: {VGA_R, VGA_G, VGA_B} = {8'd60, 8'd25, 8'd0};
          6'h08: {VGA_R, VGA_G, VGA_B} = {8'd32, 8'd42, 8'd0};
          6'h09: {VGA_R, VGA_G, VGA_B} = {8'd8, 8'd58, 8'd0};
          6'h0a: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd64, 8'd0};
          6'h0b: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd60, 8'd0};
          6'h0c: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd50, 8'd60};
          6'h0d: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0,  8'd0};
          6'h0e: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0,  8'd0}; 
          6'h0f: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0,  8'd0};

          6'h10: {VGA_R, VGA_G, VGA_B} = {8'd152,8'd150,8'd152}; 
          6'h11: {VGA_R, VGA_G, VGA_B} = {8'd8 , 8'd76 ,8'd196};
          6'h12: {VGA_R, VGA_G, VGA_B} = {8'd48, 8'd50, 8'd236};
          6'h13: {VGA_R, VGA_G, VGA_B} = {8'd92, 8'd30, 8'd228};
          6'h14: {VGA_R, VGA_G, VGA_B} = {8'd136,8'd20, 8'd176};
          6'h15: {VGA_R, VGA_G, VGA_B} = {8'd160,8'd20, 8'd100};
          6'h16: {VGA_R, VGA_G, VGA_B} = {8'd152,8'd34, 8'd32};
          6'h17: {VGA_R, VGA_G, VGA_B} = {8'd120,8'd60, 8'd0};
          6'h18: {VGA_R, VGA_G, VGA_B} = {8'd84, 8'd90, 8'd0};
          6'h19: {VGA_R, VGA_G, VGA_B} = {8'd40, 8'd114,8'd0};
          6'h1a: {VGA_R, VGA_G, VGA_B} = {8'd8, 8'd124, 8'd0};
          6'h1b: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd118, 8'd40};
          6'h1c: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd102, 8'd120};
          6'h1d: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, 8'd0};
          6'h1e: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, 8'd0}; 
          6'h1f: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, 8'd0};

          6'h20: {VGA_R, VGA_G, VGA_B} = {8'd236,8'd238,8'd236}; 
          6'h21: {VGA_R, VGA_G, VGA_B} = {8'd76, 8'd154,8'd236};
          6'h22: {VGA_R, VGA_G, VGA_B} = {8'd120,8'd124,8'd236};
          6'h23: {VGA_R, VGA_G, VGA_B} = {8'd176,8'd98, 8'd236};
          6'h24: {VGA_R, VGA_G, VGA_B} = {8'd228, 8'd84, 8'd236};
          6'h25: {VGA_R, VGA_G, VGA_B} = {8'd236, 8'd88, 8'd180};
          6'h26: {VGA_R, VGA_G, VGA_B} = {8'd236, 8'd106,8'd100};
          6'h27: {VGA_R, VGA_G, VGA_B} = {8'd212, 8'd136,8'd32};
          6'h28: {VGA_R, VGA_G, VGA_B} = {8'd160,8'd170, 8'd0};
          6'h29: {VGA_R, VGA_G, VGA_B} = {8'd116, 8'd196, 8'd0};
          6'h2a: {VGA_R, VGA_G, VGA_B} = {8'd76, 8'd208, 8'd32};
          6'h2b: {VGA_R, VGA_G, VGA_B} = {8'd56, 8'd204, 8'd108};
          6'h2c: {VGA_R, VGA_G, VGA_B} = {8'd56, 8'd180, 8'd204};
          6'h2d: {VGA_R, VGA_G, VGA_B} = {8'd60, 8'd60, 8'd60};
          6'h2e: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, 8'd0};
          6'h2f: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, 8'd0}; 

          6'h30: {VGA_R, VGA_G, VGA_B} = {8'd236, 8'd238, 8'd236};
          6'h31: {VGA_R, VGA_G, VGA_B} = {8'd168, 8'd204, 8'd236};
	       6'h32: {VGA_R, VGA_G, VGA_B} = {8'd188, 8'd188, 8'd236};
          6'h33: {VGA_R, VGA_G, VGA_B} = {8'd212, 8'd178, 8'd236};
          6'h34: {VGA_R, VGA_G, VGA_B} = {8'd236, 8'd174, 8'd236};
          6'h35: {VGA_R, VGA_G, VGA_B} = {8'd236, 8'd174, 8'd236};
          6'h36: {VGA_R, VGA_G, VGA_B} = {8'd236, 8'd180, 8'd176};
          6'h37: {VGA_R, VGA_G, VGA_B} = {8'd228, 8'd196, 8'd144};
          6'h38: {VGA_R, VGA_G, VGA_B} = {8'd204, 8'd210, 8'd120};
          6'h39: {VGA_R, VGA_G, VGA_B} = {8'd180, 8'd222, 8'd120};
          6'h3a: {VGA_R, VGA_G, VGA_B} = {8'd168, 8'd226, 8'd144};
          6'h3b: {VGA_R, VGA_G, VGA_B} = {8'd152, 8'd226, 8'd180};
          6'h3c: {VGA_R, VGA_G, VGA_B} = {8'd160, 8'd214, 8'd228};
          6'h3d: {VGA_R, VGA_G, VGA_B} = {8'd160, 8'd162, 8'd160};
          6'h3e: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, 8'd0}; 
          6'h3f: {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, 8'd0}; 
	     endcase
	  end
	 
    end 
    assign blank = display;
    assign pixel_clk = clk;
    

endmodule