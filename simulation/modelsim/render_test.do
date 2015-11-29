onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label PT_reg_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/PT_reg_high/data
add wave -noupdate -label PT_reg_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/PT_reg_low/data
add wave -noupdate -label next_PT_reg_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/next_PT_reg_low/data
add wave -noupdate -label next_PT_reg_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/next_PT_reg_high/data
add wave -noupdate -label VRAM_data -radix hexadecimal /bg_render_testbench/toplevel/render_block/VRAM_data_in
add wave -noupdate -label VRAM_addr -radix hexadecimal /bg_render_testbench/toplevel/render_block/VRAM_addr
add wave -noupdate -label pixel -radix hexadecimal /bg_render_testbench/toplevel/render_block/pixel
add wave -noupdate -label fine_X -radix hexadecimal /bg_render_testbench/toplevel/render_block/fine_X_scroll
add wave -noupdate -label shift_en -radix hexadecimal /bg_render_testbench/toplevel/render_block/shift_en
add wave -noupdate -label PT_in_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/PT_in_low
add wave -noupdate -label PT_in_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/PT_in_high
add wave -noupdate -label PT_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/PT_low
add wave -noupdate -label PT_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/PT_high
add wave -noupdate -label AT_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/AT_low
add wave -noupdate -label AT_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/AT_high
add wave -noupdate -label PT_index -radix hexadecimal /bg_render_testbench/toplevel/render_block/PT_index
add wave -noupdate -label next_PT_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/next_PT_low
add wave -noupdate -label next_PT_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/next_PT_high
add wave -noupdate -label next_AT_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/next_AT_low
add wave -noupdate -label next_AT_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/next_AT_high
add wave -noupdate -label load_PT_low -radix hexadecimal /bg_render_testbench/toplevel/render_block/load_PT_low
add wave -noupdate -label load_PT_high -radix hexadecimal /bg_render_testbench/toplevel/render_block/load_PT_high
add wave -noupdate -label temp_VRAM -radix hexadecimal /bg_render_testbench/toplevel/render_block/temp_VRAM_addr
add wave -noupdate -label current_idx -radix hexadecimal /bg_render_testbench/toplevel/render_block/current_idx
add wave -noupdate -label y_idx -radix hexadecimal /bg_render_testbench/toplevel/y_idx
add wave -noupdate -label AT_idx -radix hexadecimal /bg_render_testbench/toplevel/render_block/AT_idx
add wave -noupdate -label state -radix hexadecimal /bg_render_testbench/toplevel/render_block/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1470000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 158
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
WaveRestoreZoom {8603500 ps} {10073500 ps}
