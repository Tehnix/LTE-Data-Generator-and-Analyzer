library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity iq_mapper is
  generic (sample_map_g       : IQ_map_t;
           modulation_width_g : integer);
  port (bit_sequence : in  std_logic_vector(modulation_width_g - 1 downto 0);
        i            : out std_logic_vector(31 downto 0);
        q            : out std_logic_vector(31 downto 0));
end entity;

architecture behaviorial of iq_mapper is
  constant IQ_map  : IQ_map_t := sample_map_g;
  signal even, odd : std_logic_vector(modulation_width_g / 2 - 1 downto 0);
begin

  process (bit_sequence)
    variable even_v, odd_v : std_logic_vector(modulation_width_g / 2 - 1 downto 0);
    variable i, j             : integer;
  begin
    i := 0;
    j := 0;
    while (i <= modulation_width_g / 2) loop
      even_v(j) := bit_sequence(i);
      odd_v(j)  := bit_sequence(i + 1);

      i := i + 2;
      j := j + 1;
    end loop;

    even <= even_v;
    odd  <= odd_v;
  end process;

  i <= IQ_map(to_integer(unsigned(even)));
  q <= IQ_map(to_integer(unsigned(odd)));

end architecture;
