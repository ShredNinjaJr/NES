onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/VRAM_data_in
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/VRAM_addr
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/pixel
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/x_idx
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/y_idx
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/PT_in_low
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/PT_in_high
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/PT_index
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/next_AT_low
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/next_AT_high
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/temp_VRAM_addr
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/AT_idx
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/PT_low_reg
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/PT_high_reg
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/AT_low_reg
add wave -noupdate -radix hexadecimal /bg_render_testbench/toplevel/bg_render/AT_high_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {33147 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 333
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
WaveRestoreZoom {0 ps} {269972 ps}
