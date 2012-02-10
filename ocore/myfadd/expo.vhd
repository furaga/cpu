library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity expo is
	port ( a,b	: in  std_logic_vector(7 downto 0);
				 flag : out std_logic;
				 d,o	: out std_logic_vector(7 downto 0));
end expo;

architecture arch of expo is

begin

	exp: process(a, b)
	begin
		if a > b then
			d <= a - b;
			o <= a;
			flag <= '1';
		else
			d <= b - a;
			o <= b;
			flag <= '0';
		end if;
	end process;

end arch;

