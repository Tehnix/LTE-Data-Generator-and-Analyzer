library ieee;
use ieee.std_logic_1164.all;

entity prbs is
port (
  prbs_clk : in std_logic;
  rset     : in std_logic;
  prbs_out : out std_logic_vector(19 downto 0)
);
end prbs;

architecture behavior of prbs is
  signal lfsr_reg : std_logic_vector(19 downto 0);

begin
  process(prbs_clk)
    variable lfsr_tap : std_ulogic;
  begin
    if prbs_clk'EVENT and prbs_clk = '1' then
      if rset = '1' then
        lfsr_reg <= (others => '1');
      else
        lfsr_tap := lfsr_reg(16) xor lfsr_reg(19);
        lfsr_reg <= lfsr_reg(18 downto 0) & lfsr_tap;
      end if;
    end if;
  end process;
prbs_out <= lfsr_reg;
end behavior;


