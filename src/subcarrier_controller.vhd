library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.constants.all;
use work.functions.all;

entity subcarrier_controller is
  generic (total_subcarriers  : integer;
           active_subcarriers : integer;
           modulation_width_g : integer);
  port (clk             : in  std_logic;
        reset           : in  std_logic;
        halt            : in  std_logic;
        bit_sequence    : in  std_logic_vector(modulation_width_g - 1 downto 0);
        start_of_packet : out std_logic;
        i               : out std_logic_vector(31 downto 0);
        q               : out std_logic_vector(31 downto 0);
        end_of_packet   : out std_logic);
end entity;

architecture fsmd of subcarrier_controller is
  type state_t is (lhs_guard, data, rhs_guard);

  component iq_mapper is
    generic (sample_map_g       : iq_map_t;
             modulation_width_g : integer);
    port (bit_sequence : in  std_logic_vector(modulation_width_g - 1 downto 0);
          enable       : in  std_logic;
          i            : out std_logic_vector(31 downto 0);
          q            : out std_logic_vector(31 downto 0));
  end component;

  signal state, next_state : state_t;

  signal iq_mapper_enable : std_logic;

  signal subcarrier_counter, next_subcarrier_counter :
    unsigned(log2(total_subcarriers) downto 0);

  constant GUARD_BOUNDARY : integer :=
    (total_subcarriers - active_subcarriers) / 2;
  constant DATA_BOUNDARY : integer :=
    active_subcarriers;
begin

  process (state, subcarrier_counter, halt)
  begin
    iq_mapper_enable        <= '0';
    next_subcarrier_counter <= subcarrier_counter + 1;
    next_state              <= state;
    start_of_packet <= '0';
    end_of_packet <= '0';

    case state is
      -- Zero padding
      when lhs_guard =>
        if subcarrier_counter = 0 then
          start_of_packet <= '1';
        end if;

        if subcarrier_counter = GUARD_BOUNDARY then
          next_subcarrier_counter <= (others => '0');

          iq_mapper_enable <= '1';

          next_state <= data;
        end if;

      -- Resource block
      when data =>
        iq_mapper_enable <= '1';

        if subcarrier_counter = DATA_BOUNDARY then
          next_subcarrier_counter <= (others => '0');

          next_state <= rhs_guard;
        end if;

      -- Zero padding
      when rhs_guard =>

        if subcarrier_counter = GUARD_BOUNDARY then
          end_of_packet <= '1';

          next_subcarrier_counter <= (others => '0');

          next_state <= lhs_guard;
        end if;
    end case;

    if halt = '1' then
      next_subcarrier_counter <= subcarrier_counter;
      iq_mapper_enable        <= '0';
    end if;
  end process;

  process (clk, reset)
  begin
    if reset = '1' then
      subcarrier_counter <= (others => '0');
      state              <= lhs_guard;
    elsif rising_edge(clk) then
      subcarrier_counter <= next_subcarrier_counter;
      state              <= next_state;
    end if;
  end process;

  i_iq_mapper_qam64 : iq_mapper
    generic map (sample_map_g       => QAM64_IQ_MAP,
                 modulation_width_g => modulation_width_g)
    port map (bit_sequence => bit_sequence,
              enable       => iq_mapper_enable,
              i            => i,
              q            => q);

end architecture;
