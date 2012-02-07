library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity reg_wb is
port (
CLK_WB	:	in	std_logic;
RESET	:	in	std_logic;
N_REG	:	in	std_logic_vector (4 downto 0);
REG_IN	:	in	std_logic_vector (31 downto 0);
RAM_OUT	:	in	std_logic_vector (31 downto 0);
REG_WEN	:	in	std_logic;
FROM_RAM	:	in	std_logic;
REG_00WB	:	out	std_logic_vector (31 downto 0);
REG_01WB	:	out	std_logic_vector (31 downto 0);
REG_02WB	:	out	std_logic_vector (31 downto 0);
REG_03WB	:	out	std_logic_vector (31 downto 0);
REG_04WB	:	out	std_logic_vector (31 downto 0);
REG_05WB	:	out	std_logic_vector (31 downto 0);
REG_06WB	:	out	std_logic_vector (31 downto 0);
REG_07WB	:	out	std_logic_vector (31 downto 0);
REG_08WB	:	out	std_logic_vector (31 downto 0);
REG_09WB	:	out	std_logic_vector (31 downto 0);
REG_10WB	:	out	std_logic_vector (31 downto 0);
REG_11WB	:	out	std_logic_vector (31 downto 0);
REG_12WB	:	out	std_logic_vector (31 downto 0);
REG_13WB	:	out	std_logic_vector (31 downto 0);
REG_14WB	:	out	std_logic_vector (31 downto 0);
REG_15WB	:	out	std_logic_vector (31 downto 0);
REG_16WB	:	out	std_logic_vector (31 downto 0);
REG_17WB	:	out	std_logic_vector (31 downto 0);
REG_18WB	:	out	std_logic_vector (31 downto 0);
REG_19WB	:	out	std_logic_vector (31 downto 0);
REG_20WB	:	out	std_logic_vector (31 downto 0);
REG_21WB	:	out	std_logic_vector (31 downto 0);
REG_22WB	:	out	std_logic_vector (31 downto 0);
REG_23WB	:	out	std_logic_vector (31 downto 0);
REG_24WB	:	out	std_logic_vector (31 downto 0);
REG_25WB	:	out	std_logic_vector (31 downto 0);
REG_26WB	:	out	std_logic_vector (31 downto 0);
REG_27WB	:	out	std_logic_vector (31 downto 0);
REG_28WB	:	out	std_logic_vector (31 downto 0);
REG_29WB	:	out	std_logic_vector (31 downto 0);
REG_30WB	:	out	std_logic_vector (31 downto 0);
REG_31WB	:	out	std_logic_vector (31 downto 0)
);
end reg_wb;
architecture RTL of reg_wb is
	constant REG1_INIT : std_logic_vector(31 downto 0)
				:= x"00000111";
	signal REG_V : std_logic_vector(31 downto 0);

begin
	REG_V <= RAM_OUT when FROM_RAM='1' else REG_IN;
	
	process(CLK_WB, RESET)
	begin
	if (RESET='1') then
		REG_00WB <= (others=>'0');
		REG_01WB <= REG1_INIT;
		REG_02WB <= (others=>'0');
		REG_03WB <= (others=>'0');
		REG_04WB <= (others=>'0');
		REG_05WB <= (others=>'0');
		REG_06WB <= (others=>'0');
		REG_07WB <= (others=>'0');
		REG_08WB <= (others=>'0');
		REG_09WB <= (others=>'0');
		REG_10WB <= (others=>'0');
		REG_11WB <= (others=>'0');
		REG_12WB <= (others=>'0');
		REG_13WB <= (others=>'0');
		REG_14WB <= (others=>'0');
		REG_15WB <= (others=>'0');
		REG_16WB <= (others=>'0');
		REG_17WB <= (others=>'0');
		REG_18WB <= (others=>'0');
		REG_19WB <= (others=>'0');
		REG_20WB <= (others=>'0');
		REG_21WB <= (others=>'0');
		REG_22WB <= (others=>'0');
		REG_23WB <= (others=>'0');
		REG_24WB <= (others=>'0');
		REG_25WB <= (others=>'0');
		REG_26WB <= (others=>'0');
		REG_27WB <= (others=>'0');
		REG_28WB <= (others=>'0');
		REG_29WB <= (others=>'0');
		REG_30WB <= (others=>'0');
		REG_31WB <= (others=>'0');
	elsif(CLK_WB'event and CLK_WB = '1') then
		if(REG_WEN = '1') then
			case N_REG is
				when "00000" => REG_00WB <= x"00000000";	-- REG_0
				when "00001" => REG_01WB <= REG_V;
				when "00010" => REG_02WB <= REG_V;
				when "00011" => REG_03WB <= REG_V;
				when "00100" => REG_04WB <= REG_V;
				when "00101" => REG_05WB <= REG_V;
				when "00110" => REG_06WB <= REG_V;
				when "00111" => REG_07WB <= REG_V;
				when "01000" => REG_08WB <= REG_V;
				when "01001" => REG_09WB <= REG_V;
				when "01010" => REG_10WB <= REG_V;
				when "01011" => REG_11WB <= REG_V;
				when "01100" => REG_12WB <= REG_V;
				when "01101" => REG_13WB <= REG_V;
				when "01110" => REG_14WB <= REG_V;
				when "01111" => REG_15WB <= REG_V;
				when "10000" => REG_16WB <= REG_V;
				when "10001" => REG_17WB <= REG_V;
				when "10010" => REG_18WB <= REG_V;
				when "10011" => REG_19WB <= REG_V;
				when "10100" => REG_20WB <= REG_V;
				when "10101" => REG_21WB <= REG_V;
				when "10110" => REG_22WB <= REG_V;
				when "10111" => REG_23WB <= REG_V;
				when "11000" => REG_24WB <= REG_V;
				when "11001" => REG_25WB <= REG_V;
				when "11010" => REG_26WB <= REG_V;
				when "11011" => REG_27WB <= REG_V;
				when "11100" => REG_28WB <= REG_V;
				when "11101" => REG_29WB <= REG_V;
				when "11110" => REG_30WB <= REG_V;
				when "11111" => REG_31WB <= REG_V;

				when others =>	
			end case;
		end if;
	end if;

	end process;

end RTL;
