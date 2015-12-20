library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity clock is
  generic (period : time := 50 ns);
  port (clk_gsg    : out std_logic := '0';
        clk        : out std_logic := '0';
        clk_1_4mhz : out std_logic := '0');
end entity;

architecture behaviour of clock is
begin

  process
  begin
    clk_gsg <= '1', '0' after period / 2;
    wait for period;
  end process;

  process
  begin
    clk <= '1', '0' after period * QAM64_BITS / 2;
    wait for period * QAM64_BITS;
  end process;

  process
  begin
    clk_1_4mhz <= '1', '0' after period * 10 / 2;
    wait for period * 10;
  end process;

end architecture;
