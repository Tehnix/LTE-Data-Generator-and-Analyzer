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
  signal even, odd :
    std_logic_vector(modulation_width_g / 2 - 1 downto 0) := (others => '0');
begin

  process (bit_sequence)
    variable even_v, odd_v :
      std_logic_vector(modulation_width_g / 2 - 1 downto 0) := (others => '0');

    variable j, k : integer;
  begin
    j := 0;
    k := 0;

    while (j <= modulation_width_g / 2) loop
      even_v(k) := bit_sequence(j);
      odd_v(k)  := bit_sequence(j + 1);

      j := j + 2;
      k := k + 1;
    end loop;

    even <= even_v;
    odd  <= odd_v;
  end process;

  i <= IQ_map(to_integer(unsigned(even)));
  q <= IQ_map(to_integer(unsigned(odd)));

end architecture;
