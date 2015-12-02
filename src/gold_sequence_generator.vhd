library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity gold_sequence_generator is
  generic (sequence_width_g : integer);
  port (clk            : in  std_logic;
        reset          : in  std_logic;
        control_signal : in  std_logic;
        buffer_enable  : out std_logic;
        bit_sequence   : out std_logic_vector(sequence_width_g - 1 downto 0));
end entity;

architecture behavior of gold_sequence_generator is

  component pseudo_noise_sequence_generator
    generic (polynomial : std_logic_vector(POLYNOMIAL_DEGREE downto 0));
    port (clk            : in std_logic;
          reset          : in std_logic;
          control_signal : in std_logic;
          data_out       : out std_logic);
  end component;

  signal lfsr_reg : std_logic_vector(31 downto 0);

  signal next_delay_counter, delay_counter :
    unsigned(sequence_width_g / 2 - 1 downto 0);

  signal pn1_data_out : std_logic;

  signal pn2_data_out : std_logic;

begin

  pn1 : pseudo_noise_sequence_generator
  generic map (polynomial => PN1_POLYNOMIAL)
  port map (clk            => clk,
            reset          => reset,
            control_signal => control_signal,
            data_out       => pn1_data_out);

  pn2 : pseudo_noise_sequence_generator
  generic map (polynomial => PN2_POLYNOMIAL)
  port map (clk            => clk,
            reset          => reset,
            control_signal => control_signal,
            data_out       => pn2_data_out);

  process (delay_counter)
  begin
    buffer_enable <= '0';
    next_delay_counter <= delay_counter + 1;

    if delay_counter = sequence_width_g - 1 then
      buffer_enable <= '1';
      next_delay_counter <= (others => '0');
    end if;
  end process;

  process (clk, reset, control_signal)
  begin
    if reset = '1' then
      delay_counter <= (others => '0');
    elsif rising_edge(clk) and control_signal = '1' then
      -- Combine the two Pseudo Noise (PN) sequence generators
      delay_counter <= next_delay_counter;
    end if;
  end process;

  bit_sequence <= lfsr_reg(lfsr_reg'high downto lfsr_reg'high - (sequence_width_g - 1));

end architecture;

