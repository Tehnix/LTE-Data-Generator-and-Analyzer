transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib inverse_fft
vmap inverse_fft inverse_fft
vlog -sv -work inverse_fft +incdir+/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/inverse_fft/synthesis/submodules {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/inverse_fft/synthesis/submodules/inverse_fft_fft_ii_0.sv}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/functions.vhd}
vcom -93 -work inverse_fft {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/inverse_fft/synthesis/inverse_fft.vhd}
vcom -93 -work inverse_fft {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/inverse_fft/synthesis/submodules/auk_dspip_math_pkg.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/types.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/digit_reverter.vhd}
vcom -93 -work inverse_fft {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/inverse_fft/synthesis/submodules/auk_dspip_lib_pkg.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/iq_mapper.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/constants.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/subcarrier_controller.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/pseudo_noise_sequence_generator.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/lte_signal_generator.vhd}
vcom -93 -work work {/media/sf_martinjlowm/Dropbox/Documents/34349_fpga_design_for_communication_systems/lte_data_generator_analyzer/src/gold_sequence_generator.vhd}

