library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.std_logic_1164_additional.all;
entity lzc is
	port (
		FRAC : in std_logic_vector(24 downto 0);
		COUNT : out std_logic_vector(4 downto 0);
		LSW : out std_logic_vector(4 downto 0)
		);
end lzc;

architecture RTL of lzc is
	signal zero_count: std_logic_vector(4 downto 0);
begin
	LSW <= "00000" when zero_count="00000" else 
		   zero_count - 1;
	COUNT <= zero_count;
	zero_count <=
		"00000" when FRAC(24)='1' else
		"00001" when FRAC(23)='1' else
		"00010" when FRAC(22)='1' else
		"00011" when FRAC(21)='1' else
		"00100" when FRAC(20)='1' else
		"00101" when FRAC(19)='1' else
		"00110" when FRAC(18)='1' else
		"00111" when FRAC(17)='1' else

		"01000" when FRAC(16)='1' else
		"01001" when FRAC(15)='1' else
		"01010" when FRAC(14)='1' else
		"01011" when FRAC(13)='1' else
		"01100" when FRAC(12)='1' else
		"01101" when FRAC(11)='1' else
		"01110" when FRAC(10)='1' else
		"01111" when FRAC(9)='1' else

		"10000" when FRAC(8)='1' else
		"10001" when FRAC(7)='1' else
		"10010" when FRAC(6)='1' else
		"10011" when FRAC(5)='1' else
		"10100" when FRAC(4)='1' else
		"10101" when FRAC(3)='1' else
		"10110" when FRAC(2)='1' else
		"10111" when FRAC(1)='1' else

		"11000" when FRAC(0)='1' else
		"11001"; -- 25
	
end RTL;
	
