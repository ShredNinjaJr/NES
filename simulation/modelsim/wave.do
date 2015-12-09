onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FPGA_NES/ppu_toplevel/palette_mem/mem_array
add wave -noupdate /FPGA_NES/clk
add wave -noupdate /FPGA_NES/reset
add wave -noupdate /FPGA_NES/rdy
add wave -noupdate /FPGA_NES/vram_WE
add wave -noupdate /FPGA_NES/ppu_reg_cs
add wave -noupdate -radix hexadecimal /FPGA_NES/vram_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/vram_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/cpu_data_in
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/cpu_data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_reg_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/pc
add wave -noupdate /FPGA_NES/cpu_toplevel/nmi
add wave -noupdate /FPGA_NES/VGA_VS
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_addr
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/wram_WE
add wave -noupdate -radix hexadecimal -childformat {{{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[7]} -radix hexadecimal} {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[6]} -radix hexadecimal} {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[5]} -radix hexadecimal} {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[4]} -radix hexadecimal} {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[3]} -radix hexadecimal} {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[2]} -radix hexadecimal} {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[1]} -radix hexadecimal} {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[0]} -radix hexadecimal}} -subitemconfig {{/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[7]} {-height 15 -radix hexadecimal} {/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[6]} {-height 15 -radix hexadecimal} {/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[5]} {-height 15 -radix hexadecimal} {/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[4]} {-height 15 -radix hexadecimal} {/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[3]} {-height 15 -radix hexadecimal} {/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[2]} {-height 15 -radix hexadecimal} {/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[1]} {-height 15 -radix hexadecimal} {/FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out[0]} {-height 15 -radix hexadecimal}} /FPGA_NES/cpu_toplevel/WRAM/wram_mapper/data_out
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/WRAM/wram_mapper/addr
add wave -noupdate /FPGA_NES/cpu_toplevel/WRAM/wram_mapper/keyreg0
add wave -noupdate /FPGA_NES/cpu_toplevel/WRAM/wram_mapper/keystates
add wave -noupdate /FPGA_NES/cpu_toplevel/WRAM/wram_mapper/buttons
add wave -noupdate -radix hexadecimal /FPGA_NES/the_keyboard/keyCode
add wave -noupdate /FPGA_NES/the_keyboard/press
add wave -noupdate /FPGA_NES/cpu_toplevel/WRAM/wram_mapper/WE
add wave -noupdate /FPGA_NES/cpu_toplevel/WRAM/wram_mapper/ctrl_shift
add wave -noupdate -label CPU_RAM /FPGA_NES/cpu_toplevel/WRAM/CPU_RAM/reg_array
add wave -noupdate -label chr /FPGA_NES/ppu_toplevel/VRAM/CHR_ROM/reg_array
add wave -noupdate -label PRG_ROM /FPGA_NES/cpu_toplevel/WRAM/PRG_ROM/reg_array
add wave -noupdate -label ciram /FPGA_NES/ppu_toplevel/VRAM/ciram/reg_array
add wave -noupdate -label {pallette } /FPGA_NES/ppu_toplevel/palette_mem/mem_array
add wave -noupdate /FPGA_NES/ppu_toplevel/ppu_register_interface/cs_in
add wave -noupdate /FPGA_NES/ppu_toplevel/ppu_register_interface/WE
add wave -noupdate -radix hexadecimal /FPGA_NES/ppu_toplevel/ppu_register_interface/cpu_data_in
add wave -noupdate /FPGA_NES/ppu_toplevel/ppu_register_interface/cpu_data_out
add wave -noupdate /FPGA_NES/clk
add wave -noupdate /FPGA_NES/reset
add wave -noupdate /FPGA_NES/rdy
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
add wave -noupdate -radix hexadecimal /FPGA_NES/cpu_toplevel/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34999946233 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 330
configure wave -valuecolwidth 54
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
WaveRestoreZoom {0 ps} {36750 us}
