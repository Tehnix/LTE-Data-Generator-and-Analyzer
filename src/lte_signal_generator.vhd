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

  component iq_mapper is
    generic (sample_map_g       : iq_map_t;
             modulation_width_g : integer);
    port (bit_sequence : in  std_logic_vector(modulation_width_g - 1 downto 0);
          i            : out std_logic_vector(31 downto 0);
          q            : out std_logic_vector(31 downto 0));
  end component;

  component inverse_fft is
    port (clk          : in  std_logic                     := 'X';
          reset_n      : in  std_logic                     := 'X';
          sink_valid   : in  std_logic                     := 'X';
          sink_ready   : out std_logic;
          sink_error   : in  std_logic_vector(1 downto 0)  := (others => 'X');
          sink_sop     : in  std_logic                     := 'X';
          sink_eop     : in  std_logic                     := 'X';
          sink_real    : in  std_logic_vector(31 downto 0) := (others => 'X');
          sink_imag    : in  std_logic_vector(31 downto 0) := (others => 'X');
          fftpts_in    : in  std_logic_vector(7 downto 0)  := (others => 'X');
          source_valid : out std_logic;
          source_ready : in  std_logic                     := 'X';
          source_error : out std_logic_vector(1 downto 0);
          source_sop   : out std_logic;
          source_eop   : out std_logic;
          source_real  : out std_logic_vector(31 downto 0);
          source_imag  : out std_logic_vector(31 downto 0);
          fftpts_out   : out std_logic_vector(7 downto 0));
  end component;

  component noisifier is
    port (clk    : in  std_logic;
          reset  : in  std_logic;
          enable : in  std_logic;
          i_in   : in  std_logic_vector(31 downto 0);
          q_in   : in  std_logic_vector(31 downto 0);
          i_out  : out std_logic_vector(31 downto 0);
          q_out  : out std_logic_vector(31 downto 0));
  end component;

  constant SEQUENCE_WIDTH : integer := QAM64_BITS;

  signal i, i_noise, q, q_noise : std_logic_vector(31 downto 0);

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

  i_inverse_fft_0 : inverse_fft
    port map (clk          => clk_1_4mhz,
              reset_n      => reset,
              sink_valid   => tx_controller_out_valid,
              sink_ready   => tx_controller_out_ready,
              sink_error   => tx_controller_out_error,
              sink_sop     => tx_controller_out_sop,
              sink_eop     => tx_controller_out_eop,
              sink_real    => freq_i,
              sink_imag    => freq_q,
              fftpts_in    => open,
              source_valid => tx_controller_valid,
              source_ready => tx_controller_ready,
              source_error => tx_controller_error,
              source_sop   => tx_controller_in_sop,
              source_eop   => tx_controller_in_eop,
              source_real  => time_i,
              source_imag  => time_q,
              fftpts_out   => open);

  -- Should be mapped to output of iFFT
  i_noise_0 : noisifier
  port map (clk    => clk,
            reset  => reset,
            enable => buffer_enable,
            i_in   => i,
            q_in   => q,
            i_out  => i_noise,
            q_out  => q_noise);

end architecture;
