library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity reg_dc is
	port (
		CLK_DC	:	in	std_logic;
		REG_0	:	in	std_logic_vector (31 downto 0);
		REG_1	:	in	std_logic_vector (31 downto 0);
		REG_2	:	in	std_logic_vector (31 downto 0);
		REG_3	:	in	std_logic_vector (31 downto 0);
		REG_4	:	in	std_logic_vector (31 downto 0);
		REG_5	:	in	std_logic_vector (31 downto 0);
		REG_6	:	in	std_logic_vector (31 downto 0);
		REG_7	:	in	std_logic_vector (31 downto 0);
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

			when "00000" => REG_OUT <= REG_0;
			when "00001" => REG_OUT <= REG_1;
			when "00010" => REG_OUT <= REG_2;
			when "00011" => REG_OUT <= REG_3;
			when "00100" => REG_OUT <= REG_4;
			when "00101" => REG_OUT <= REG_5;
			when "00110" => REG_OUT <= REG_6;
			when "00111" => REG_OUT <= REG_7;
			when others =>
		end case;
		N_REG_OUT <= N_REG_IN;
		end if;
	end process;

end RTL;
