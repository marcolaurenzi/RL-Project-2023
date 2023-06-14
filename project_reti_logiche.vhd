LIBRARY IEEE;

USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY project_reti_logiche IS
	PORT (
		i_clk : IN std_logic;
		i_rst : IN std_logic;
		i_start : IN std_logic;
		i_w : IN std_logic;
 
		o_z0 : OUT std_logic_vector(7 DOWNTO 0);
		o_z1 : OUT std_logic_vector(7 DOWNTO 0);
		o_z2 : OUT std_logic_vector(7 DOWNTO 0);
		o_z3 : OUT std_logic_vector(7 DOWNTO 0);
		o_done : OUT std_logic;
 
		o_mem_addr : OUT std_logic_vector(15 DOWNTO 0);
		i_mem_data : IN std_logic_vector(7 DOWNTO 0);
		o_mem_we : OUT std_logic;
		o_mem_en : OUT std_logic
	);
END project_reti_logiche;

ARCHITECTURE Behavioral OF project_reti_logiche IS

	-- i_w and i_start signal
	SIGNAL w_star : std_logic;

	-- counter computed value
	SIGNAL counter : std_logic_vector (0 TO 4) := "00000";

	-- 18 bits bus coming out from the demultiplexer
	SIGNAL w_bus : std_logic_vector (0 TO 17) := "000000000000000000";

	-- 2 bit representing the output channel selected
	SIGNAL cnl_select : std_logic_vector (1 DOWNTO 0) := "00";
	-- value coming out of the second multiplexer
	SIGNAL z0_star, z1_star, z2_star, z3_star : std_logic_vector (0 TO 7) := "00000000";

	-- value stored for the output
	SIGNAL z0_one, z1_one, z2_one, z3_one : std_logic_vector (0 TO 7) := "00000000";
	SIGNAL load_z : std_logic; -- loading signal

	-- done bus signal used to mask and reveal the output values
	SIGNAL done_bus : std_logic_vector (0 TO 7) := "00000000";
 
	TYPE S IS (SIDLE, SRST, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, SMEM, SOUT, SREAD, SBUFF);
	SIGNAL curr_state, next_state : S;

