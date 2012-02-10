library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sign is
	port ( a,b	: in  std_logic_vector(31 downto 0);
				 s	  : out std_logic);
end sign;

architecture arch of sign is

begin

	sign: process(a,b)
	begin
		if a(30 downto 23) = b(30 downto 23) then
			if a(22 downto 0) > b(22 downto 0) then
				s <= a(31);
			else 
				s <= b(31);
			end if;
		elsif a(30 downto 23) > b(30 downto 23) then
			s <= a(31);
		else
			s <= b(31);
		end if;
	end process;

end arch;
