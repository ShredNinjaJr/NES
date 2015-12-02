onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FPGA_NES/clk
add wave -noupdate /FPGA_NES/reset
add wave -noupdate /FPGA_NES/rdy
add wave -noupdate /FPGA_NES/cpu_toplevel/cpu/nmi
add wave -noupdate /FPGA_NES/cpu_toplevel/cpu/irq
add wave -noupdate /FPGA_NES/vram_WE
add wave -noupdate /FPGA_NES/ppu_reg_cs
add wave -noupdate -radix hexadecimal /FPGA_NES/vram_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/vram_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_WE
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/cpu_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/cpu_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_reg_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/acc
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/instr
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/pc
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/cpu/data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/cpu/addr
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/cpu/data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/cpu/instr
add wave -noupdate /FPGA_NES/cpu_toplevel/cpu/cpu_sm
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/cpu/pc_nxt
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/cpu/pc_inc
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/cpu/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {74144 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 262
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {181296 ps}
