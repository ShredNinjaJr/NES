restart -f
force -freeze FPGA_NES/clk 0 0ns, 1 10ns -r 20ns
force FPGA_NES/reset 1 0ns, 0 50ns
force FPGA_NES/nres_in 0 0ns,1 200ns
force FPGA_NES/rdy 0 0ns, 1 15ns
force FPGA_NES/the_keyboard/keyCode 16#4B 0ns
force FPGA_NES/the_keyboard/press 1 0ns
log -r *
run 1us 