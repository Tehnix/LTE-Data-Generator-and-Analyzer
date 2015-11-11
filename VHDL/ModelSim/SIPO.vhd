library ieee;
use ieee.std_logic_1164.all;

-- Serial In Parallel out (4 register output after 4 clock cycles)
entity sipo is
port (
  sipo_clk     : in std_logic;
  rset         : in std_logic; 
  parallel_out : out std_logic_vector(3 downto 0)
);
end entity sipo;
  
architecture funct of sipo is
signal sipo_reg : std_logic_vector(3 downto 0);

component prbs is
port ( 
  prbs_clk : in std_logic;
  rset     : in std_logic;
  prbs_out : out std_logic_vector(31 downto 0)
);
end component;

-- Work in progress - brain malfunctioning
--begin 
--  lfsr_prbs : component prbs 
--    port map(
--      prbs_clk => sipo_clk,
--      rset => rset,
--      prbs_out => sipo_reg
--);
	
end architecture;