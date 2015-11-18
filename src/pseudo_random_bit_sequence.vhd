library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pseudo_random_bit_sequence is
  generic (sequence_width_g : integer);
  port (clk          : in  std_logic;
        reset        : in  std_logic;
        buffer_enable : out  std_logic;
        bit_sequence : out std_logic_vector(sequence_width_g - 1 downto 0));
end entity;

architecture behavior of pseudo_random_bit_sequence is
  signal lfsr_reg : std_logic_vector(31 downto 0);

  signal next_delay_counter, delay_counter :
    unsigned(sequence_width_g / 2 - 1 downto 0);
begin

  process (delay_counter)
  begin
    buffer_enable <= '0';
    next_delay_counter <= delay_counter + 1;

    if delay_counter = sequence_width_g - 1 then
      buffer_enable <= '1';
      next_delay_counter <= (others => '0');
    end if;
  end process;

  process (clk, reset)
    variable lfsr_tap : std_logic;
  begin
    if reset = '1' then
      lfsr_reg <= (others => '1');
      delay_counter <= (others => '0');
    elsif rising_edge(clk) then
      lfsr_tap := lfsr_reg(0) xor lfsr_reg(1) xor lfsr_reg(21) xor lfsr_reg(31);
      lfsr_reg <= lfsr_reg(30 downto 0) & lfsr_tap;
      delay_counter <= next_delay_counter;
    end if;
  end process;

  bit_sequence <= lfsr_reg(lfsr_reg'high downto lfsr_reg'high - (sequence_width_g - 1));

end architecture;
