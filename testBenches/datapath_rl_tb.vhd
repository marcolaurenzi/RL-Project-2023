library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_rl is

end datapath_rl;

architecture Behavioral of datapath_rl is
    component datapath is
        Port (  i_clk           : in std_logic;
                i_rst           : in std_logic;
                i_start         : in std_logic;
                i_w             : in std_logic;
                o_z0            : out std_logic_vector(7 downto 0);
                o_z1            : out std_logic_vector(7 downto 0);
                o_z2            : out std_logic_vector(7 downto 0);
                o_z3            : out std_logic_vector(7 downto 0);
                o_done          : out std_logic;
                o_mem_addr      : out std_logic_vector(15 downto 0);
                i_mem_data      : in std_logic_vector(7 downto 0);
                o_mem_we        : out std_logic;
                o_mem_en        : out std_logic;
            );
    end component;
    
    signal i_clk           :  std_logic;
    signal i_rst           :  std_logic;
    signal i_start         :  std_logic;
    signal i_w             :  std_logic;
    signal o_z0            :  std_logic_vector(7 downto 0);
    signal o_z1            :  std_logic_vector(7 downto 0);
    signal o_z2            :  std_logic_vector(7 downto 0);
    signal 0_z3            :  std_logic_vector(7 downto 0);
    signal o_done          :  std_logic;
    signal o_mem_addr      : std_logic_vector(15 downto 0);
    signal i_mem_data      :  std_logic_vector(7 downto 0);
    signal o_mem_we        :  std_logic;
    signal o_mem_en        :  std_logic;

    begin
        TOP0: datapath port map(
                i_clk           
                i_rst           
                i_start         
                i_w             
                o_z0            
                o_z1            
                o_z2            
                o_z3            
                o_done          
                o_mem_addr      
                i_mem_data     
                o_mem_we        
                o_mem_en   
        );

        process
        begin
            CLK <= '0';
            wait for 10 ns;
            CLK <= '1';
            wait for 10 ns;
        end process;

        i_w = '1';

        process
        begin
            wait for 2 ns;
            i_rst = '1';
            wait for 2 ns;
            i_start = '1';
            wait for 180 ns;
            o_mem_we = '1';
            o_mem_en = '1';

        end process;

        
end Behavioral;