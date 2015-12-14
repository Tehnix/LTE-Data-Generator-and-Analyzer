library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.functions.all;

entity cyclic_prefix is
  generic (input_size      : integer;
           slot_width      : integer;
           cp_short_length : integer;
           cp_long_length  : integer);
  port (clk                          : in  std_logic;
        reset                        : in  std_logic;
        halt                         : in  std_logic;
        tx_controller_cp                         : out std_logic;
        start_of_input, end_of_input : in  std_logic;
        time_i, time_q               : in  std_logic_vector(31 downto 0);
        transmit_fifo_write_request  : out std_logic;
        time_prefixed                : out std_logic_vector(63 downto 0));
end entity;

architecture fsmd of cyclic_prefix is
  type state_t is (cp_long_enqueue, cp_long, cp_short_enqueue, cp_short, cp_dequeue);

  component tx_fifo
    port (data    : in  std_logic_vector (63 downto 0);
          rdclk   : in  std_logic;
          rdreq   : in  std_logic;
          wrclk   : in  std_logic;
          wrreq   : in  std_logic;
          q       : out std_logic_vector (63 downto 0);
          rdempty : out std_logic;
          wrfull  : out std_logic);
  end component;

  signal state, next_state : state_t;

  -- Count time samples
  constant TIME_HIGH : integer := log2(input_size);
  signal time_counter, next_time_counter :
    unsigned(TIME_HIGH downto 0);

  -- 3 bits are sufficient for count to 6
  constant RE_HIGH : integer := (slot_width / 2) - 1;
  signal resource_element_counter, next_resource_element_counter :
    unsigned(RE_HIGH downto 0);

  -- FIFO signals
  signal fifo_data_in, fifo_data_out : std_logic_vector(63 downto 0);
  signal fifo_read_request, fifo_write_request,
    fifo_empty, fifo_full : std_logic;

begin

  process (state, start_of_input, end_of_input, halt)
  begin
    next_resource_element_counter <= resource_element_counter;
    next_time_counter             <= time_counter;
    next_state                    <= state;

    fifo_data_in       <= (others => '0');
    fifo_read_request  <= '0';
    fifo_write_request <= '0';

    -- The transmit buffer should be written to continuously, unless its full
    -- and the transmit controller halts the system.
    if halt = '1' then
      transmit_fifo_write_request <= '0';
    else
      transmit_fifo_write_request <= '1';
    end if;

    -- Forward I/Q time samples from iFFT unless cyclic prefix is output.
    time_prefixed <= time_i & time_q;

    case state is
      -- Head resource element within a slot
      -- Enqueue and forward
      when cp_long_enqueue =>
        fifo_data_in       <= time_i & time_q;
        fifo_write_request <= '1';

        next_time_counter <= time_counter + 1;

        -- Proceed on to plain forwarding of time samples
        if time_counter = cp_long_length then
          next_state <= cp_long;
        end if;

      when cp_long =>
        next_time_counter <= time_counter + 1;

        -- If iFFT signals the end, get ready to extract the long cyclic
        -- prefix from FIFO.
        if end_of_input = '1' then
          next_time_counter <= to_unsigned(cp_long_length, TIME_HIGH);
          next_state        <= cp_dequeue;
        end if;

      -- Tail resource elements within a slot
      -- Push and forward
      when cp_short_enqueue =>
        fifo_data_in       <= time_i & time_q;
        fifo_write_request <= '1';

        next_time_counter <= time_counter + 1;

        if time_counter = cp_short_length then
          next_state <= cp_short;
        end if;

        -- Increment to next resource element when the iFFT notifies us.
        if end_of_input = '1' then
          next_resource_element_counter <= resource_element_counter + 1;
        end if;

        -- Proceed on to plain forwarding of time samples
        if resource_element_counter = slot_width - 1 then
          next_resource_element_counter <= (others => '0');

          next_state <= cp_long;
        end if;

      when cp_short =>
        next_time_counter <= time_counter + 1;
        next_state        <= cp_short;

        -- If iFFT signals the end, get ready to extract the long cyclic
        -- prefix from FIFO.
        if end_of_input = '1' then
          next_time_counter <= to_unsigned(cp_short_length, TIME_HIGH);
          next_state        <= cp_dequeue;
        end if;

      -- Dequeue stored cyclic prefix
      when cp_dequeue =>
        -- Let the TX controller know cyclic prefix is being applied.
        tx_controller_cp <= '1';

        fifo_read_request <= '1';
        time_prefixed     <= fifo_data_out;
        next_time_counter <= time_counter - 1;

        -- After 6 short resource elements return to first head of next slot.
        if time_counter = 0 then
          if resource_element_counter = slot_width then
            next_state <= cp_long_enqueue;
          else
            next_state <= cp_short_enqueue;
          end if;
        end if;
    end case;

  end process;

  process (clk, reset)
  begin
    if reset = '1' then
      resource_element_counter <= (others => '0');
      time_counter             <= (others => '0');
      state                    <= cp_long;
    elsif rising_edge(clk) then
      resource_element_counter <= next_resource_element_counter;
      time_counter             <= next_time_counter;
      state                    <= next_state;
    end if;
  end process;

  i_cp_fifo_0 : tx_fifo
    port map (data    => fifo_data_in,
              rdclk   => clk,
              wrclk   => clk,
              rdreq   => fifo_read_request,
              wrreq   => fifo_write_request,
              q       => fifo_data_out,
              rdempty => open,
              wrfull  => open);

end architecture;
