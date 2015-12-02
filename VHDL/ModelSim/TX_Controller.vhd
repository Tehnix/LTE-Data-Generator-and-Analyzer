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
  signal tx_ctrl_intern : std_logic;

begin
  process(tx_clk)
  begin
    if RISING_EDGE(tx_clk) then
      tx_ctrl_intern <= '1';
      if tx_ctrl_intern = '1' then
        tx_ctrl_intern <= '0';
      end if;
    end if;
  end process;

tx_ctrl_sig <= tx_ctrl_intern;

end behavior;