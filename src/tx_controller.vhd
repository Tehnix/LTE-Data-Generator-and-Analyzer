library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_controller is
  port (fifo_full : in std_logic;
        halt : out std_logic;
        start_of_packet_i : in std_logic;
        end_of_packet_i : in std_logic;
        start_of_packet_o : out std_logic;
        end_of_packet_o : out std_logic;
        transmit  : out std_logic);
end entity;

architecture soedt of tx_controller is

begin

  transmit <= '1';

  process (fifo_full)
  begin
    halt <= '1';
  end process;

end architecture;
