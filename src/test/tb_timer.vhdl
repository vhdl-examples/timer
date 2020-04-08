library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_timer is
    generic (runner_cfg : string);
end tb_timer;

architecture Behavioral of tb_timer is
   component timer is
   generic (CYCLES_BITS: positive );

   port (clk: in std_logic;
         clr: in std_logic;
         stop_cycles: in std_logic_vector(CYCLES_BITS-1 downto 0);
         finished: out std_logic);
end component;

    constant CYCLES_BITS: positive := 3;
    
    signal clk : std_logic;
    signal clr : std_logic;

    signal stop_cycles:  std_logic_vector(CYCLES_BITS-1 downto 0);
    signal finished: std_logic;

    constant T : time := 100 ns;
begin

    clock_generation : process
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
    end process;

    uut: timer
        generic map (
            CYCLES_BITS => CYCLES_BITS)
        port map (
            clk => clk,
            clr => clr,

            stop_cycles => stop_cycles,
            finished => finished);

    tb: process
    begin
        test_runner_setup(runner, runner_cfg);
        stop_cycles  <= "100";
        clr <= '1';

        wait until falling_edge(clk);
        assert finished = '0' report "timer should not be ended";
        clr <= '0';

        wait until falling_edge(clk);
        assert finished = '0' report "timer should not be ended";


        wait until falling_edge(clk);
        assert finished = '0' report "timer should not be ended";


        wait until falling_edge(clk);
        assert finished = '0' report "timer should not be ended";


        wait until falling_edge(clk);
        assert finished = '0' report "timer should not be ended";
        
        wait until falling_edge(clk);
        assert finished = '1' report "timer should be ended";
        
        wait until falling_edge(clk);
        clr <= '1';
        stop_cycles  <= "001";

        wait until falling_edge(clk);
        clr <= '0';

        assert finished = '0' report "timer should not be ended";

        wait until falling_edge(clk);
        assert finished = '0' report "timer should not be ended";


        wait until falling_edge(clk);
        assert finished = '1' report "timer should be ended";
        
        test_runner_cleanup(runner); -- Simulation ends here
    end process;

end Behavioral;
