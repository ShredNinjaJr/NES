restart -f
force -freeze Clk 0 0ns, 1 10ns -r 20ns
force Reset 1 0 ns, 0 10 ns
run 100us
