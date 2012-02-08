library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

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
	RESET	:	in	std_logic;
	IO_IN	:	in	std_logic_vector(7 downto 0);
	SEND_GO	:	out std_logic;
	IO_OUT	:	out	std_logic_vector(7 downto 0)
	);				


	end component;
	component send is
port(
	CLK		:	in	std_logic;
	RESET	:	in	std_logic;
	CPU_GO	:	in	std_logic;
	CPU_OUT	:	in	std_logic_vector(7 downto 0);
	RS_TX	:	out	std_logic
);



	end component;

	signal clk,iclk: std_logic;
	signal reset : std_logic := '1';
	signal count : std_logic_vector(3 downto 0) := "1111";
	signal read_ready : std_logic;

	signal cpu_out : std_logic_vector(7 downto 0);
	signal cpu_in : std_logic_vector(7 downto 0);

	signal send_go :std_logic;
	signal io_ren :std_logic;

begin

	--ib: IBUFG port map (i=>MCLK1, o=>iclk);
	--bg: BUFG port map (i=>iclk, o=>clk);
	clk <= MCLK1;

	cpunit : core_c port map(clk, reset, cpu_in, send_go, cpu_out);
	send_u : send port map (clk, reset, send_go, cpu_out, RS_TX);

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




