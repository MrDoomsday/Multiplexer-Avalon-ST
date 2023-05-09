onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mux_tb/DUT/clk
add wave -noupdate /mux_tb/DUT/reset_n
add wave -noupdate -expand -group ChannelOne -radix unsigned -childformat {{{/mux_tb/DUT/avsi_one_channel[7]} -radix unsigned} {{/mux_tb/DUT/avsi_one_channel[6]} -radix unsigned} {{/mux_tb/DUT/avsi_one_channel[5]} -radix unsigned} {{/mux_tb/DUT/avsi_one_channel[4]} -radix unsigned} {{/mux_tb/DUT/avsi_one_channel[3]} -radix unsigned} {{/mux_tb/DUT/avsi_one_channel[2]} -radix unsigned} {{/mux_tb/DUT/avsi_one_channel[1]} -radix unsigned} {{/mux_tb/DUT/avsi_one_channel[0]} -radix unsigned}} -subitemconfig {{/mux_tb/DUT/avsi_one_channel[7]} {-height 15 -radix unsigned} {/mux_tb/DUT/avsi_one_channel[6]} {-height 15 -radix unsigned} {/mux_tb/DUT/avsi_one_channel[5]} {-height 15 -radix unsigned} {/mux_tb/DUT/avsi_one_channel[4]} {-height 15 -radix unsigned} {/mux_tb/DUT/avsi_one_channel[3]} {-height 15 -radix unsigned} {/mux_tb/DUT/avsi_one_channel[2]} {-height 15 -radix unsigned} {/mux_tb/DUT/avsi_one_channel[1]} {-height 15 -radix unsigned} {/mux_tb/DUT/avsi_one_channel[0]} {-height 15 -radix unsigned}} /mux_tb/DUT/avsi_one_channel
add wave -noupdate -expand -group ChannelOne /mux_tb/DUT/avsi_one_data
add wave -noupdate -expand -group ChannelOne /mux_tb/DUT/avsi_one_valid
add wave -noupdate -expand -group ChannelOne /mux_tb/DUT/avsi_one_sop
add wave -noupdate -expand -group ChannelOne /mux_tb/DUT/avsi_one_eop
add wave -noupdate -expand -group ChannelOne /mux_tb/DUT/avsi_one_empty
add wave -noupdate -expand -group ChannelOne /mux_tb/DUT/avsi_one_ready
add wave -noupdate -expand -group ChannelTwo -radix unsigned -childformat {{{/mux_tb/DUT/avsi_two_channel[7]} -radix unsigned} {{/mux_tb/DUT/avsi_two_channel[6]} -radix unsigned} {{/mux_tb/DUT/avsi_two_channel[5]} -radix unsigned} {{/mux_tb/DUT/avsi_two_channel[4]} -radix unsigned} {{/mux_tb/DUT/avsi_two_channel[3]} -radix unsigned} {{/mux_tb/DUT/avsi_two_channel[2]} -radix unsigned} {{/mux_tb/DUT/avsi_two_channel[1]} -radix unsigned} {{/mux_tb/DUT/avsi_two_channel[0]} -radix unsigned}} -subitemconfig {{/mux_tb/DUT/avsi_two_channel[7]} {-radix unsigned} {/mux_tb/DUT/avsi_two_channel[6]} {-radix unsigned} {/mux_tb/DUT/avsi_two_channel[5]} {-radix unsigned} {/mux_tb/DUT/avsi_two_channel[4]} {-radix unsigned} {/mux_tb/DUT/avsi_two_channel[3]} {-radix unsigned} {/mux_tb/DUT/avsi_two_channel[2]} {-radix unsigned} {/mux_tb/DUT/avsi_two_channel[1]} {-radix unsigned} {/mux_tb/DUT/avsi_two_channel[0]} {-radix unsigned}} /mux_tb/DUT/avsi_two_channel
add wave -noupdate -expand -group ChannelTwo /mux_tb/DUT/avsi_two_data
add wave -noupdate -expand -group ChannelTwo /mux_tb/DUT/avsi_two_valid
add wave -noupdate -expand -group ChannelTwo /mux_tb/DUT/avsi_two_sop
add wave -noupdate -expand -group ChannelTwo /mux_tb/DUT/avsi_two_eop
add wave -noupdate -expand -group ChannelTwo /mux_tb/DUT/avsi_two_empty
add wave -noupdate -expand -group ChannelTwo /mux_tb/DUT/avsi_two_ready
add wave -noupdate -group Output -radix unsigned /mux_tb/DUT/avso_channel
add wave -noupdate -group Output /mux_tb/DUT/avso_data
add wave -noupdate -group Output /mux_tb/DUT/avso_valid
add wave -noupdate -group Output /mux_tb/DUT/avso_sop
add wave -noupdate -group Output /mux_tb/DUT/avso_eop
add wave -noupdate -group Output /mux_tb/DUT/avso_empty
add wave -noupdate -group Output /mux_tb/DUT/avso_ready
add wave -noupdate /mux_tb/DUT/stream_one
add wave -noupdate -expand /mux_tb/DUT/stream_two
add wave -noupdate /mux_tb/DUT/state
add wave -noupdate /mux_tb/DUT/state_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1464810 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 165
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {2752120 ns}
