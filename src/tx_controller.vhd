library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_controller is
  generic ()
  port (clk         : in  std_logic;
        reset       : in  std_logic;
        transmit_fifo_full   : in  std_logic;
        halt        : out  std_logic);
end entity;

architecture fsmd of tx_controller is

begin

  process (transmit_fifo_full)
  begin
    halt <= '1';
  end process;

  process (clk, reset)
  begin
    if reset = '1' then
      subcarrier_counter <= (others => '0');
      state              <= lhs_guard;
    elsif rising_edge(clk) then
      subcarrier_counter <= next_subcarrier_counter;
    end if;
  end process;

end architecture;
