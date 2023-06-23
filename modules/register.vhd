library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity register is
    port( CLK:   in  std_logic;
          RESET: in  std_logic;
          X:     in  std_logic;
          Y:     out std_logic;
    );
end register;


architecture Behavioral of register is
begin
    reg: process( CLK, RESET )
    begin
        if( RESET = '1' ) then
            Y <= 0;
        elsif( CLK'event and CLK = '1' ) then
            Y <= X;
        end if;
    end process;
 end Behavioral;