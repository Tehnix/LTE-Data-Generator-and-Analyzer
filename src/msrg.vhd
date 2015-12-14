library ieee;
use ieee.std_logic_1164.all;

entity msrg is
  generic (seq_begin : std_logic_vector(3 downto 0));
  port (clk      : in  std_logic;
        reset    : in  std_logic;
        sequence : out std_logic_vector(3 downto 0));
end msrg;

architecture behavior of msrg is
  signal lfsr_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
  process(reset, clk)
  begin
    if reset = '1' then
      lfsr_reg <= "0000" & seq_begin;
    elsif rising_edge(clk) then
      lfsr_reg(7) <= lfsr_reg(0);
      lfsr_reg(6) <= lfsr_reg(7) xor lfsr_reg(0);
      lfsr_reg(5) <= lfsr_reg(6);
      lfsr_reg(4) <= lfsr_reg(5);
      lfsr_reg(3) <= lfsr_reg(4) xor lfsr_reg(0);
      lfsr_reg(2) <= lfsr_reg(3);
      lfsr_reg(1) <= lfsr_reg(2) xor lfsr_reg(0);
      lfsr_reg(0) <= lfsr_reg(1);
    end if;
  end process;

  sequence <= lfsr_reg(3 downto 0);

end behavior;
