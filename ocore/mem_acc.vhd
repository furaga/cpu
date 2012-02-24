library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity mem_acc is
	port (
		CLK_EX_DLY	: in	std_logic;
		CLK_MA		: in	std_logic;
		RAM_WEN		: in	std_logic;
		ADDR		: in	std_logic_vector(19 downto 0);
		DATA_IN		: in	std_logic_vector(31 downto 0);
		DATA_OUT	: out	std_logic_vector(31 downto 0);
		IO_IN		: in	std_logic_vector(31 downto 0);
		IO_WR		: out	std_logic := '0';
		IO_RD		: out	std_logic := '0';
		IO_OUT	: out	std_logic_vector(31 downto 0);
		SRAM_ZA	:	out std_logic_vector(19 downto 0);
		SRAM_XWA:	out std_logic := '1';
		SRAM_ZD	:	inout std_logic_vector(31 downto 0)
	);



end mem_acc;

architecture behavior of mem_acc is
	signal io_write : std_logic := '0';
	signal io_read : std_logic := '0';
	signal io_en : std_logic;

	signal xwa, pre_xwa : std_logic;


begin

	io_en <= ADDR(19);
	xwa	<= io_en or (not RAM_WEN);

	DATA_OUT <= IO_IN when io_read='1' else SRAM_ZD;

	process(CLK_EX_DLY)
	begin
		if rising_edge(CLK_EX_DLY) then
			io_read  <= io_en and (not RAM_WEN);
			io_write <= io_en and RAM_WEN;

			SRAM_ZA <= "000"&ADDR(18 downto 2);
			SRAM_XWA <= xwa;
			pre_xwa <= xwa;

			if io_en='1' and RAM_WEN='1' then
				IO_OUT <= DATA_IN;
			end if;

		end if;
	end process;

	process(CLK_MA)
	begin
		if rising_edge(CLK_MA) then
			if xwa='0' then -- write
				SRAM_ZD <= DATA_IN;
			else
				SRAM_ZD <= (others=>'Z');
			end if;

		end if;
	end process;

	IO_WR <= io_write and CLK_EX_DLY;
	IO_RD <= io_read and CLK_EX_DLY;

end behavior;




