library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity pseudo_noise_sequence_generator is
  generic (polynomial : std_logic_vector(POLYNOMIAL_DEGREE downto 0));
  port (clk            : in  std_logic;
        reset          : in  std_logic;
        control_signal : in  std_logic;
        data_out       : out std_logic);
end entity;

architecture behavior of pseudo_noise_sequence_generator is
  signal lfsr_reg : std_logic_vector(31 downto 0);
begin

  process (clk, reset)
    variable lfsr_tap : std_logic;
  begin
    if reset = '1' then
      lfsr_reg <= (others => '1');
    elsif rising_edge(clk) then
      lfsr_tap := lfsr_reg(0) xor lfsr_reg(1) xor lfsr_reg(21) xor lfsr_reg(31);
      lfsr_reg <= lfsr_reg(30 downto 0) & lfsr_tap;
    end if;
  end process;

  data_out <= '0';

end architecture;

