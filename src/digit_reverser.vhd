library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity digit_reverser is
  port (i, q                   : in  std_logic_vector(31 downto 0);
        i_reverted, q_reverted : out std_logic_vector(31 downto 0));
end entity;

architecture behavioral of digit_reverser is
begin

  process (i, q)
    variable i_reverted_tmp, q_reverted_tmp : std_logic_vector(31 downto 0);
  begin
    for j in i'RANGE loop
      i_reverted_tmp(j) := i(j);
      q_reverted_tmp(j) := q(j);
    end loop;

    i_reverted <= i_reverted_tmp;
    q_reverted <= q_reverted_tmp;
  end process;

end architecture;
