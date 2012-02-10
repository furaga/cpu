library ieee;
use ieee.std_logic_1164.all;

entity sel is
	port (a, b: in std_logic_vector(26 downto 0);
				flag: in std_logic;
				w, l:	out std_logic_vector(26 downto 0));
end sel;

architecture arch of sel is
begin

	process (a, b, flag)
	begin
		if (flag='1') then
			w <= a;				-- a is winner
			l <= b;
		else
			w <= b;
			l <= a;
		end if;
	end process;

end arch;

