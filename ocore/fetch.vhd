library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity fetch is
	port (
		CLK_FT	:	in	std_logic;
		P_COUNT	:	in	std_logic_vector (31 downto 0);
		PROM_OUT	:	out	std_logic_vector (31 downto 0)
	);
end fetch;
architecture BEHAVIOR of fetch is

	subtype WORD is std_logic_vector (31 downto 0);
	type MEMORY is array (0 to 14) of WORD;
	constant MEM : MEMORY := (

x"1C600000",
x"1C800001",
x"1CA00000",
x"1CC0000A",
x"00A42820",
x"00651820",
x"28A60008",
x"08000010",
x"04600001",
x"0000003F",
x"00000000",
x"00000000",
x"00000000",
x"00000000",
x"00000000"

	 );

begin
	read_op: process(CLK_FT)
	begin
		if (CLK_FT'event and CLK_FT = '1') then
			PROM_OUT <= MEM(conv_integer(P_COUNT(30 downto 0)));
		end if;
	end process;

end BEHAVIOR;
