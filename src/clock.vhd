library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is
  generic (period : time := 50 ns);
  port (clk : out std_logic := '0');
end entity;

architecture behaviour of clock is
  signal clock_counter : unsigned(2 downto 0);
begin

  process
  begin
    clk <= '1', '0' after period / 2;
    wait for period;
  end process;

end architecture;
