library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity digit_reverter is
  port (i, q                   : in  float_t;
        i_reverted, q_reverted : out float_t);
end entity;

architecture behavioral of digit_reverter is
begin

  process (i, q)
    variable i_reverted_tmp, q_reverted_tmp : float_t;
  begin
    for j in i'RANGE loop
      i_reverted_tmp(j) := i(i'high - j);
      q_reverted_tmp(j) := q(q'high - j);
    end loop;

    i_reverted <= i_reverted_tmp;
    q_reverted <= q_reverted_tmp;
  end process;

end architecture;
