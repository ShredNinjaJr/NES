	component pll is
		port (
			reset_reset_n  : in  std_logic := 'X'; -- reset_n
			clk_clk        : in  std_logic := 'X'; -- clk
			ppu_clk_clk    : out std_logic;        -- clk
			cpu_clk_clk    : out std_logic;        -- clk
			master_clk_clk : out std_logic         -- clk
		);
	end component pll;

	u0 : component pll
		port map (
			reset_reset_n  => CONNECTED_TO_reset_reset_n,  --      reset.reset_n
			clk_clk        => CONNECTED_TO_clk_clk,        --        clk.clk
			ppu_clk_clk    => CONNECTED_TO_ppu_clk_clk,    --    ppu_clk.clk
			cpu_clk_clk    => CONNECTED_TO_cpu_clk_clk,    --    cpu_clk.clk
			master_clk_clk => CONNECTED_TO_master_clk_clk  -- master_clk.clk
		);

