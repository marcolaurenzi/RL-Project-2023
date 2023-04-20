library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_tb is

end demux_tb;

architecture Behavioral of demux_tb is

component demux1 is
    port(   s                                                                               :       in  std_logic_vector(0 to 4);
            x                                                                               :       in  std_logic;
            y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15, y16, y17  :       out std_logic 
        );
end component;

signal s                                                                                    :       std_logic_vector(0 to 4);
signal x                                                                                    :       std_logic;
signal y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15, y16, y17       :       std_logic 

begin
    TOP0 : demux1 port map(
        s,                                                                                  
        x,                                                                                    
        y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15, y16, y17  
    );  

    process
    begin
        s <= "00000";
        wait for 1 ns;
        s <= "00010";
        wait for 1 ns;
        s <= "00100";
        wait for 1 ns;
        s <= "01000";
        wait for 1 ns;
        s <= "00011";
        wait for 1 ns;
        s <= "10000";
        wait for 1 ns;
    end process;

    process
    begin
        x <= '1';
        wait for 100 ns;
    end process;

end Behavioral;