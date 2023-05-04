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
            o_mem_en        : out std_logic
        );
end datapath;

architecture Behavioral of datapath is

    -- i_w and i_start signal coming out from the first register
    signal w_star : std_logic := '0';
    signal load_w_star : std_logic := '0'; --loading signal

    -- counter computed value
    signal counter : std_logic_vector (0 to 4) := "00000";

    -- 18 bits bus coming out from the demultiplexer
    signal w_bus : std_logic_vector (0 to 17) := "000000000000000000";

    -- 2 bit representing the output channel selected
    signal cnl_select : std_logic_vector (0 to 1) := "00";

    -- value coming out of the second multiplexer
    signal z0_star, z1_star, z2_star, z3_star : std_logic_vector (0 to 7) := "00000000";

    -- value stored for the output
    signal z0_one, z1_one, z2_one, z3_one : std_logic_vector (0 to 7) := "00000000";
    signal load_z : std_logic := '0'; -- loading signal

    -- done bus signal used to mask and reveal the output values
    signal done_bus : std_logic_vector (0 to 7) := "00000000";

begin

    -- input register, it acquires the input i_w as long as i_start is 1 and outputs it on w_star
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            w_star <= '0';
        elsif (i_clk'event and i_clk = '1' and i_start = '1') then
            w_star <= i_w;
        end if;
    end process;

    -- counter 0 to 17
    process(i_clk, i_rst, i_start)
    begin
        if(i_rst = '1' ) then
            counter <= "00000";
        elsif(i_start = '1' and i_clk'event and i_clk = '1' ) then
            counter <= counter + ”00001”;
        end if;
    end process;

    -- demultiplexer 1
    process
    begin
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
    end process;

    -- address register 0
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            cnl_select(0) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00000") then
                cnl_select(0) <= w_bus(0);
            end if;
        end if;
    end process;

    -- address register 1
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            cnl_select(1) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00001") then
                cnl_select(1) <= w_bus(1);
            end if;
        end if;
    end process;

    -- address register 2
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(15) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00010") then
                o_mem_addr(15) <= w_bus(2);
            end if;
        end if;
    end process;

    -- address register 3
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(14) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00011") then
                o_mem_addr(14) <= w_bus(3);
            end if;
        end if;
    end process;

    -- address register 4
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(13) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00100") then
                o_mem_addr(13) <= w_bus(4);
            end if;
        end if;
    end process;

    -- address register 5
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(12) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00101") then
                o_mem_addr(12) <= w_bus(5);
            end if;
        end if;
    end process;

    -- address register 6
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(11) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00110") then
                o_mem_addr(11) <= w_bus(6);
            end if;
        end if;
    end process;

    -- address register 7
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(10) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00111") then
                o_mem_addr(10) <= w_bus(7);
            end if;
        end if;
    end process;

    -- address register 8
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(9) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01000") then
                o_mem_addr(9) <= w_bus(8);
            end if;
        end if;
    end process;

    -- address register 9
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(8) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01001") then
                o_mem_addr(8) <= w_bus(9);
            end if;
        end if;
    end process;

    -- address register 10
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(7) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01010") then
                o_mem_addr(7) <= w_bus(10);
            end if;
        end if;
    end process;

    -- address register 11
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(6) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01011") then
                o_mem_addr(6) <= w_bus(11);
            end if;
        end if;
    end process;

    -- address register 12
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(5) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01100") then
                i_mem_addr(5) <= w_bus(12);
            end if;
        end if;
    end process;

    -- address register 13
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(4) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01101") then
                o_mem_addr(4) <= w_bus(13);
            end if;
        end if;
    end process;

    -- address register 14
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(3) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01110") then
                o_mem_addr(3) <= w_bus(14);
            end if;
        end if;
    end process;

    -- address register 15
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(2) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01111") then
                o_mem_addr(2) <= w_bus(15);
            end if;
        end if;
    end process;

    -- address register 16
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(1) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "10000") then
                o_mem_addr(1) <= w_bus(16);
            end if;
        end if;
    end process;

    -- address register 17
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(0) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "10001") then
                o_mem_addr(0) <= w_bus(17);
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
    done_bus = o_done & o_done & o_done & o_done & o_done & o_done & o_done & o_done

    -- displayed values are always the and between the actual value and the done_bus
    o_z0 <= done_bus and z0_one;
    o_z1 <= done_bus and z1_one;
    o_z2 <= done_bus and z2_one;
    o_z3 <= done_bus and z3_one;

