library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Holy ass, easy peasy for radix 2, swap 1000 -> 0010
entity digit_reverser is
  generic (input_size      : integer;
           slot_width  : integer;
           cp_short_length : integer;
           cp_long_length  : integer);
  port (clk                              : in  std_logic;
        reset                            : in  std_logic;
        end_of_input                     : in  std_logic;
        time_i, time_q                   : in  std_logic_vector(31 downto 0);
        time_i_prefixed, time_q_prefixed : out std_logic_vector(31 downto 0));
end entity;

architecture behavioral of digit_reverser is
begin

  process ()
  begin

  end process;

  process (clk, reset)
  begin

  end process;

end architecture;
