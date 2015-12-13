set signals [list]

# Clock
lappend signals i_clock_0.clk
lappend signals i_lte_signal_generator_0.reset

# MSRG register 1 and 2
lappend signals i_lte_signal_generator_0.i_noise_0.pseudo_reg_1
lappend signals i_lte_signal_generator_0.i_noise_0.pseudo_reg_2

gtkwave::addSignalsFromList $signals

gtkwave::setZoomRangeTimes 0ns 5000ns
