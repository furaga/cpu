library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity decode is
port (
CLK_DC	:	in	std_logic;
PROM_OUT	:	in	std_logic_vector (31 downto 0);
IR	: out std_logic_vector (31 downto 0)
);
end decode;
architecture RTL of decode is


begin
	process(CLK_DC)
	begin
		if rising_edge(CLK_DC) then
			IR <= PROM_OUT;
		end if;
	end process;
end RTL;
