library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity reg_dc is
	port (
		CLK_DC	:	in	std_logic;
		REG_00	:	in	std_logic_vector (31 downto 0);
		REG_01	:	in	std_logic_vector (31 downto 0);
		REG_02	:	in	std_logic_vector (31 downto 0);
		REG_03	:	in	std_logic_vector (31 downto 0);
		REG_04	:	in	std_logic_vector (31 downto 0);
		REG_05	:	in	std_logic_vector (31 downto 0);
		REG_06	:	in	std_logic_vector (31 downto 0);
		REG_07	:	in	std_logic_vector (31 downto 0);
		REG_08	:	in	std_logic_vector (31 downto 0);
		REG_09	:	in	std_logic_vector (31 downto 0);
		REG_10	:	in	std_logic_vector (31 downto 0);
		REG_11	:	in	std_logic_vector (31 downto 0);
		REG_12	:	in	std_logic_vector (31 downto 0);
		REG_13	:	in	std_logic_vector (31 downto 0);
		REG_14	:	in	std_logic_vector (31 downto 0);
		REG_15	:	in	std_logic_vector (31 downto 0);
		REG_16	:	in	std_logic_vector (31 downto 0);
		REG_17	:	in	std_logic_vector (31 downto 0);
		REG_18	:	in	std_logic_vector (31 downto 0);
		REG_19	:	in	std_logic_vector (31 downto 0);
		REG_20	:	in	std_logic_vector (31 downto 0);
		REG_21	:	in	std_logic_vector (31 downto 0);
		REG_22	:	in	std_logic_vector (31 downto 0);
		REG_23	:	in	std_logic_vector (31 downto 0);
		REG_24	:	in	std_logic_vector (31 downto 0);
		REG_25	:	in	std_logic_vector (31 downto 0);
		REG_26	:	in	std_logic_vector (31 downto 0);
		REG_27	:	in	std_logic_vector (31 downto 0);
		REG_28	:	in	std_logic_vector (31 downto 0);
		REG_29	:	in	std_logic_vector (31 downto 0);
		REG_30	:	in	std_logic_vector (31 downto 0);
		REG_31	:	in	std_logic_vector (31 downto 0);
		N_REG_IN	:	in	std_logic_vector (4 downto 0);
		N_REG_OUT	:	out	std_logic_vector (4 downto 0);
		REG_OUT	:	out	std_logic_vector (31 downto 0)
	);
end reg_dc;
architecture RTL of reg_dc is

begin
	process(CLK_DC)
	begin
		if rising_edge(clk_dc) then
		case N_REG_IN is
			when "00000" => REG_OUT <= x"00000000";
			when "00001" => REG_OUT <= REG_01;
			when "00010" => REG_OUT <= REG_02;
			when "00011" => REG_OUT <= REG_03;
			when "00100" => REG_OUT <= REG_04;
			when "00101" => REG_OUT <= REG_05;
			when "00110" => REG_OUT <= REG_06;
			when "00111" => REG_OUT <= REG_07;
			when "01000" => REG_OUT <= REG_08;
			when "01001" => REG_OUT <= REG_09;
			when "01010" => REG_OUT <= REG_10;
			when "01011" => REG_OUT <= REG_11;
			when "01100" => REG_OUT <= REG_12;
			when "01101" => REG_OUT <= REG_13;
			when "01110" => REG_OUT <= REG_14;
			when "01111" => REG_OUT <= REG_15;
			when "10000" => REG_OUT <= REG_16;
			when "10001" => REG_OUT <= REG_17;
			when "10010" => REG_OUT <= REG_18;
			when "10011" => REG_OUT <= REG_19;
			when "10100" => REG_OUT <= REG_20;
			when "10101" => REG_OUT <= REG_21;
			when "10110" => REG_OUT <= REG_22;
			when "10111" => REG_OUT <= REG_23;
			when "11000" => REG_OUT <= REG_24;
			when "11001" => REG_OUT <= REG_25;
			when "11010" => REG_OUT <= REG_26;
			when "11011" => REG_OUT <= REG_27;
			when "11100" => REG_OUT <= REG_28;
			when "11101" => REG_OUT <= REG_29;
			when "11110" => REG_OUT <= REG_30;
			when "11111" => REG_OUT <= REG_31;
			when others =>
		end case;
		N_REG_OUT <= N_REG_IN;
		end if;
	end process;

end RTL;
