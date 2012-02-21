library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;

entity fetch is
	port (
		CLK : in std_logic;
		CLK_FT : in std_logic;
		PC : in std_logic_vector(31 downto 0);
		PROM_OUT : out std_logic_vector(31 downto 0));



end fetch;

architecture RTL of fetch is
	component prom is
		port (
		clka : in std_logic;
		addra : in std_logic_vector(13 downto 0);
		douta : out std_logic_vector(31 downto 0));



	end component;

	signal	raw_prom_out	:	std_logic_vector(31 downto 0);

begin
	prom_u	:	prom port map(CLK, PC(13 downto 0), raw_prom_out);

	fetch: process(CLK_FT) 
	begin
		if rising_edge(CLK_FT) then
			PROM_OUT <= raw_prom_out;
		end if;
	end process;

end RTL;



