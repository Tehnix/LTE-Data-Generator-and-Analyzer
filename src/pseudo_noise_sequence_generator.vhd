library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity pseudo_noise_sequence_generator is
  generic (polynomial_degree_g : integer;
           polynomial_g        : polynomial_t);
  port (clk      : in  std_logic;
        reset    : in  std_logic;
        halt     : in  std_logic;
        data_out : out std_logic);
end entity;

architecture behavior of pseudo_noise_sequence_generator is
  -- The linear-feedback shift register is initialised with the initial state
  signal next_lfsr_reg, lfsr_reg :
    std_logic_vector(polynomial_degree_g - 1 downto 0);

begin

  process (lfsr_reg, halt)
    variable lfsr_in : std_logic;
  begin
    -- Take the output of the LFSR as the starting point of the new input
    lfsr_in := lfsr_reg(0);
    -- XOR the input with all the taps, defined by the polynomial
    for i in polynomial_degree_g - 1 downto 1 loop
      if polynomial_g(i - 1) = '1' then
        lfsr_in := lfsr_in xor lfsr_reg(i - 1);
      end if;
    end loop;

    -- Shift the register, appending the new input
    next_lfsr_reg <= lfsr_reg(polynomial_degree - 2 downto 0) & lfsr_in;

    if halt = '1' then
      next_lfsr_reg <= lfsr_reg;
    end if;
  end process;

  process (clk, reset)
  begin
    if reset = '1' then
      lfsr_reg <= polynomial_g(polynomial_g'high downto 1);
    elsif rising_edge(clk) then
      lfsr_reg <= next_lfsr_reg;
    end if;
  end process;

  -- The output of the LFSR will always be the last bit in the LFSR (we shift
  -- from right towards left)
  data_out <= lfsr_reg(0);

end architecture;
