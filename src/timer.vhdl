library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity timer is
   generic (CYCLES_BITS: positive := 8);

   port (clk: in std_logic;
         clr: in std_logic;
         stop_cycles: in std_logic_vector(CYCLES_BITS-1 downto 0);
         finished: out std_logic);
end timer;

architecture Behavioral of timer is
begin

    
    config : process(clk) is
    
        variable counter : unsigned (CYCLES_BITS downto 0) := (others => '0');

    begin
        if(rising_edge(clk)) then
            

            if(clr='1') then
                counter := (others => '0');
            else counter := counter +1;
            end if;
        
            if(counter = unsigned(stop_cycles) +1) then
                finished <= '1';
            else finished <= '0';        
            end if;

        end if;
    end process config;
end Behavioral;
