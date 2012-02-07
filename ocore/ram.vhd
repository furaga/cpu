library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity ram is
	port (
		CLK_MA		: in	std_logic;
		RAM_WEN		: in	std_logic;
		ADDR		: in	std_logic_vector(19 downto 0);
		DATA_IN		: in	std_logic_vector(31 downto 0);
		DATA_OUT	: out	std_logic_vector(31 downto 0);
		IO65_IN		: in	std_logic_vector(31 downto 0);
		IO64_OUT	: out	std_logic_vector(31 downto 0)
	);


end ram;

architecture behavior of ram is
	subtype ram_word is std_logic_vector(31 downto 0);
	type ram_array is array (0 to 65) of ram_word;

	signal ram_data : ram_array;
	signal addr_in	: integer range 0 to 65;


begin

	addr_in <= conv_integer(ADDR);
	process(CLK_MA)
	begin
		if (rising_edge(CLK_MA)) then
			if (RAM_WEN='1') then
				if (ADDR(6) = '0') then
					ram_data(addr_in) <= DATA_IN;
				elsif (addr_in = 64) then
					IO64_OUT <= DATA_IN;
				end if;
			end if;
		end if;
	end process;

	process(RAM_WEN, addr_in)
	begin
		if (RAM_WEN='0') then
			if (ADDR(6)='0') then
				DATA_OUT <= ram_data(addr_in);
			elsif (ADDR=65) then
				DATA_OUT <= IO65_IN;
			else
				DATA_OUT <= (others=>'0');
			end if;
		end if;
	end process;
end behavior;




