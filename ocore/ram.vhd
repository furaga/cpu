library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity ram is
	port (
		CLK		: in	std_logic;
		CLK_MA		: in	std_logic;
		RAM_WEN		: in	std_logic;
		ADDR		: in	std_logic_vector(19 downto 0);
		DATA_IN		: in	std_logic_vector(31 downto 0);
		DATA_OUT	: out	std_logic_vector(31 downto 0);
		IO_IN		: in	std_logic_vector(31 downto 0);
		IO_WR		: out	std_logic := '0';
		IO_RD		: out	std_logic := '0';
		IO_OUT	: out	std_logic_vector(31 downto 0)
	);


end ram;

architecture behavior of ram is
	subtype ram_rec_t is std_logic_vector(31 downto 0);
	type ram_array_t is array (0 to 4095) of ram_rec_t;
	signal ram_data : ram_array_t;
	signal addr_in	: integer range 0 to 4095;
	signal io_write : std_logic := '0';
	signal io_read : std_logic := '0';

begin

	addr_in <= conv_integer(ADDR(13 downto 2));

------------------------------------------------------------------------
-- pulse for I/O
------------------------------------------------------------------------
	process (CLK, CLK_MA, io_write, io_read)
	begin 
		if rising_edge(CLK) then
			if clk_ma='1' then
				IO_WR <= io_write;
				IO_RD <= io_read;
			else
				IO_WR <= '0';
				IO_RD <= '0';
			end if;
		end if;
	end process;

	process(CLK_MA)
	begin
		if (rising_edge(CLK_MA)) then
			if RAM_WEN='1' then
------------------------------------------------------------------------
-- write to ram
------------------------------------------------------------------------
				io_read <= '0';
				if ADDR(19)='1' and ADDR(0)='1' then
					io_write <= '1';
					IO_OUT <= x"000000"&DATA_IN(7 downto 0);
				else
					io_write <= '0';
					ram_data(addr_in) <= DATA_IN;
				end if;
			else ---- RAM_WEN='0'
------------------------------------------------------------------------
-- read from ram
------------------------------------------------------------------------
				io_write <= '0';
				if (RAM_WEN='0') then
					if ADDR(19)='1' and ADDR(0)='0'then
						io_read <= '1';
						DATA_OUT <= IO_IN;
					else
						io_read <= '0';
						DATA_OUT <= ram_data(addr_in);
					end if;
				end if;
			end if;
		end if;
	end process;
end behavior;




