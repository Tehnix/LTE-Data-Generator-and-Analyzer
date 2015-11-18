.DEFAULT_GOAL := all
all: analyse compile simulate wave

GHDL ?= ghdl
GTKWAVE ?= gtkwave

analyse:
	$(GHDL) -i --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work src/*.vhd tests/lte_signal_generator_test.vhd

compile:
	$(GHDL) -m --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work bin/testbench

simulate:
	./bin/testbench --stop-time=500ns --vcdgz=simulation_results.vcdgz

wave: simulate
	gunzip --stdout simulation_results.vcdgz | $(GTKWAVE) --vcd
