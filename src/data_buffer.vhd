library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity data_buffer is
  generic (data_width_g : integer);
  port (clk : in std_logic;
        enable   : in std_logic;
        data_in  : in  std_logic_vector(data_width_g - 1 downto 0);
        data_out : out std_logic_vector(data_width_g - 1 downto 0));
end entity;

architecture behaviorial of data_buffer is
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if enable = '1' then
        data_out <= data_in;
      end if;
    end if;
  end process;

end architecture;
