library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_tb is

end demux_tb;

architecture Behavioral of demux_tb is

component demux2 is
    port(   s               :      in  std_logic_vector(0 to 1);
            x               :      in  std_logic;
            y0, y1, y2, y3  :  out std_logic 
        );
end component;

signal s                    :           std_logic_vector(0 to 1);
signal x                    :           std_logic;
signal y0, y1, y2, y3       :           std_logic 

begin
    TOP0 : demux2 port map(
        s,                                                                                  
        x,                                                                                    
        y0, y1, y2, y3
    );  

    process
    begin
        s <= "00";
        wait for 1 ns;
        s <= "01";
        wait for 1 ns;
        s <= "10";
        wait for 1 ns;
        s <= "11";
        wait for 1 ns;
        s <= "00";
        wait for 1 ns;
        s <= "10";
        wait for 1 ns;
    end process;

    process
    begin
        x <= '1';
        wait for 100 ns;
    end process;

end Behavioral;