library ieee;
use ieee.std_logic_1164.all;

entity tx_contr is
port (
        tx_ctrl_sig : out std_logic;
        rset        : in std_logic;
        tx_clk      : in std_logic

);
end tx_contr;

architecture behavior of tx_contr is

begin
  process(tx_clk)
  begin
    if RISING_EDGE(tx_clk) then
      tx_ctrl_sig <= '1';
    end if;
    
  end process;

end behavior;