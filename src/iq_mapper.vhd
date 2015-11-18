library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iq_mapper is
  generic (sample_map : IQ_map_t;
           seq_length : integer);
  port (clk : in std_logic := 'X';      -- clk
        bit_sequence : in std_logic_vector(seq_length downto 0);
        i : out std_logic_vector(31 downto 0);
        q : out std_logic_vector(31 downto 0));
end entity;

architecture behaviorial of iq_mapper is
  constant IQ_map : IQ_map_t := sample_map;
  signal even, odd : std_logic_vector(seq_length / 2 downto 0);
begin

  process (bit_sequence)
  begin
    even_v := bit_sequence(0);
    odd_v := bit_sequence(1);
    for i in 2 to seq_length / 2 loop
      even_v := even_v & bit_sequence(i);
      odd_v := odd_v & bit_sequence(i + 1);

      i := i + 1;
    end loop;

    even <= even_v;
    odd <= odd_v;
  end process;

  process (clk, reset)
  begin
    if reset = '1' then
      counter <= (others => '0');
    elsif rising_edge(clk) then
      counter <= counter + 1;

      if counter = 4 then
        i <= sample_map(even);
        q <= sample_map(odd);
        counter <= 0;
      end if;
    end if;
  end process;

end architecture;
