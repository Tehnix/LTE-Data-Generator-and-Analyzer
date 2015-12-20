library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity gold_sequence_generator is
  generic (polynomial_degree_g : integer;
           polynomial_0_g      : polynomial_t;
           polynomial_1_g      : polynomial_t;
           sequence_width_g    : integer);
  port (clk              : in  std_logic;
        reset            : in  std_logic;
        halt             : in  std_logic;
        bit_sequence_out : out std_logic_vector(sequence_width_g - 1 downto 0));
end entity;

architecture behavior of gold_sequence_generator is

  component pseudo_noise_sequence_generator
    generic (polynomial_degree_g : integer;
             polynomial_g        : polynomial_t);
    port (clk      : in  std_logic;
          reset    : in  std_logic;
          halt     : in  std_logic;
          data_out : out std_logic);
  end component;

  --
  signal next_delay_counter, delay_counter :
    unsigned(sequence_width_g / 2 - 1 downto 0);

  signal pn_0_data_out : std_logic;
  signal pn_1_data_out : std_logic;

  signal bit_sequence, next_bit_sequence,
    buffered_bit_sequence, next_buffered_bit_sequence :
    std_logic_vector(sequence_width_g - 1 downto 0);

begin

  bit_sequence_out <= buffered_bit_sequence;

  process (delay_counter, halt, bit_sequence, buffered_bit_sequence,
           pn_0_data_out, pn_1_data_out)
    variable data_out : std_logic := '0';
  begin
    next_delay_counter <= delay_counter + 1;

    data_out          := pn_0_data_out xor pn_1_data_out;
    next_bit_sequence <= bit_sequence(sequence_width_g - 2 downto 0) & data_out;

    next_buffered_bit_sequence <= buffered_bit_sequence;

    -- Hold the current value until a new set of bits are generated defined by
    -- the modulation width.
    if delay_counter = sequence_width_g - 1 then
      next_buffered_bit_sequence <= bit_sequence;
      next_delay_counter         <= (others => '0');
    end if;

    if halt = '1' then
      next_bit_sequence  <= bit_sequence;
      next_delay_counter <= delay_counter;
    end if;
  end process;

  process (clk, reset)
  begin
    if reset = '1' then
      bit_sequence          <= (others => '0');
      delay_counter         <= (others => '0');
      buffered_bit_sequence <= (others => '0');
    elsif rising_edge(clk) then
      buffered_bit_sequence <= next_buffered_bit_sequence;
      bit_sequence          <= next_bit_sequence;
      delay_counter         <= next_delay_counter;
    end if;
  end process;

  i_pn_0 : pseudo_noise_sequence_generator
    generic map (polynomial_degree_g => polynomial_degree_g,
                 polynomial_g        => polynomial_0_g)
    port map (clk      => clk,
              reset    => reset,
              halt     => halt,
              data_out => pn_0_data_out);

  i_pn_1 : pseudo_noise_sequence_generator
    generic map (polynomial_degree_g => polynomial_degree_g,
                 polynomial_g        => polynomial_1_g)
    port map (clk      => clk,
              reset    => reset,
              halt     => halt,
              data_out => pn_1_data_out);

end architecture;
