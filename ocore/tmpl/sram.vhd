library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity sram is
	port (
		ZA		: in std_logic_vector(19 downto 0);	-- Address
		XWA		: in std_logic;	-- Write Enable
		ZD		: inout std_logic_vector(31 downto 0);	-- Data InOut
		ZCLKMA	: in std_logic_vector(1 downto 0)	-- clk
	);



end sram;

architecture RTL of sram is
	subtype ram_rec_t is std_logic_vector(31 downto 0);
	type ram_array_t is array (0 to 131071) of ram_rec_t;
	signal addr_in	: integer range 0 to 131071;

	signal ram_data : ram_array_t;
	signal pre_xwa : std_logic;
	signal clka : std_logic;

	signal debug : std_logic_vector(3 downto 0);
	signal debug_data0 : std_logic_vector(31 downto 0);
	signal debug_data1 : std_logic_vector(31 downto 0);

begin
	clka <= ZCLKMA(0);

	sram_sim: process(clka)
	begin
		if rising_edge(clka) then
			pre_xwa <= XWA;
			addr_in <= conv_integer(ZA(16 downto 0));
			if XWA='0' then -- write
				ZD <= (others=>'Z');
			else
				ZD <= ram_data(addr_in);
			end if;

			if pre_xwa='0' then -- pre write
				ram_data(addr_in) <= ZD;
			end if;

		end if;
	end process;

end RTL;




