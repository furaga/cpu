library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rounding is
	port ( f		: in std_logic_vector(26 downto 0);
				 o  	: out std_logic_vector(22 downto 0));
end rounding;

architecture arch of rounding is
begin
 
	round: process(f)
		variable grs : std_logic_vector(3 downto 0);
		variable tmp : std_logic_vector(26 downto 0);
	begin
		grs := f(3 downto 0);
		case grs is
			when x"5" => tmp := f+8;
			when x"6" => tmp := f+8;
			when x"7" => tmp := f+8;
			when x"c" => tmp := f+8;
			when x"d" => tmp := f+8;
			when x"e" => tmp := f+8;
			when x"f" => tmp := f+8;
			when others => tmp := f;
		end case;
		o <= tmp(25 downto 3);
	end process;

end arch;
