set_global_assignment -entity "clock_source" -library "lib_clock_source" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clock_source" -library "lib_clock_source" -name IP_TOOL_VERSION "15.0"
set_global_assignment -entity "clock_source" -library "lib_clock_source" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clock_source" -name SPD_FILE [file join $::quartus(sip_path) "clock_source.spd"]

set_global_assignment -library "lib_clock_source" -name MISC_FILE [file join $::quartus(sip_path) "clock_source_sim/clock_source.vho"]
