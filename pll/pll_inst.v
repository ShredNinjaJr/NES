	pll u0 (
		.reset_reset_n  (<connected-to-reset_reset_n>),  //      reset.reset_n
		.clk_clk        (<connected-to-clk_clk>),        //        clk.clk
		.ppu_clk_clk    (<connected-to-ppu_clk_clk>),    //    ppu_clk.clk
		.cpu_clk_clk    (<connected-to-cpu_clk_clk>),    //    cpu_clk.clk
		.master_clk_clk (<connected-to-master_clk_clk>)  // master_clk.clk
	);

