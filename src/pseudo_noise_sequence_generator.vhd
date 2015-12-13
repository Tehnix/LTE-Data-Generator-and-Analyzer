library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity pseudo_noise_sequence_generator is
  generic (polynomial : std_logic_vector(POLYNOMIAL_DEGREE downto 0);
           initial_state : std_logic_vector(POLYNOMIAL_DEGREE-1 downto 0));
  port (clk            : in  std_logic;
        reset          : in  std_logic;
        control_signal : in  std_logic;
        data_out       : out std_logic);
end entity;

architecture behavior of pseudo_noise_sequence_generator is
  -- The linear-feedback shift register is initialised with the initial state
  signal lfsr_reg
    : std_logic_vector(POLYNOMIAL_DEGREE-1 downto 0) := initial_state;

begin

  process (clk, reset)
    variable lfsr_in : std_logic;
  begin
    if reset = '1' then
      -- Reset the LFSR to the initial state
      lfsr_reg <= initial_state;
    elsif rising_edge(clk) then
      -- Take the output of the LFSR as the starting point of the new input
      lfsr_in := lfsr_reg(0);
      -- XOR the input with all the taps, defined by the polynomial
      for i in POLYNOMIAL_DEGREE-1 downto 1 loop
        if polynomial(i-1) = '1' then
          lfsr_in := lfsr_in xor lfsr_reg(i-1);
        end if;
      end loop;
      -- Shift the register, appending the new input
      lfsr_reg <= lfsr_reg(POLYNOMIAL_DEGREE-2 downto 0) & lfsr_in;
    end if;
  end process;

  -- The output of the LFSR will always be the last bit in the LFSR (we shift
  -- from right towards left)
  data_out <= lfsr_reg(0);

end architecture;

