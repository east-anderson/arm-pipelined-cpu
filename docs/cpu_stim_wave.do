onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_stim/clk
add wave -noupdate /cpu_stim/reset
add wave -noupdate -radix binary /cpu_stim/instr_out
add wave -noupdate -expand -group {Reg2Loc mux} -radix unsigned /cpu_stim/dut/reg2loc_mux/out
add wave -noupdate -expand -group {Reg2Loc mux} -radix unsigned /cpu_stim/dut/reg2loc_mux/i0
add wave -noupdate -expand -group {Reg2Loc mux} -radix unsigned /cpu_stim/dut/reg2loc_mux/i1
add wave -noupdate -expand -group {Reg2Loc mux} -radix unsigned /cpu_stim/dut/reg2loc_mux/sel
add wave -noupdate /cpu_stim/i
add wave -noupdate -childformat {{{/cpu_stim/dut/RF/RegisterArrayOut[31]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[30]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[29]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[28]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[27]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[26]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[25]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[24]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[23]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[22]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[21]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[20]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[19]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[18]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[17]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[16]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[15]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[14]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[13]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[12]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[11]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[10]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[9]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[8]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[7]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[6]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[5]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[4]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[3]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[2]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[1]} -radix decimal} {{/cpu_stim/dut/RF/RegisterArrayOut[0]} -radix decimal}} -expand -subitemconfig {{/cpu_stim/dut/RF/RegisterArrayOut[31]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[30]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[29]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[28]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[27]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[26]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[25]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[24]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[23]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[22]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[21]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[20]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[19]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[18]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[17]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[16]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[15]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[14]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[13]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[12]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[11]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[10]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[9]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[8]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[7]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[6]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[5]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[4]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[3]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[2]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[1]} {-height 15 -radix decimal} {/cpu_stim/dut/RF/RegisterArrayOut[0]} {-height 15 -radix decimal}} /cpu_stim/dut/RF/RegisterArrayOut
add wave -noupdate -radix decimal /cpu_stim/dut/PC/out
add wave -noupdate -radix decimal /cpu_stim/dut/PC/in
add wave -noupdate -radix decimal /cpu_stim/dut/PCADD/Sum
add wave -noupdate -radix decimal /cpu_stim/dut/IMEM/address
add wave -noupdate /cpu_stim/dut/IMEM/instruction
add wave -noupdate -expand /cpu_stim/dut/EX_FLAGS/flags_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {500711441 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 297
configure wave -valuecolwidth 282
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
configure wave -timelineunits ps
update
WaveRestoreZoom {377189063 ps} {509095313 ps}
