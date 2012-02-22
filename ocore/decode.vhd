library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity decode is
port (
	CLK_DC	:	in	std_logic;
	PROM_OUT	:	in std_logic_vector(31 downto 0);
	FP_OUT	:	in std_logic_vector(31 downto 0);
	LINK_OUT	:	in std_logic_vector(31 downto 0);
	INPUT_FLAG	:	out std_logic;
	IR	: out std_logic_vector(31 downto 0);
	FP	:	out std_logic_vector(19 downto 0);
	LR	:	out std_logic_vector(31 downto 0)
);


end decode;

architecture RTL of decode is

	signal opcode : std_logic_vector(5 downto 0);
	signal funct  : std_logic_vector(5 downto 0);

begin
	opcode <= PROM_OUT(31 downto 26);
	funct  <= PROM_OUT(5 downto 0);
	process(CLK_DC)
	begin
		if rising_edge(CLK_DC) then
			IR <= PROM_OUT;
			FP <= FP_OUT(19 downto 0);
			LR <= LINK_OUT;

			if opcode="000001" and funct="000000" then -- I/O
				INPUT_FLAG <= '1';
			else
				INPUT_FLAG <= '0';
			end if;

		end if;
	end process;
end RTL;



