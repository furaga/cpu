library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity ram is
	port (
		CLK_MA		: in	std_logic;
		RAM_WEN		: in	std_logic;
		ADDR		: in	std_logic_vector(19 downto 0);
		DATA_IN		: in	std_logic_vector(31 downto 0);
		DATA_OUT	: out	std_logic_vector(31 downto 0);
		IO_IN		: in	std_logic_vector(31 downto 0);
		IO_WR		: out	std_logic;
		IO_RD		: out	std_logic;
		IO_OUT	: out	std_logic_vector(31 downto 0)
	);


end ram;

architecture behavior of ram is
	subtype ram_rec_t is std_logic_vector(7 downto 0);
	type ram_array_t is array (0 to 65536) of ram_rec_t;
	signal ram_data : ram_array_t;
	signal addr_in	: integer range 0 to 65537;

	signal io_write : std_logic := '0';
	signal io_read  : std_logic := '0';

begin

	addr_in <= conv_integer(ADDR);
	IO_WR <= io_write;
	IO_RD <= io_read;
------------------------------------------------------------------------
-- write to ram
------------------------------------------------------------------------
	process(CLK_MA)
	begin
		if (rising_edge(CLK_MA)) then
			if (RAM_WEN='1') then
				if (addr_in = 65537) then
					io_write <= '1';
					IO_OUT <= x"000000"&DATA_IN(7 downto 0);
				elsif (addr_in < 65532) then
					io_write <= '0';
					ram_data(addr_in + 0) <= DATA_IN(7  downto 0);
					ram_data(addr_in + 1) <= DATA_IN(15 downto 8);
					ram_data(addr_in + 2) <= DATA_IN(23 downto 16);
					ram_data(addr_in + 3) <= DATA_IN(31 downto 24);
				end if;
			end if;
		end if;
		if falling_edge(CLK_MA) then
			io_write <= '0';
		end if;
	end process;

------------------------------------------------------------------------
-- read from ram
------------------------------------------------------------------------
	process(CLK_MA, RAM_WEN, addr_in, ram_data, IO_IN)
	begin

		if rising_edge(CLK_MA) then
			if (RAM_WEN='0') then
				if (addr_in = 65536) then
					io_read <= '1';
					DATA_OUT <= IO_IN;
				elsif (addr_in < 65532) then
					io_read <= '0';
					DATA_OUT(7  downto 0)  <= ram_data(addr_in + 0);
					DATA_OUT(15 downto 8)  <= ram_data(addr_in + 1);
					DATA_OUT(23 downto 16) <= ram_data(addr_in + 2);
					DATA_OUT(31 downto 24) <= ram_data(addr_in + 3);
				else
					io_read <= '0';
					DATA_OUT <= (others=>'0');
				end if;
			end if;
		end if;
		if falling_edge(CLK_MA) then
			io_read <= '0';
		end if;
	end process;
end behavior;




