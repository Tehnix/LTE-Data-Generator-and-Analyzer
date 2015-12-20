quit -sim

vcom -check_synthesis src/types.vhd \
	src/constants.vhd \
	src/functions.vhd \
	src/simulation/clock.vhd \
	src/pseudo_noise_sequence_generator.vhd \
	src/gold_sequence_generator.vhd \
	src/subcarrier_controller.vhd \
	src/iq_mapper.vhd \
	src/lte_signal_generator.vhd \
	tests/lte_signal_generator_test.vhd

vsim lte_signal_generator_test

restart -force -nowave

add wave -label "Reset" -noupdate /lte_signal_generator_test/reset
add wave -label "Clock GSG" -noupdate /lte_signal_generator_test/clk_gsg
add wave -label "Clock" -noupdate /lte_signal_generator_test/clk
add wave -label "1.4MHz Clock" -noupdate /lte_signal_generator_test/clk_1_4mhz

add wave -noupdate -divider -height 28 "GSG"

add wave -label "Internal Bit Sequence" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_gsg_0/bit_sequence
add wave -label "Bit Sequence Out" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_gsg_0/bit_sequence_out

add wave -noupdate -divider -height 28 "Subcarrier Controller"

add wave -label "Bit Sequence In" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/bit_sequence
add wave -label "State" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/state
add wave -label "Counter" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/subcarrier_counter
add wave -label "SOP" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/start_of_packet
add wave -label "EOP" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/end_of_packet
add wave -label "IQ Mapper Enable" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/iq_mapper_enable
add wave -label "I" -radix float32 -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/i
add wave -label "Q" -radix float32 -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/q

add wave -noupdate -divider -height 28 "IQ Mapper"

add wave -label "Even Index" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/i_iq_mapper_qam64/even
add wave -label "Odd Index" -noupdate /lte_signal_generator_test/i_lte_signal_generator_0/i_subcarrier_controller_0/i_iq_mapper_qam64/odd

WaveRestoreZoom {0 ps} {100000 ns}

run 100000 ns
