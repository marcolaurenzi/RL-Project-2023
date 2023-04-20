library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity demux is
       port( s:      in  std_logic_vector(0 to 1);
             x:      in  std_logic;
             y0, y1, y2, y3: out std_logic );
end demux;
architecture Behavioral of demux is
begin
    y0      <= x when s="00" else '-';
    y1      <= x when s="01" else '-';
    y2      <= x when s="10" else '-';
    y3      <= x when s="11" else '-';
end Behavioral;