BEGIN
	-- input register, it acquires the input i_w as long as i_start is 1 and outputs it on w_star
	w_star <= i_start AND i_w;
	o_mem_we <= '0';

	-- counter 0 to 17
	PROCESS (i_clk, i_rst, i_start)
	BEGIN
		IF (i_rst = '1') THEN
			counter <= "00000";
		ELSE
			IF (i_clk'EVENT AND i_clk = '1') THEN
				IF (i_start = '1') THEN
					counter <= counter + "00001";
				ELSE
					counter <= "00000";
				END IF;
			END IF;
		END IF;
	END PROCESS;

	-- demultiplexer 1
	PROCESS (i_clk, w_star)
		BEGIN
			IF (i_start = '1' AND i_clk'EVENT AND i_clk = '1') THEN
				IF (counter = "00000") THEN
					w_bus(0) <= w_star;
				ELSIF (counter = "00001") THEN
					w_bus(1) <= w_star;
				ELSIF (counter = "00010") THEN
					w_bus(2) <= w_star;
				ELSIF (counter = "00011") THEN
					w_bus(3) <= w_star;
				ELSIF (counter = "00100") THEN
					w_bus(4) <= w_star;
				ELSIF (counter = "00101") THEN
					w_bus(5) <= w_star;
				ELSIF (counter = "00110") THEN
					w_bus(6) <= w_star;
				ELSIF (counter = "00111") THEN
					w_bus(7) <= w_star;
				ELSIF (counter = "01000") THEN
					w_bus(8) <= w_star;
				ELSIF (counter = "01001") THEN
					w_bus(9) <= w_star;
				ELSIF (counter = "01010") THEN
					w_bus(10) <= w_star;
				ELSIF (counter = "01011") THEN
					w_bus(11) <= w_star;
				ELSIF (counter = "01100") THEN
					w_bus(12) <= w_star;
				ELSIF (counter = "01101") THEN
					w_bus(13) <= w_star;
				ELSIF (counter = "01110") THEN
					w_bus(14) <= w_star;
				ELSIF (counter = "01111") THEN
					w_bus(15) <= w_star;
				ELSIF (counter = "10000") THEN
					w_bus(16) <= w_star;
				ELSIF (counter = "10001") THEN
					w_bus(17) <= w_star;
				END IF;
			END IF;
		END PROCESS;

		-- address register 0
		PROCESS (i_rst, i_clk)
			BEGIN
				IF (i_rst = '1') THEN
					cnl_select(1) <= '0';
				ELSIF (i_clk'EVENT AND i_clk = '1') THEN
					IF (counter = "00001") THEN
						cnl_select(1) <= w_bus(0);
					END IF;
				END IF;
			END PROCESS;

			-- address register 1
			PROCESS (i_rst, i_clk)
				BEGIN
					IF (i_rst = '1') THEN
						cnl_select(0) <= '0';
					ELSIF (i_clk'EVENT AND i_clk = '1') THEN
						IF (counter = "00010") THEN
							cnl_select(0) <= w_bus(1);
						END IF;
					END IF;
				END PROCESS;

				-- address register 2-17
				PROCESS (i_rst, i_clk)
					BEGIN
						IF (i_rst = '1' or done_bus(0) = '1') THEN
							o_mem_addr <= "0000000000000000";
						ELSIF (i_clk'EVENT AND i_clk = '1') THEN
							IF (counter = "00011") THEN
								o_mem_addr(0) <= w_bus(2);
							ELSIF (counter = "00100") THEN
								o_mem_addr(0) <= w_bus(3);
								o_mem_addr(1) <= w_bus(2);
							ELSIF (counter = "00101") THEN
								o_mem_addr(0) <= w_bus(4);
								o_mem_addr(2 DOWNTO 1) <= w_bus(2 TO 3);
							ELSIF (counter = "00110") THEN
								o_mem_addr(0) <= w_bus(5);
								o_mem_addr(3 DOWNTO 1) <= w_bus(2 TO 4);
							ELSIF (counter = "00111") THEN
								o_mem_addr(0) <= w_bus(6);
								o_mem_addr(4 DOWNTO 1) <= w_bus(2 TO 5);
							ELSIF (counter = "01000") THEN
								o_mem_addr(0) <= w_bus(7);
								o_mem_addr(5 DOWNTO 1) <= w_bus(2 TO 6);
							ELSIF (counter = "01001") THEN
								o_mem_addr(0) <= w_bus(8);
								o_mem_addr(6 DOWNTO 1) <= w_bus(2 TO 7);
							ELSIF (counter = "01010") THEN
								o_mem_addr(0) <= w_bus(9);
								o_mem_addr(7 DOWNTO 1) <= w_bus(2 TO 8);
							ELSIF (counter = "01011") THEN
								o_mem_addr(0) <= w_bus(10);
								o_mem_addr(8 DOWNTO 1) <= w_bus(2 TO 9);
							ELSIF (counter = "01100") THEN
								o_mem_addr(0) <= w_bus(11);
								o_mem_addr(9 DOWNTO 1) <= w_bus(2 TO 10);
							ELSIF (counter = "01101") THEN
								o_mem_addr(0) <= w_bus(12);
								o_mem_addr(10 DOWNTO 1) <= w_bus(2 TO 11);
							ELSIF (counter = "01110") THEN
								o_mem_addr(0) <= w_bus(13);
								o_mem_addr(11 DOWNTO 1) <= w_bus(2 TO 12);
							ELSIF (counter = "01111") THEN
								o_mem_addr(0) <= w_bus(14);
								o_mem_addr(12 DOWNTO 1) <= w_bus(2 TO 13);
							ELSIF (counter = "10000") THEN
								o_mem_addr(0) <= w_bus(15);
								o_mem_addr(13 DOWNTO 1) <= w_bus(2 TO 14);
							ELSIF (counter = "10001") THEN
								o_mem_addr(0) <= w_bus(16);
								o_mem_addr(14 DOWNTO 1) <= w_bus(2 TO 15);
							ELSIF (counter = "10010") THEN
								o_mem_addr(0) <= w_bus(17);
								o_mem_addr(15 DOWNTO 1) <= w_bus(2 TO 16);
							END IF;
						END IF;
					END PROCESS;

					-- demultiplexer 2
					PROCESS (i_clk, cnl_select, i_mem_data)
						BEGIN
							z0_star <= "00000000";
							z1_star <= "00000000";
							z2_star <= "00000000";
							z3_star <= "00000000";
							IF (cnl_select = "00") THEN
								z0_star <= i_mem_data;
							ELSIF (cnl_select = "01") THEN
								z1_star <= i_mem_data;
							ELSIF (cnl_select = "10") THEN
								z2_star <= i_mem_data;
							ELSIF (cnl_select = "11") THEN
								z3_star <= i_mem_data;
							END IF;
						END PROCESS;

						-- output register 0
						PROCESS (i_rst, i_clk, load_z, cnl_select)
							BEGIN
								IF (i_rst = '1') THEN
									z0_one <= "00000000";
								ELSIF (i_clk'EVENT AND i_clk = '1' AND load_z = '1' AND cnl_select = "00") THEN
									z0_one <= z0_star;
								END IF;
							END PROCESS;

							-- output register 1
							PROCESS (i_rst, i_clk, load_z, cnl_select)
								BEGIN
									IF (i_rst = '1') THEN
										z1_one <= "00000000";
									ELSIF (i_clk'EVENT AND i_clk = '1' AND load_z = '1' AND cnl_select = "01") THEN
										z1_one <= z1_star;
									END IF;
								END PROCESS;

								-- output register 2
								PROCESS (i_rst, i_clk, load_z, cnl_select)
									BEGIN
										IF (i_rst = '1') THEN
											z2_one <= "00000000";
										ELSIF (i_clk'EVENT AND i_clk = '1' AND load_z = '1' AND cnl_select = "10") THEN
											z2_one <= z2_star;
										END IF;
									END PROCESS;

									-- output register 3
									PROCESS (i_rst, i_clk, load_z, cnl_select)
										BEGIN
											IF (i_rst = '1') THEN
												z3_one <= "00000000";
											ELSIF (i_clk'EVENT AND i_clk = '1' AND load_z = '1' AND cnl_select = "11") THEN
												z3_one <= z3_star;
											END IF;
										END PROCESS;

										-- done bus is a 8 bit bus that reflects whether the o_done signal is 1 or 0
										o_done <= done_bus(0);

										-- displayed values are always the and between the actual value and the done_bus
										o_z0 <= done_bus AND z0_one;
										o_z1 <= done_bus AND z1_one;
										o_z2 <= done_bus AND z2_one;
										o_z3 <= done_bus AND z3_one;
 
										PROCESS (i_clk, i_rst)
											BEGIN
												IF (i_rst = '1') THEN
													curr_state <= SRST;
												ELSIF i_clk'EVENT AND i_clk = '1' THEN
													curr_state <= next_state;
												END IF;
											END PROCESS;

											PROCESS (curr_state, i_clk)
												BEGIN
													load_z <= '0'; 
													o_mem_en <= '0'; 
													done_bus <= "00000000";
													CASE curr_state IS
														WHEN SIDLE => 
														WHEN SRST => 
														WHEN S0 => 
														WHEN S1 => 
														WHEN S2 => 
														WHEN S3 => 
														WHEN S4 => 
														WHEN S5 => 
														WHEN S7 => 
														WHEN S8 => 
														WHEN S9 => 
														WHEN S10 => 
														WHEN S11 => 
														WHEN S12 => 
														WHEN S13 => 
														WHEN S14 => 
														WHEN S15 => 
														WHEN S16 => 
														WHEN S17 => 
														WHEN SBUFF =>
														WHEN SMEM => 
															o_mem_en <= '1';
														WHEN SOUT => 
															load_z <= '1';
														WHEN SREAD => 
															o_mem_en <= '0';
															done_bus <= "11111111"; 
															
														WHEN OTHERS => 
 
													END CASE;
 
												END PROCESS;

												-- funzione stato prossimo
												PROCESS (curr_state, i_clk, i_rst, i_start)
													BEGIN
														next_state <= curr_state;
														CASE (curr_state) IS
															WHEN SIDLE => 
																IF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SIDLE;
																END IF;
															WHEN SRST => 
																IF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= S0;
																END IF;
															WHEN S0 => 
																IF i_start = '1' THEN
																	next_state <= S1;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSIF i_start = '0' THEN
																	next_state <= S0;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S1 => 
																IF i_start = '1' THEN
																	next_state <= S2;
																ELSIF (i_rst <= '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S2 => 
																IF i_start = '1' THEN
																	next_state <= S3;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S3 => 
																IF i_start = '1' THEN
																	next_state <= S4;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S4 => 
																IF i_start = '1' THEN
																	next_state <= S5;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S5 => 
																IF i_start = '1' THEN
																	next_state <= S6;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S6 => 
																IF i_start = '1' THEN
																	next_state <= S7;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S7 => 
																IF i_start = '1' THEN
																	next_state <= S8;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S8 => 
																IF i_start = '1' THEN
																	next_state <= S9;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S9 => 
																IF i_start = '1' THEN
																	next_state <= S10;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S10 => 
																IF i_start = '1' THEN
																	next_state <= S11;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S11 => 
																IF i_start = '1' THEN
																	next_state <= S12;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S12 => 
																IF i_start = '1' THEN
																	next_state <= S13;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S13 => 
																IF i_start = '1' THEN
																	next_state <= S14;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S14 => 
																IF i_start = '1' THEN
																	next_state <= S15;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S15 => 
																IF i_start = '1' THEN
																	next_state <= S16;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S16 => 
																IF i_start = '1' THEN
																	next_state <= S17;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
															WHEN S17 => 
																IF i_start = '1' THEN
																	next_state <= SBUFF;
																ELSIF (i_rst = '1') THEN
																	next_state <= SRST;
																ELSE
																	next_state <= SMEM;
																END IF;
													        WHEN SBUFF =>
													            next_state <= SMEM;
															WHEN SMEM => 
																next_state <= SOUT;
															WHEN SOUT => 
																next_state <= SREAD;
															WHEN SREAD => 
																next_state <= S0; 
															WHEN OTHERS => 
														END CASE;
 
													END PROCESS;

END Behavioral;