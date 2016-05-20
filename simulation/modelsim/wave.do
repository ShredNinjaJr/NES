onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/WRAM/CPU_RAM/reg_array
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/p_oam/reg_array
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/s_oam/reg_array
add wave -noupdate -radix hexadecimal /FPGA_NES/clk
add wave -noupdate -radix hexadecimal /FPGA_NES/reset
add wave -noupdate -radix hexadecimal /FPGA_NES/oam_dma
add wave -noupdate -radix hexadecimal /FPGA_NES/rdy
add wave -noupdate -radix hexadecimal /FPGA_NES/nmi
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/clk
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/reset
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_pt_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/VRAM_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/VRAM_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/pixel
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/x_idx
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/scanline
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/oam_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/oam_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/oam_dma
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr0_hit
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_overflow
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/p_oam_WE
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/s_oam_WE
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/p_oam_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/p_oam_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/s_oam_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/s_oam_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/p_oam_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/s_oam_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/s_oam_idx
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/n
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/m
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/y_idx
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_in_range
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/sprite_y
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr0_found
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_tile_num
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_bmp_low
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_bmp_high
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_attr
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_x_pos
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/spr_bmp_shift
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/state
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/next_state
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_render/spr_render/pr_oam_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {306 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}