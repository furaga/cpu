library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;

--library UNISIM;
--use UNISIM.VComponents.all;
entity top is
	port (
		MCLK1 : in  STD_LOGIC;
		RS_RX : in  STD_LOGIC;
		RS_TX : out  STD_LOGIC
	);


end top;
architecture board of top is
	component core_c is
	port
	(			
	CLK	:	in	std_logic;
	CLK2X	:	in	std_logic;
	RESET	:	in	std_logic;
	NYET	:	in	std_logic;
	IO_IN	:	in	std_logic_vector(31 downto 0);
	IO_WR	:	out std_logic;
	IO_RD	:	out std_logic;
	IO_OUT	:	out	std_logic_vector(31 downto 0)
	);				


	end component;
	component io_dev is
	port(
		CLK		:	in	std_logic;
		CPU_WR	:	in	std_logic;
		CPU_RD	:	in	std_logic;
		CPU_OUT	:	in	std_logic_vector(31 downto 0);
		CPU_IN	:	out	std_logic_vector(31 downto 0);
		NYET	:	out std_logic;
		RS_RX	:	in	std_logic;
		RS_TX	:	out	std_logic
	);



	end component;

	signal reset : std_logic := '1';
	signal count : std_logic_vector(3 downto 0) := "1111";
	signal read_ready : std_logic;

	signal cpu_out : std_logic_vector(31 downto 0);
	signal cpu_in : std_logic_vector(31 downto 0);
	signal cpu_wr :std_logic;
	signal cpu_rd :std_logic;

	signal io_ren :std_logic;
	signal nyet   :std_logic;
	signal pipe   :std_logic;

	signal clk,iclk : std_logic;
	signal clk_dly, clk0,clk2,clk2x : std_logic;

begin

	--ib: IBUFG port map (i=>MCLK1, o=>iclk);
	--bg1: BUFG port map (i=>clk0, o=>clk);
	--bg2: BUFG port map (i=>clk2, o=>clk2x);
	--dll: CLKDLL port map (
		  --CLK0 => clk0,
		  --CLK180 => open,
		  --CLK270 => open,
		  --CLK2X => clk2,
		  --CLK90 => open,
		  --CLKDV => open,
		  --LOCKED => open,
		  --CLKFB => clk,
		  --CLKIN => iclk,
		  --RST => '0'
	--);
	clk <= MCLK1;
	clkgen: process
	begin
	---- initialize with '1' or '0'?
		clk2x<='1';
		wait for 0.5 ns;
		clk2x<='0';
		wait for 0.5 ns;
	end process;

	cpunit : core_c port map(clk, clk2x, reset, nyet, cpu_in, cpu_wr, cpu_rd, cpu_out);
	--iounit : io_dev port map (clk, cpu_wr, cpu_rd, cpu_out, cpu_in, nyet, RS_RX, RS_TX);
			-- normal style.
	iounit : io_dev port map (clk, cpu_wr, cpu_rd, cpu_out, cpu_in, nyet, '1', RS_TX);  
			-- no input. recvbuf is already filled with sld data.
	--iounit : io_dev port map (clk, cpu_wr, cpu_rd, cpu_out, cpu_in, nyet, pipe, pipe);
			-- like loopback.

	count_down: process(clk, count)
	begin
		if rising_edge(clk) then
			case count  is
				when "0000"=>
					count <= count;
					reset <= '0';
				when others =>
					count <= count - 1;
			end case;
		end if;
	end process;

end board;




