library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter5bit_tb is

end counter5bit_tb;

architecture Behavioral of counter5bit_tb is
component counter5bit is
    Port(   CLK:   in  std_logic;
            RESET: in  std_logic;
            START: in  std_logic;
            Y:     out std_logic_vector(0 to 4)
        );
end component;

signal CLK      :           std_logic;
signal RESET    :           std_logic;
signal START    :           std_logic;
signal Y        :           std_logic_vector(0 to 4);

begin
    TOP0 : counter5bit port map(
        CLK,
        RESET,
        START,
        Y
    );

    process
    begin
        CLK <= '0';
        wait for 10 ns;
        CLK <= '1';
        wait for 10 ns;
    end process;

    process
    begin
        RESET <= '0';
        wait for 1 ns;
        RESET <= '1';
        wait for 10 ns;
        RESET <= '0';
        wait for 1000 ns;
        assert false report "simulation ended" severity failure;
    end process;

end Behavioral;

    