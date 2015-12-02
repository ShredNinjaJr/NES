restart -f
force -freeze FPGA_NES/clk 0 0ns, 1 10ns -r 20ns
force FPGA_NES/reset 1 0ns, 0 50ns
force FPGA_NES/cpu_toplevel/nmi 0 0ns
force FPGA_NES/cpu_toplevel/cpu/irq 0 0ns
force FPGA_NES/rdy 0 0ns, 1 15ns
log -r *
run 1us