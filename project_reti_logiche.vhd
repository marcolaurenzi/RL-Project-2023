library IEEE;

use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity project_reti_logiche is
    port (
        i_clk           : in std_logic;
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
        o_mem_en        : out std_logic
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

    -- i_w and i_start signal
    signal w_star : std_logic;

    -- counter computed value
    signal counter : std_logic_vector (0 to 4) := "00000";

    -- 18 bits bus coming out from the demultiplexer
    signal w_bus : std_logic_vector (0 to 17) := "000000000000000000";

    -- 2 bit representing the output channel selected
    signal cnl_select : std_logic_vector (1 downto 0) := "00";
    
    signal memory : std_logic_vector (15 downto 0);

    -- value coming out of the second multiplexer
    signal z0_star, z1_star, z2_star, z3_star : std_logic_vector (0 to 7);

    -- value stored for the output
    signal z0_one, z1_one, z2_one, z3_one : std_logic_vector (0 to 7);
    signal load_z : std_logic; -- loading signal

    -- done bus signal used to mask and reveal the output values
    signal done_bus : std_logic_vector (0 to 7);
    
    type S is (SIDLE,SRST,S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,SMEM,SOUT,SREAD);
    signal curr_state, next_state : S;

begin

    -- input register, it acquires the input i_w as long as i_start is 1 and outputs it on w_star 
    w_star <= i_start and i_w;
    o_mem_we <= '0';

    -- counter 0 to 17
    process(i_clk, i_rst, i_start)
    begin
        if(i_rst = '1') then
            counter <= "00000";
        elsif(i_clk'event and i_clk = '1' and i_start = '1') then
            counter <= counter + "00001";
        elsif (i_start = '0' and i_clk'event and i_clk = '1') then
            counter <= "00000";
        end if;
    end process;

    -- demultiplexer 1
    process(i_clk)
    begin
        if (i_start = '1' and i_clk'event and i_clk = '1') then
            if(counter = "00000") then
                w_bus(0) <= w_star;
            elsif (counter = "00001") then
                w_bus(1) <= w_star;
            elsif (counter = "00010") then
                w_bus(2) <= w_star;
            elsif (counter = "00011") then
                w_bus(3) <= w_star;
            elsif (counter = "00100") then
                w_bus(4) <= w_star;
            elsif (counter = "00101") then
                w_bus(5) <= w_star;
            elsif (counter = "00110") then
                w_bus(6) <= w_star;
            elsif (counter = "00111") then
                w_bus(7) <= w_star;
            elsif (counter = "01000") then
                w_bus(8) <= w_star;
            elsif (counter = "01001") then
                w_bus(9) <= w_star;
            elsif (counter = "01010") then
                w_bus(10) <= w_star;
            elsif (counter = "01011") then
                w_bus(11) <= w_star;
            elsif (counter = "01100") then
                w_bus(12) <= w_star;
            elsif (counter = "01101") then
                w_bus(13) <= w_star;
            elsif (counter = "01110") then
                w_bus(14) <= w_star;
            elsif (counter = "01111") then
                w_bus(15) <= w_star;
            elsif (counter = "10000") then
                w_bus(16) <= w_star;
            elsif (counter = "10001") then
                w_bus(17) <= w_star;
            end if;
        end if;
    end process;

    -- address register 0
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            cnl_select(1) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00001") then
                cnl_select(1) <= w_bus(0);
            end if;
        end if;
    end process;

    -- address register 1
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            cnl_select(0) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00010") then
                cnl_select(0) <= w_bus(1);
            end if;
        end if;
    end process;

   -- address register 2
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr <= "0000000000000000";
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00011") then
                o_mem_addr(0) <= w_bus(2);
            elsif(counter = "00100") then
               o_mem_addr(0) <= w_bus(3);
               o_mem_addr(1) <= w_bus(2);
            elsif(counter = "00101") then
                o_mem_addr(0) <= w_bus(4);
                o_mem_addr(2 downto 1) <= w_bus(2 to 3); 
            elsif(counter = "00110") then
                o_mem_addr(0) <= w_bus(5);
                o_mem_addr(3 downto 1) <= w_bus(2 to 4); 
            elsif(counter = "00111") then
                o_mem_addr(0) <= w_bus(6);
                o_mem_addr(4 downto 1) <= w_bus(2 to 5);
            elsif(counter = "01000") then
                o_mem_addr(0) <= w_bus(7);
                o_mem_addr(5 downto 1) <= w_bus(2 to 6);
            elsif(counter = "01001") then
                o_mem_addr(0) <= w_bus(8);
                o_mem_addr(6 downto 1) <= w_bus(2 to 7);
            elsif(counter = "01010") then
                o_mem_addr(0) <= w_bus(9);
                o_mem_addr(7 downto 1) <= w_bus(2 to 8);
            elsif(counter = "01011") then
                o_mem_addr(0) <= w_bus(10);
                o_mem_addr(8 downto 1) <= w_bus(2 to 9);
            elsif(counter = "01100") then
                o_mem_addr(0) <= w_bus(11);
                o_mem_addr(9 downto 1) <= w_bus(2 to 10);
            elsif(counter = "01101") then
                o_mem_addr(0) <= w_bus(12);
                o_mem_addr(10 downto 1) <= w_bus(2 to 11);
            elsif(counter = "01110") then
                o_mem_addr(0) <= w_bus(13);
                o_mem_addr(11 downto 1) <= w_bus(2 to 12);
            elsif(counter = "01111") then
                o_mem_addr(0) <= w_bus(14);
                o_mem_addr(12 downto 1) <= w_bus(2 to 13);
            elsif(counter = "10000") then
                o_mem_addr(0) <= w_bus(15);
                o_mem_addr(13 downto 1) <= w_bus(2 to 14);
            elsif(counter = "10001") then
                o_mem_addr(0) <= w_bus(16);
                o_mem_addr(14 downto 1) <= w_bus(2 to 15);
            elsif(counter = "10010") then
                o_mem_addr(0) <= w_bus(17);
                o_mem_addr(15 downto 1) <= w_bus(2 to 16);
            end if;
        end if;
    end process;

    -- demultiplexer 2
    process (i_clk)
    begin
        if(cnl_select = "00") then
            z0_star <= i_mem_data;
        elsif(cnl_select = "01") then
            z1_star <= i_mem_data;
        elsif(cnl_select = "10") then
            z2_star <= i_mem_data;
        elsif(cnl_select = "11") then
            z3_star <= i_mem_data;
        end if;
    end process;

    -- output register 0
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            z0_one <= "00000000";
        elsif (i_clk'event and i_clk = '1' and load_z = '1' and cnl_select = "00") then
            z0_one <= z0_star;
        end if;
    end process;

    -- output register 1
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            z1_one <= "00000000";
        elsif (i_clk'event and i_clk = '1' and load_z = '1' and cnl_select = "01") then
            z1_one <= z1_star;
        end if;
    end process;

    -- output register 2
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            z2_one <= "00000000";
        elsif (i_clk'event and i_clk = '1' and load_z = '1' and cnl_select = "10") then
            z2_one <= z2_star;
        end if;
    end process;

    -- output register 3
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            z3_one <= "00000000";
        elsif (i_clk'event and i_clk = '1' and load_z = '1' and cnl_select = "11") then
            z3_one <= z3_star;
        end if;
    end process;

    -- done bus is a 8 bit bus that reflects whether the o_done signal is 1 or 0
    o_done <= done_bus(0);

    -- displayed values are always the and between the actual value and the done_bus
    o_z0 <= done_bus and z0_one;
    o_z1 <= done_bus and z1_one;
    o_z2 <= done_bus and z2_one;
    o_z3 <= done_bus and z3_one;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            curr_state <= SRST;
        elsif i_clk'event and i_clk = '1' then
            curr_state <= next_state;
        end if;
    end process;

    process(curr_state, i_clk)
    begin
            load_z <= '0';         
            done_bus <= "00000000";
            case curr_state is
            when SIDLE =>
                o_mem_en <= '0';
            when SRST => 
                
            when S0 =>
            when S1 =>
            when S2 =>
            when S3 =>
            when S4 =>
            when S5 =>
            when S7 =>
            when S8 =>
            when S9 =>
            when S10 =>
            when S11 =>
            when S12 =>
            when S13 =>
            when S14 =>
            when S15 =>
            when S16 =>
            when S17 =>
            when SMEM =>
                o_mem_en <= '1';
            when SOUT =>
                load_z <= '1';
            when SREAD =>
                o_mem_en <= '0';
                done_bus <= "11111111";   
            when others =>
       
            end case;
       
    end process;

    -- funzione stato prossimo
    process(curr_state, i_clk)
    begin
        next_state <= curr_state;
        case (curr_state) is
            when SIDLE =>
                if (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SIDLE;
                end if;
            when SRST =>
                if(i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= S0;
                end if;
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                 elsif i_start = '0' then
                    next_state <= S0;
                else
                    next_state <= SMEM;
                end if;
            when S1 =>
                if i_start = '1' then
                    next_state <= S2;
                else
                    next_state <= SMEM;
                end if;
            when S2 =>
                if i_start = '1' then
                    next_state <= S3;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S3 =>
                if i_start = '1' then
                    next_state <= S4;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S4 =>
                if i_start = '1' then
                    next_state <= S5;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S5 =>
                if i_start = '1' then
                    next_state <= S6;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S6 =>
                if i_start = '1' then
                    next_state <= S7;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S7 =>
                if i_start = '1' then
                    next_state <= S8;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S8 =>
                if i_start = '1' then
                    next_state <= S9;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S9 =>
                if i_start = '1' then
                    next_state <= S10;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S10 =>
                if i_start = '1' then
                    next_state <= S11;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S11 =>
                if i_start = '1' then
                    next_state <= S12;
                elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S12 =>
                if i_start = '1' then
                    next_state <= S13;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S13 =>
                if i_start = '1' then
                    next_state <= S14;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S14 =>
                if i_start = '1' then
                    next_state <= S15;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S15 =>
                if i_start = '1' then
                    next_state <= S16;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when S16 =>
                if i_start = '1' then
                    next_state <= S17;
                 elsif (i_rst = '1') then
                    next_state <= SRST;
                else
                    next_state <= SMEM;
                end if;
            when SMEM =>
                next_state <= SOUT;
            when SOUT =>
                next_state <= SREAD;
            when SREAD =>
                next_state <= S0;    
            when others =>
        end case;
        
    end process;

end Behavioral;
