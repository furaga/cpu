library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity mem_acc is
	port (
		CLK2X		: in	std_logic;
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



end mem_acc;

architecture behavior of mem_acc is
	component ram is
		port (
		CLKA		: in	std_logic;
		WEA			: in	std_logic_vector(0 downto 0);
		ADDRA		: in	std_logic_vector(11 downto 0);
		DINA		: in	std_logic_vector(31 downto 0);
		DOUTA		: out	std_logic_vector(31 downto 0)
	);


	end component;

	signal io_write : std_logic := '0';
	signal io_read : std_logic := '0';
	signal io_en : std_logic;
	signal io_in_keep : std_logic_vector(31 downto 0);
	signal wea: std_logic_vector(0 downto 0) := "0";
	signal addra : std_logic_vector(11 downto 0);
	signal douta : std_logic_vector(31 downto 0);
	signal dina  : std_logic_vector(31 downto 0);

begin
	bram : ram port map (CLK2X, wea, addra, dina, douta);

	-- ADDR(0) byte or word
	io_en <= ADDR(19);
	DATA_OUT <= io_in_keep when io_read='1' else douta;

	addra <= ADDR(13 downto 2);
	dina  <= DATA_IN;

	io_read  <= io_en and (not RAM_WEN);
	io_write <= io_en and RAM_WEN;
	wea(0)	<= (not io_en) and RAM_WEN;

	process(CLK_MA)
	begin
		if rising_edge(CLK_MA) then
		-- for debug
			if io_en='1' and RAM_WEN='1' then
				IO_OUT <= x"000000"&DATA_IN(7 downto 0);
			elsif io_en='1' and RAM_WEN='0' then
				io_in_keep <= IO_IN;
			end if;
		end if;
	end process;

	process (CLK2X, clk_ma, io_write, io_read)
	begin 
		if rising_edge(CLK2X) then
			if clk_ma='1' then
				IO_WR <= io_write;
				IO_RD <= io_read;
			else
				IO_WR <= '0';
				IO_RD <= '0';
			end if;
		end if;
	end process;

end behavior;




