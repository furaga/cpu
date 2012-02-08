library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
	Port (
		MCLK1 : in  STD_LOGIC;
		RS_RX : in  STD_LOGIC;
		RS_TX : out  STD_LOGIC
	);



end top;

architecture cpu of top is

signal clk,iclk: std_logic;

	component cpu is
	port
	(			
	CLK	:	in	std_logic;
	RESET	:	in	std_logic;
	IO65_IN	:	in	std_logic_vector (31 downto 0);
	IO64_OUT	:	out	std_logic_vector (31 downto 0)
	);				



	end component;

	--component u232c is
	  --generic (wtime: std_logic_vector(15 downto 0) := x"0001");
	  --Port ( clk  : in  STD_LOGIC;
			 --data : in  STD_LOGIC_VECTOR (7 downto 0);
			 --go   : in  STD_LOGIC;
			 --busy : out STD_LOGIC;
			 --tx   : out STD_LOGIC);
	--end component;

	signal reset : std_logic := '1';
	signal send_data : std_logic_vector(31 downto 0);
	signal count : std_logic_vector(3 downto 0) := "1111";

begin


--ib: IBUFG port map (i=>MCLK1, o=>iclk);
--bg: BUFG port map (i=>iclk, o=>clk);
clk <= MCLK1;


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

	cpunit : cpu port map (
				CLK => clk,
				RESET => reset,
				IO65_IN  => (others=>'0'),
				IO64_OUT  => send_data);


	--send_u : u232c port map (
				--clk =>clk,
				--data=>send_in(7 downto 0),
				--go=>send_go,
				--busy=>send_busy,
				--tx=>RS_TX);
end cpu;




