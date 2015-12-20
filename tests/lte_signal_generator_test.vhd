library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity lte_signal_generator_test is
end entity;

architecture structural of lte_signal_generator_test is
  component clock
    generic (period : time);
    port (clk_gsg    : out std_logic;
          clk        : out std_logic;
          clk_1_4mhz : out std_logic);
  end component;

  component lte_signal_generator
    port (clk_gsg    : in  std_logic;
          clk        : in  std_logic;
          clk_1_4mhz : in  std_logic;
          reset      : in  std_logic;
          start      : in  std_logic;
          complete   : out std_logic);
  end component;

  signal clk_gsg   : std_logic;
  signal clk       : std_logic;
  signal clk_1_4mhz : std_logic;

  signal reset    : std_logic;
  signal start    : std_logic := '1';
  signal complete : std_logic;

begin
  -- reset is active-low
  reset <= '1', '0' after 57 ns;

  i_clock_0 : clock
    generic map (period => 80 ns)
    port map (clk_gsg    => clk_gsg,
              clk        => clk,
              clk_1_4mhz => clk_1_4mhz);

  i_lte_signal_generator_0 : lte_signal_generator
    port map (clk_gsg    => clk_gsg,
              clk        => clk,
              clk_1_4mhz => clk_1_4mhz,
              reset      => reset,
              start      => start,
              complete   => complete);
end architecture;
