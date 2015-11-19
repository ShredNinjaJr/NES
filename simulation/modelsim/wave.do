onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk -radix hexadecimal /vram_testbench/clk
add wave -noupdate -label WE -radix hexadecimal /vram_testbench/WE
add wave -noupdate -label Vram_addr -radix hexadecimal /vram_testbench/addr
add wave -noupdate -label CIRAM_addr -radix hexadecimal /vram_testbench/vram/CIRAM_addr
add wave -noupdate -label ROM_addr -radix hexadecimal /vram_testbench/vram/ROM_addr
add wave -noupdate -label CIRAM_WE -radix hexadecimal /vram_testbench/vram/CIRAM_WE
add wave -noupdate -label palette_WE -radix hexadecimal /vram_testbench/vram/palette_WE
add wave -noupdate -label palette_addr -radix hexadecimal /vram_testbench/vram/palette_mem/addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {272701 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 173
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
WaveRestoreZoom {0 ps} {420 ns}
