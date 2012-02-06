library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity reg_wb is
port (
CLK_WB	:	in	std_logic;
RESET	:	in	std_logic;
N_REG	:	in	std_logic_vector (2 downto 0);
REG_IN	:	in	std_logic_vector (15 downto 0);
REG_WEN	:	in	std_logic;
REG_0WB	:	out	std_logic_vector (15 downto 0);
REG_1WB	:	out	std_logic_vector (15 downto 0);
REG_2WB	:	out	std_logic_vector (15 downto 0);
REG_3WB	:	out	std_logic_vector (15 downto 0);
REG_4WB	:	out	std_logic_vector (15 downto 0);
REG_5WB	:	out	std_logic_vector (15 downto 0);
REG_6WB	:	out	std_logic_vector (15 downto 0);
REG_7WB	:	out	std_logic_vector (15 downto 0)
);
end reg_wb;
architecture RTL of reg_wb is

begin
	process(CLK_WB, RESET)
	begin
	if (RESET='1') then
		REG_0WB <= (others=>'0');
		REG_1WB <= (others=>'0');
		REG_2WB <= (others=>'0');
		REG_3WB <= (others=>'0');
		REG_4WB <= (others=>'0');
		REG_5WB <= (others=>'0');
		REG_6WB <= (others=>'0');
		REG_7WB <= (others=>'0');
	elsif(CLK_WB'event and CLK_WB = '1') then
		if(REG_WEN = '1') then
			case N_REG is
				when "000" => REG_0WB <= REG_IN;	-- REG_0
				when "001" => REG_1WB <= REG_IN;	-- REG_1
				when "010" => REG_2WB <= REG_IN;	-- REG_2
				when "011" => REG_3WB <= REG_IN;	-- REG_3
				when "100" => REG_4WB <= REG_IN;	-- REG_4
				when "101" => REG_5WB <= REG_IN;	-- REG_5
				when "110" => REG_6WB <= REG_IN;	-- REG_6
				when "111" => REG_7WB <= REG_IN;	-- REG_7
				when others =>	
			end case;
		end if;
	end if;

	end process;

end RTL;
