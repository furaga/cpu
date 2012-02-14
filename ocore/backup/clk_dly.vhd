library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity clk_dly is
port (
	CLK	:	in	std_logic;
	DIN	:	in	std_logic;
	QOUT	:	out	std_logic);



end clk_dly;

architecture RTL of clk_dly is
begin
	process(CLK)
	begin
		if falling_edge(CLK) then
			QOUT <= DIN;
		end if;
	end process;
end RTL;




