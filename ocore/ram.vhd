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
	type ram_array is array (0 to 4096) of ram_word;

	signal ram_data : ram_array;
	signal addr_in	: integer range 0 to 4096;


begin

	addr_in <= conv_integer(ADDR);
	process(CLK_MA)
	begin
		if (rising_edge(CLK_MA)) then
			if (RAM_WEN='1') then
				if (addr_in = 4096) then
					IO64_OUT <= DATA_IN;
				else 
					ram_data(addr_in) <= DATA_IN;
				end if;
			end if;
		end if;
	end process;

	process(RAM_WEN, addr_in, ram_data, IO65_IN)
	begin
		if (RAM_WEN='0') then
			if (addr_in = 4096) then
				DATA_OUT <= IO65_IN;
			else 
				DATA_OUT <= ram_data(addr_in);
			end if;
		end if;
	end process;
end behavior;




