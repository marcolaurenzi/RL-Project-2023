library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    Port ( i_clk            : in STD_LOGIC;
           i_res            : in STD_LOGIC;
           i_data           : in STD_LOGIC_VECTOR (7 downto 0);
           o_data           : out STD_LOGIC_VECTOR (7 downto 0);
           r1_load          : in STD_LOGIC;
           r2_load          : in STD_LOGIC;
           r3_load          : in STD_LOGIC;
           r2_sel           : in STD_LOGIC;
           r3_sel           : in STD_LOGIC;
           d_sel            : in STD_LOGIC;
           o_end            : out STD_LOGIC
        );
end datapath;