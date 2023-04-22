library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
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
end datapath;

architecture Behavioral of datapath is

signal i_w_one : std_logic := '0';
signal i_w_star : std_logic := '0';
signal counter : std_logic_vector (0 to 4) := "00000";
signal load_w : std_logic := '0';
signal i_w0, i_w1, i_w2, i_w3, i_w4, i_w5, i_w6, i_w7, i_w8, i_w9, i_w10, i_w11, i_w12, i_w13, i_w14, i_w15, i_w16, i_w17 : std_logic;
signal load_val : std_logic;
signal i_mem_addr : std_logic_vector (0 to 15) := "0000000000000000";
signal o_cnl_select : std_logic_vector (0 to 1) := "00";
signal o_mem_val : std std_logic_vector (0 to 7) := "00000000";
signal val : std_logic_vector (0 to 7) := "00000000";
signal load_val : std_logic := '0';
signal z0_star, z1_star, z2_star, z3_star : std_logic_vector (0 to 7) := "00000000";
signal z0_one, z1_one, z2_one, z3_one : std_logic_vector (0 to 7);
signal load_z : std_logic := '0';
signal o_done_bus : std_logic_vector (o to 7) := "00000000";



begin

    -- input register
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w_one = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(load_w = '1') then
                i_w_star <= i_w and i_start;
            end if;
        end if;
    end process;

    -- counter 0 to 17
    process(i_clk, i_rst, i_start)
    begin
        if( i_rst = '1' ) then
            counter <= "00000";
        elsif( i_start = '1' and i_clk'EVENT and i_clk = '1' ) then
            counter <= counter + ”00001”;
        end if;
    end process;

    -- demultiplexer 1
    process (i_clk)
    begin
        if(counter = "00000") then
            i_w0 <= i_w_star;
        elsif (counter = "00001") then
            i_w1 <= i_w_star;
        elsif (counter = "00010") then
            i_w2 <= i_w_star;
        elsif (counter = "00011") then
            i_w3 <= i_w_star;
        elsif (counter = "00100") then
            i_w4 <= i_w_star;
        elsif (counter = "00101") then
            i_w5 <= i_w_star;
        elsif (counter = "00110") then
            i_w6 <= i_w_star;
        elsif (counter = "00111") then
            i_w7 <= i_w_star;
        elsif (counter = "01000") then
            i_w8 <= i_w_star;
        elsif (counter = "01001") then
            i_w9 <= i_w_star;
        elsif (counter = "01010") then
            i_w10 <= i_w_star;
        elsif (counter = "01011") then
            i_w11 <= i_w_star;
        elsif (counter = "01100") then
            i_w12 <= i_w_star;
        elsif (counter = "01101") then
            i_w13 <= i_w_star;
        elsif (counter = "01110") then
            i_w14 <= i_w_star;
        elsif (counter = "01111") then
            i_w15 <= i_w_star;
        elsif (counter = "10000") then
            i_w16 <= i_w_star;
        elsif (counter = "10001") then
            i_w17 <= i_w_star;
        end if;
    end process;

    -- address register 0
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w0 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00000") then
                i_mem_addr(0) <= i_w0;
            end if;
        end if;
    end process;

    -- address register 1
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w1 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00001") then
                i_mem_addr(1) <= i_w1;
            end if;
        end if;
    end process;

    -- address register 2
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w2 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00010") then
                i_mem_addr(2) <= i_w2;
            end if;
        end if;
    end process;

    -- address register 3
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w3 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00011") then
                i_mem_addr(3) <= i_w3;
            end if;
        end if;
    end process;

    -- address register 4
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w4 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00100") then
                i_mem_addr(4) <= i_w4;
            end if;
        end if;
    end process;

    -- address register 5
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w5 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00101") then
                i_mem_addr(5) <= i_w5;
            end if;
        end if;
    end process;

    -- address register 6
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w6 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00110") then
                i_mem_addr(6) <= i_w6;
            end if;
        end if;
    end process;

    -- address register 7
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w7 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00111") then
                i_mem_addr(7) <= i_w7;
            end if;
        end if;
    end process;

    -- address register 8
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w8 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01000") then
                i_mem_addr(8) <= i_w8;
            end if;
        end if;
    end process;

    -- address register 9
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w9 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01001") then
                i_mem_addr(9) <= i_w9;
            end if;
        end if;
    end process;

    -- address register 10
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w10 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01010") then
                i_mem_addr(10) <= i_w10;
            end if;
        end if;
    end process;

    -- address register 11
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w11 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01011") then
                i_mem_addr(11) <= i_w11;
            end if;
        end if;
    end process;

    -- address register 12
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w12 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01100") then
                i_mem_addr(12) <= i_w12;
            end if;
        end if;
    end process;

    -- address register 13
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w13 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01101") then
                i_mem_addr(13) <= i_w13;
            end if;
        end if;
    end process;

    -- address register 14
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w14 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01110") then
                i_mem_addr(14) <= i_w14;
            end if;
        end if;
    end process;

    -- address register 15
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w15 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01111") then
                i_mem_addr(15) <= i_w15;
            end if;
        end if;
    end process;

    -- address register 16
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w16 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "10000") then
                i_mem_addr(16) <= i_w16;
            end if;
        end if;
    end process;

    -- address register 17
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            i_w17 = '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "10001") then
                i_mem_addr(17) <= i_w17;
            end if;
        end if;
    end process;

    --memory
    process(clk)
    begin
    if clk'event and clk = '1' then
      if o_mem_en = '1' then
        if o_mem_we = '1' then
            o_mem_val <= "00000000";
        else
            o_mem_val <= "11111111" after 2 ns;
        end if;
      end if;
    end if;
  end process;

    -- memory register
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            val = "00000000";
        elsif (i_clk'event and i_clk = '1') then
            if(load_val = '1') then
                val <= o_mem_val;
            end if;
        end if;
    end process;

    -- demultiplexer 2
    process (i_clk)
    begin
        if(i_w0 & i_w1 = "00") then
            z0_star <= val;
        elsif(i_w0 & i_w1 = "01") then
            z1_star <= val;
        elsif(i_w0 & i_w1 = "10") then
            z2_star <= val;
        elsif(oi_w0 & i_w1 = "11") then
            z_star <= val;
        end if;
    end process;

    -- output register 0
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            z0_one = "00000000";
        elsif (i_clk'event and i_clk = '1') then
            if(load_z = '1') then
                z0_one <= z0_star;
            end if;
        end if;
    end process;

    -- output register 1
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            z1_one = "00000000";
        elsif (i_clk'event and i_clk = '1') then
            if(load_z = '1') then
                z1_one <= z1_star;
            end if;
        end if;
    end process;

    -- output register 2
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            z2_one = "00000000";
        elsif (i_clk'event and i_clk = '1') then
            if(load_z = '1') then
                z2_one <= z2_star;
            end if;
        end if;
    end process;

    -- output register 3
    process (i_rst, i_clk)
    begin
        if(i_res = '1') then
            z3_one = "00000000";
        elsif (i_clk'event and i_clk = '1') then
            if(load_z = '1') then
                z3_one <= z3_star;
            end if;
        end if;
    end process;

    -- done
    process (load_z)
    begin
        if(load_z = '1') then
            o_done_bus = "11111111"
            o_done = '1';
        end if;
    end process;

    o_z0 = done_bus and z0_one;
    o_z1 = done_bus and z1_one;
    o_z2 = done_bus and z2_one;
    o_z3 = done_bus and z3_one;

end Behavioral;