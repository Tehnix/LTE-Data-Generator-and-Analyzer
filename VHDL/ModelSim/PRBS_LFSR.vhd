library ieee;
use ieee.std_logic_1164.all;

entity prbs is
port (
  prbs_clk : in std_logic;
  rset     : in std_logic;
  prbs_out : out std_logic_vector(31 downto 0)
);
end prbs;

architecture behavior of prbs is
  signal lfsr_reg : std_logic_vector(31 downto 0);

begin
  process(prbs_clk)
    variable lfsr_tap : std_ulogic;
  begin
    if prbs_clk'EVENT and prbs_clk = '1' then
      if rset = '1' then
        lfsr_reg <= (others => '1');
      else
        lfsr_tap := lfsr_reg(0) xor lfsr_reg(1) xor lfsr_reg(21) xor lfsr_reg(31);
        lfsr_reg <= lfsr_reg(30 downto 0) & lfsr_tap;
      end if;
    end if;
  end process;
prbs_out <= lfsr_reg;
end behavior;


