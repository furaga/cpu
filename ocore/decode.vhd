library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity decode is
port (
	CLK_DC	:	in	std_logic;
	PROM_OUT	:	in std_logic_vector(31 downto 0);
	FP_OUT	:	in std_logic_vector(31 downto 0);
	LINK_OUT	:	in std_logic_vector(31 downto 0);
	IR	: out std_logic_vector(31 downto 0);
	FP	:	out std_logic_vector(19 downto 0);
	LR	:	out std_logic_vector(31 downto 0)
);


end decode;

architecture RTL of decode is


begin
	process(CLK_DC)
	begin
		if rising_edge(CLK_DC) then
			IR <= PROM_OUT;
			FP <= FP_OUT(19 downto 0);
			LR <= LINK_OUT(31 downto 0);
		end if;
	end process;
end RTL;



