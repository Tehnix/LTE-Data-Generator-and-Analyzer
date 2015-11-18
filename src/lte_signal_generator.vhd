library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
use work.types.all;

entity lte_signal_generator is
  port (clk   : in std_logic;
        reset : in std_logic);
end entity;

architecture structural of lte_signal_generator is
  component pseudo_random_bit_sequence is
    generic (sequence_width_g : integer);
    port (clk           : in  std_logic;
          reset         : in  std_logic;
          buffer_enable : out std_logic;
          bit_sequence  : out std_logic_vector(sequence_width_g - 1 downto 0));
  end component;

  component data_buffer is
    generic (data_width_g : integer);
    port (clk      : in  std_logic;
          enable   : in  std_logic;
          data_in  : in  std_logic_vector(data_width_g - 1 downto 0);
          data_out : out std_logic_vector(data_width_g - 1 downto 0));
  end component;

  component iq_mapper
    generic (sample_map_g       : iq_map_t;
             modulation_width_g : integer);
    port (bit_sequence : in  std_logic_vector(modulation_width_g - 1 downto 0);
          i            : out std_logic_vector(31 downto 0);
          q            : out std_logic_vector(31 downto 0));
  end component;

  constant SEQUENCE_WIDTH : integer := QAM64_BITS;

  signal i, q : std_logic_vector(31 downto 0);

  signal buffer_enable : std_logic;

  signal bit_sequence, buffered_bit_sequence :
    std_logic_vector(SEQUENCE_WIDTH - 1 downto 0);

begin

  i_prbs_0 : pseudo_random_bit_sequence
    generic map (sequence_width_g => SEQUENCE_WIDTH)
    port map (clk           => clk,
              reset         => reset,
              buffer_enable => buffer_enable,
              bit_sequence  => bit_sequence);

  i_buffer_0 : data_buffer
    generic map (data_width_g => SEQUENCE_WIDTH)
    port map (clk      => clk,
              enable   => buffer_enable,
              data_in  => bit_sequence,
              data_out => buffered_bit_sequence);

  i_iq_mapper_qam64 : iq_mapper
    generic map (sample_map_g       => QAM64_IQ_MAP,
                 modulation_width_g => SEQUENCE_WIDTH)
    port map (bit_sequence => buffered_bit_sequence,
              i            => i,
              q            => q);
end architecture;
