library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter5bit is
    port( CLK:   in  std_logic;
          RESET: in  std_logic;
          START: in  std_logic;
          Y:     out std_logic_vector(0 to 4) );
end counter5bit;


architecture Behavioral of counter5bit is
    signal TY: std_logic_vector(0 to 4) := "00000";
begin
    -- Counts
    count: process(CLK, RESET, START)
    begin
        if( RESET = '1' ) then
            TY <= "00000";
        elsif( START = '1' and CLK'EVENT and CLK = '1' ) then
            TY <= TY + ”00001”;
        end if;
    end process;
                
-- Assigns the output signal
    Y <= TY;
end Behavioral;
