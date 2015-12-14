all: generator_gtkwave

GHDL ?= ghdl
GTKWAVE ?= gtkwave
SHARELATEX_DIR = $(HOME)/Dropbox/sharelatex/LTE\ Data\ Generator/src

analyse:
	$(GHDL) -i \
	        --ieee=synopsys \
	        --warn-no-vital-generic \
	        --workdir=simu \
	        --work=work \
	src/types.vhd \
	src/constants.vhd \
	src/clock.vhd \
	src/noisifier.vhd \
	src/msrg.vhd \
	src/pseudo_noise_sequence_generator.vhd \
	src/gold_sequence_generator.vhd \
	src/data_buffer.vhd \
	src/iq_mapper.vhd \
	src/functions.vhd \
	src/cyclic_prefix.vhd \
	src/subcarrier_controller.vhd \
	src/inverse_fft/synthesis/inverse_fft.vhd \
	src/tx_fifo.vhd \
	tests/lte_signal_generator_test.vhd

compile:
	$(GHDL) -m --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work lte_signal_generator_test

# Generator/transmitter tasks
generator: analyse compile
	./lte_signal_generator_test --stop-time=5000ns --vcdgz=simulation_results.vcdgz

generator_gtkwave: generator
	gunzip --stdout simulation_results.vcdgz | $(GTKWAVE) --vcd --script signals.tcl

# Receiver tasks, if needed
receiver: analyse compile
	./lte_signal_receiver_test --stop-time=5000ns --vcdgz=simulation_results.vcdgz

receiver_gtkwave: receiver
	gunzip --stdout simulation_results.vcdgz | $(GTKWAVE) --vcd

sharelatex:
	rm -f -r $(SHARELATEX_DIR)
	mkdir -p $(shell echo "$(SHARELATEX_DIR)/{vhdl,matlab,python}")
	cp src/*.vhd $(SHARELATEX_DIR)/vhdl
	cp tests/*.vhd $(SHARELATEX_DIR)/vhdl
	cp src/matlab/*.m $(SHARELATEX_DIR)/matlab
	cp src/python/*.py $(SHARELATEX_DIR)/python
