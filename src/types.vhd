library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
  type IQ_map_t is array (natural range <>) of std_logic_vector(31 downto 0);

  subtype float_t is std_logic_vector(31 downto 0);
end types;
