library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity lte_signal_generator_test is
end entity;

architecture structural of lte_signal_generator_test is
  component clock
    generic (period : time);
    port (clk  : out std_logic := '0');
  end component;

  component lte_signal_generator
    port (clk    : in  std_logic;
          reset  : in  std_logic);
  end component;

  signal reset : std_logic;
  signal clk : std_logic;

begin
  -- reset is active-low
  reset <= '1', '0' after 57 ns;

  i_clock_0 : clock
    generic map (period => 80 ns)
    port map (clk  => clk);

  i_lte_signal_generator_0 : lte_signal_generator
    port map (clk    => clk,
              reset  => reset);
end architecture;
