library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity ram is
	port (
		CLKA		: in	std_logic;
		WEA			: in	std_logic_vector(0 downto 0);
		ADDRA		: in	std_logic_vector(11 downto 0);
		DINA		: in	std_logic_vector(31 downto 0);
		DOUTA		: out	std_logic_vector(31 downto 0)
	);


end ram;

architecture RTL of ram is
	subtype ram_rec_t is std_logic_vector(31 downto 0);
	type ram_array_t is array (0 to 4095) of ram_rec_t;
	signal addr_in	: integer range 0 to 4095;

	signal ram_data : ram_array_t;
	signal pre_wea : std_logic_vector(0 downto 0);
	signal data_in : std_logic_vector(31 downto 0);

begin
	ram_sim: process(CLKA)
	begin
		if rising_edge(CLKA) then
			pre_wea(0) <= WEA(0);
			addr_in <= conv_integer(ADDRA);
			data_in <= DINA;
			if pre_wea(0)='1' then
				ram_data(addr_in) <= data_in;
			else
				DOUTA <= ram_data(addr_in);
			end if;
		end if;
	end process;

end RTL;