end Behavioral;

architecture Behavioral of datapath is

    -- i_w and i_start signal coming out from the first register
    signal w_star : std_logic;
    signal load_w_star : std_logic; --loading signal

    -- counter computed value
    signal counter : std_logic_vector (0 to 4) := "00000";

    -- 18 bits bus coming out from the demultiplexer
    signal w_bus : std_logic_vector (0 to 17) := "000000000000000000";

    -- 2 bit representing the output channel selected
    signal cnl_select : std_logic_vector (0 to 1) := "00";

    -- value coming out of the second multiplexer
    signal z0_star, z1_star, z2_star, z3_star : std_logic_vector (0 to 7);

    -- value stored for the output
    signal z0_one, z1_one, z2_one, z3_one : std_logic_vector (0 to 7);
    signal load_z : std_logic; -- loading signal

    -- done bus signal used to mask and reveal the output values
    signal done_bus : std_logic_vector (0 to 7);

begin

    -- input register, it acquires the input i_w as long as i_start is 1 and outputs it on w_star 
    w_star <= i_start and i_w;

    -- counter 0 to 17
    process(i_clk, i_rst, i_start)
    begin
        if(i_rst = '1' or i_start = '0') then
            counter <= "00000";
        elsif(i_clk'event and i_clk = '1' and i_start = '1') then
            counter <= counter + "00001";
        end if;
    end process;

    -- demultiplexer 1
    process(i_clk, counter, i_start)
    begin
        if (i_start = '1') then
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
            if(counter = "00000") then
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
            if(counter = "00001") then
                cnl_select(0) <= w_bus(1);
            end if;
        end if;
    end process;

    -- address register 2
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(15) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00010") then
                o_mem_addr(15) <= w_bus(2);
            end if;
        end if;
    end process;

    -- address register 3
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(14) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00011") then
                o_mem_addr(14) <= w_bus(3);
            end if;
        end if;
    end process;

    -- address register 4
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(13) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00100") then
                o_mem_addr(13) <= w_bus(4);
            end if;
        end if;
    end process;

    -- address register 5
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(12) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00101") then
                o_mem_addr(12) <= w_bus(5);
            end if;
        end if;
    end process;

    -- address register 6
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(11) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00110") then
                o_mem_addr(11) <= w_bus(6);
            end if;
        end if;
    end process;

    -- address register 7
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(10) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "00111") then
                o_mem_addr(10) <= w_bus(7);
            end if;
        end if;
    end process;

    -- address register 8
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(9) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01000") then
                o_mem_addr(9) <= w_bus(8);
            end if;
        end if;
    end process;

    -- address register 9
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(8) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01001") then
                o_mem_addr(8) <= w_bus(9);
            end if;
        end if;
    end process;

    -- address register 10
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(7) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01010") then
                o_mem_addr(7) <= w_bus(10);
            end if;
        end if;
    end process;

    -- address register 11
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(6) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01011") then
                o_mem_addr(6) <= w_bus(11);
            end if;
        end if;
    end process;

    -- address register 12
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(5) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01100") then
                o_mem_addr(5) <= w_bus(12);
            end if;
        end if;
    end process;

    -- address register 13
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(4) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01101") then
                o_mem_addr(4) <= w_bus(13);
            end if;
        end if;
    end process;

    -- address register 14
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(3) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01110") then
                o_mem_addr(3) <= w_bus(14);
            end if;
        end if;
    end process;

    -- address register 15
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(2) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "01111") then
                o_mem_addr(2) <= w_bus(15);
            end if;
        end if;
    end process;

    -- address register 16
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(1) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "10000") then
                o_mem_addr(1) <= w_bus(16);
            end if;
        end if;
    end process;

    -- address register 17
    process (i_rst, i_clk)
    begin
        if(i_rst = '1') then
            o_mem_addr(0) <= '0';
        elsif (i_clk'event and i_clk = '1') then
            if(counter = "10001") then
                o_mem_addr(0) <= w_bus(17);
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

end Behavioral;