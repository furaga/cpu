library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;

entity clk_delay is
	port (
		CLK	:	in	std_logic;
		DIN	:	in	std_logic;
		QOUT	:	out	std_logic
	);



end clk_delay;

architecture RTL of clk_delay is

begin
	process(CLK)
	begin	
		if falling_edge(CLK) then
		   QOUT <= DIN;
		end if;
	end process;
end RTL;




