library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subcarrier_controller is
  generic (total_subcarriers : integer;
           active_subcarriers : integer);
  port (clk         : in  std_logic;
        reset       : in  std_logic;
        halt : in std_logic;
        data_enable : out std_logic);
end entity;

architecture fsmd of subcarrier_controller is
  type state_t is (lhs_guard, data, rhs_guard);

  signal state, next_state : state_t;

  signal subcarrier_counter, next_subcarrier_counter :
    unsigned(total_subcarriers downto 0);

  constant GUARD_BOUNDARY : integer :=
    (total_subcarriers - active_subcarriers) / 2;
  constant DATA_BOUNDARY : integer :=
    active_subcarriers;
begin

  process (state, subcarrier_counter, halt)
  begin
    data_enable <= '0';
    next_subcarrier_counter <= subcarrier_counter + 1;

    case state is
      -- Zero padding
      when lhs_guard =>

        if subcarrier_counter = GUARD_BOUNDARY then
          next_subcarrier_counter <= (others => '0');

          data_enable <= '1';

          next_state <= data;
        end if;

      -- Resource block
      when data =>
        data_enable <= '1';

        if subcarrier_counter = DATA_BOUNDARY then
          next_subcarrier_counter <= (others => '0');

          next_state <= rhs_guard;
        end if;

      -- Zero padding
      when rhs_guard =>

        if subcarrier_counter = GUARD_BOUNDARY then
          next_subcarrier_counter <= (others => '0');

          next_state <= lhs_guard;
        end if;
    end case;

    if halt = '1' then
      next_subcarrier_counter <= subcarrier_counter;
      data_enable <= '0';
    end if;
  end process;

  process (clk, reset)
  begin
    if reset = '1' then
      subcarrier_counter <= (others => '0');
      state <= lhs_guard;
    elsif rising_edge(clk) then
      subcarrier_counter <= next_subcarrier_counter;
    end if;
  end process;

end architecture;
