library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity timer is
    generic (CYCLES_BITS: positive := 8);

    port (clk: in std_logic;
          clr: in std_logic;
          start: in std_logic;
          stop_cycles: in std_logic_vector(CYCLES_BITS-1 downto 0);
          finished: out std_logic);
end timer;

architecture Behavioral of timer is
    type state_type is (idle, op, done);
    signal state, next_state: state_type;
    signal counter, next_counter: unsigned (CYCLES_BITS downto 0);
begin

    sync: process(clk) is
    begin
        if(clr='1') then
            state <= idle;
            counter <= (others => '0');
        elsif(rising_edge(clk)) then
            state <= next_state;
            counter <= next_counter;
        end if;
    end process sync;

    comb: process (state, counter, start) is
    begin
        finished <= '0';
        next_counter <= (others => '0');
        next_state <= state;

        case state is
            when idle =>
                if start = '1' then
                    next_state <= op;
                end if;
            when op =>
                next_counter <= counter + 1;
                if(counter = unsigned(stop_cycles)) then
                    finished <= '1';
                    next_state <= done;
                end if;
            when done =>
                next_state <= idle;
        end case;
    end process comb;
end Behavioral;
