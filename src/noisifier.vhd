library ieee;
use ieee.std_logic_1164.all;

entity noisifier is
  port (clk   : in  std_logic;
        reset : in  std_logic;
        enable : in std_logic;
        i_in  : in  std_logic_vector(31 downto 0);
        q_in  : in  std_logic_vector(31 downto 0);
        i_out : out std_logic_vector(31 downto 0);
        q_out : out std_logic_vector(31 downto 0));
end entity;

architecture noise of noisifier is
  type state_t is (one, two);
  signal state, next_state : state_t;

  signal pseudo_reg_0, pseudo_reg_1 : std_logic_vector(3 downto 0);

  signal pseudo_reg_i, next_pseudo_reg_i,
    pseudo_reg_q, next_pseudo_reg_q : std_logic_vector(3 downto 0);

  component msrg is
    generic (seq_begin : std_logic_vector(3 downto 0));
    port (clk      : in  std_logic;
          reset    : in  std_logic;
          sequence : out std_logic_vector(3 downto 0));
  end component;
begin

  --           31 30       22
  -- Float 32: s  eeeeeeee mmmmmmmmmmmmmmmmmmmmmmm
  -- bit 4, 5, 6, 7 of the mantissa is used to apply "noise"
  i_out <= i_in(31 downto 20) &
           (i_in(19 downto 16) xor pseudo_reg_i(3 downto 0)) &
           i_in(15 downto 0);

  q_out <= q_in(31 downto 20) &
           (q_in(19 downto 16) xor pseudo_reg_q(3 downto 0)) &
           q_in(15 downto 0);

  state_controller : process(state, enable,
                             pseudo_reg_0, pseudo_reg_i,
                             pseudo_reg_1, pseudo_reg_q)
  begin
    next_pseudo_reg_i <= pseudo_reg_i;
    next_pseudo_reg_q <= pseudo_reg_q;
    next_state <= state;

    if enable = '1' then
      case state is
        when one =>
          next_pseudo_reg_i <= pseudo_reg_0;
          next_pseudo_reg_q <= pseudo_reg_1;
          next_state        <= two;
        when two =>
          next_pseudo_reg_i <= pseudo_reg_1;
          next_pseudo_reg_q <= pseudo_reg_0;
          next_state        <= one;
      end case;
    end if;
  end process;

  clock_controller : process(reset, clk)
  begin
    if reset = '1' then
      state        <= one;
      pseudo_reg_i <= pseudo_reg_0;
      pseudo_reg_q <= pseudo_reg_1;
    elsif rising_edge(clk) then
      state        <= next_state;
      pseudo_reg_i <= next_pseudo_reg_i;
      pseudo_reg_q <= next_pseudo_reg_q;
    end if;
  end process;

  i_pseudo_reg_0 : msrg
    generic map (seq_begin => "1001")
    port map (clk      => clk,
              reset    => reset,
              sequence => pseudo_reg_0);
  i_pseudo_reg_1 : msrg
    generic map (seq_begin => "1101")
    port map (clk      => clk,
              reset    => reset,
              sequence => pseudo_reg_1);
end architecture;
