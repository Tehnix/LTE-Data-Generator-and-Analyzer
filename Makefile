.DEFAULT_GOAL := all
all: analyse compile simulate wave

GHDL ?= ghdl
GTKWAVE ?= gtkwave

analyse:
	$(GHDL) -i \
	        --ieee=synopsys \
	        --warn-no-vital-generic \
	        --workdir=simu \
	        --work=work \
	src/types.vhd \
	src/constants.vhd \
	src/clock.vhd \
	src/pseudo_noise_sequence_generator.vhd \
	src/gold_sequence_generator.vhd \
	src/data_buffer.vhd \
	src/iq_mapper.vhd \
	tests/lte_signal_generator_test.vhd

compile:
	$(GHDL) -m --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work lte_signal_generator_test

simulate:
	./lte_signal_generator_test --stop-time=5000ns --vcdgz=simulation_results.vcdgz

wave: simulate
	gunzip --stdout simulation_results.vcdgz | $(GTKWAVE) --vcd
