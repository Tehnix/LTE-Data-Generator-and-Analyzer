// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



module inverse_fft_fft_ii_0 (
   input clk, 
   input reset_n,
	input [7 : 0] fftpts_in,
	input	sink_valid,
	input	sink_sop,
	input	sink_eop,
	input	logic [31 : 0] sink_real,
	input	logic [31 : 0] sink_imag,
	input	logic [1 : 0] sink_error,
	input	source_ready,
   output [7 : 0] fftpts_out,
	output sink_ready,
	output [1 : 0] source_error,
	output source_sop,
	output source_eop,
	output source_valid,
	output [31 : 0] source_real,
	output [31 : 0] source_imag
	);

	apn_fftfprvs_top #(
		.DEVICE_FAMILY_g("Cyclone V"),
		.MAX_FFTPTS_g(128),
		.NUM_STAGES_g(4),
		.DATAWIDTH_g(32),
		.TWIDWIDTH_g(32),
		.MAX_GROW_g (0),
		.TWIDROM_BASE_g("inverse_fft_fft_ii_0_"),
		.DSP_ROUNDING_g(0),
		.INPUT_FORMAT_g("DIGIT_REVERSED"),
		.OUTPUT_FORMAT_g("NATURAL_ORDER"),
		.REPRESENTATION_g("FLOATPT"),
		.DSP_ARCH_g(0),
		.PRUNE_g("2,3,2,0") 
	)
	apn_fftfprvs_top_inst (
		.clk(clk),
		.reset_n(reset_n),
		.fftpts_in(fftpts_in),
		.fftpts_out(fftpts_out),
		.sink_valid(sink_valid),
		.sink_sop(sink_sop),
		.sink_eop(sink_eop),
		.sink_real(sink_real),
		.sink_imag(sink_imag),
		.sink_ready(sink_ready),
		.sink_error(sink_error),
		.source_error(source_error),
		.source_ready(source_ready),
		.source_sop(source_sop),
		.source_eop(source_eop),
		.source_valid(source_valid),
		.source_real(source_real),
		.source_imag(source_imag)
	);
endmodule




