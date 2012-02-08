library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity ram is
	port (
		CLK_MA		: in	std_logic;
		RAM_WEN		: in	std_logic;
		ADDR		: in	std_logic_vector(19 downto 0);
		DATA_IN		: in	std_logic_vector(31 downto 0);
		DATA_OUT	: out	std_logic_vector(31 downto 0);
		IO_IN		: in	std_logic_vector(7 downto 0);
		SEND_GO		: out	std_logic;
		IO_OUT	: out	std_logic_vector(7 downto 0)
	);


end ram;

architecture behavior of ram is
	subtype ram_rec_t is std_logic_vector(7 downto 0);
	type ram_array_t is array (0 to 16385) of ram_rec_t;
	signal ram_data : ram_array_t;
	signal addr_in	: integer range 0 to 16385;

begin

	addr_in <= conv_integer(ADDR);
------------------------------------------------------------------------
-- write to ram
------------------------------------------------------------------------
	process(CLK_MA)
	begin
		if (rising_edge(CLK_MA)) then
			if (RAM_WEN='1') then
				if (addr_in = 16385) then
					SEND_GO <= '1';
					IO_OUT <= DATA_IN(7 downto 0);
				elsif (addr_in < 16380) then
					SEND_GO <= '0';
					ram_data(addr_in + 0) <= DATA_IN(7  downto 0);
					ram_data(addr_in + 1) <= DATA_IN(15 downto 8);
					ram_data(addr_in + 2) <= DATA_IN(23 downto 16);
					ram_data(addr_in + 3) <= DATA_IN(31 downto 24);
				end if;
			end if;
		end if;
		if falling_edge(CLK_MA) then
			SEND_GO <= '0';
		end if;
	end process;

------------------------------------------------------------------------
-- read from ram
------------------------------------------------------------------------
	process(RAM_WEN, addr_in, ram_data, IO_IN)
	begin
		if (RAM_WEN='0') then
			if (addr_in = 16384) then
				DATA_OUT <= x"000000"&IO_IN;
			elsif (addr_in < 16380) then
				DATA_OUT(7  downto 0)  <= ram_data(addr_in + 0);
				DATA_OUT(15 downto 8)  <= ram_data(addr_in + 1);
				DATA_OUT(23 downto 16) <= ram_data(addr_in + 2);
				DATA_OUT(31 downto 24) <= ram_data(addr_in + 3);
			else
				DATA_OUT <= (others=>'0');
			end if;
		end if;
	end process;
end behavior;




