library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity demux is
       port( s:      in  std_logic_vector(0 to 4);
             x:      in  std_logic;
             y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15, y16, y17: out std_logic );
end demux;
architecture Behavioral of demux is
begin
    y0      <= x when s="00000" else '-';
    y1      <= x when s="00001" else '-';
    y2      <= x when s="00010" else '-';
    y3      <= x when s="00011" else '-';
    y4      <= x when s="00100" else '-';
    y5      <= x when s="00101" else '-';
    y6      <= x when s="00110" else '-';
    y7      <= x when s="00111" else '-';
    y8      <= x when s="01000" else '-';
    y9      <= x when s="01001" else '-';
    y10     <= x when s="01010" else '-';
    y11     <= x when s="01011" else '-';
    y12     <= x when s="01100" else '-';
    y13     <= x when s="01101" else '-';
    y14     <= x when s="01110" else '-';
    y15     <= x when s="01111" else '-';
    y16     <= x when s="10000" else '-';
    y17     <= x when s="10001" else '-';
end Behavioral;