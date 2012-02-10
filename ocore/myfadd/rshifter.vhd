library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rshifter is
	port ( f		: in  std_logic_vector(26 downto 0);
				 n		: in  std_logic_vector( 7 downto 0);
				 o		: out std_logic_vector(26 downto 0));
end rshifter;

architecture arch of rshifter is

begin
	rsh: process(f,n)
	begin
		case n is
			when x"00" => o<=f;
			when x"01" => o<="0"&f(26 downto 1);
			when x"02" => o<="00"&f(26 downto 2);
			when x"03" => o<="000"&f(26 downto 3);
			when x"04" => o<=x"0"&f(26 downto 4);
			when x"05" => o<="0"&x"0"&f(26 downto 5);
			when x"06" => o<="00"&x"0"&f(26 downto 6);
			when x"07" => o<="000"&x"0"&f(26 downto 7);
			when x"08" => o<=x"00"&f(26 downto 8);
			when x"09" => o<="0"&x"00"&f(26 downto 9);
			when x"0a" => o<="00"&x"00"&f(26 downto 10);
			when x"0b" => o<="000"&x"00"&f(26 downto 11);
			when x"0c" => o<=x"000"&f(26 downto 12);
			when x"0d" => o<="0"&x"000"&f(26 downto 13);
			when x"0e" => o<="00"&x"000"&f(26 downto 14);
			when x"0f" => o<="000"&x"000"&f(26 downto 15);
			when x"10" => o<=x"0000"&f(26 downto 16);
			when x"11" => o<="0"&x"0000"&f(26 downto 17);
			when x"12" => o<="00"&x"0000"&f(26 downto 18);
			when x"13" => o<="000"&x"0000"&f(26 downto 19);
			when x"14" => o<=x"00000"&f(26 downto 20);
			when x"15" => o<="0"&x"00000"&f(26 downto 21);
			when x"16" => o<="00"&x"00000"&f(26 downto 22);
			when x"17" => o<="000"&x"00000"&f(26 downto 23);
			when x"18" => o<=x"000000"&f(26 downto 24);
			when x"19" => o<="0"&x"000000"&f(26 downto 25);
			when x"1a" => o<="00"&x"000000"&f(26);
			when others => o<=(others=>'0');
		end case;
	end process;

end arch;

