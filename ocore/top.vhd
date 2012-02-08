library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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


	component cpu is
		port
		(			
		CLK	:	in	std_logic;
		RESET	:	in	std_logic;
		IO65_IN	:	in	std_logic_vector (31 downto 0);
		IO64_OUT	:	out	std_logic_vector (31 downto 0)
		);				
	end component;

	component u232c is
	  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
	  Port ( clk  : in  STD_LOGIC;
			 data : in  STD_LOGIC_VECTOR (7 downto 0);
			 go   : in  STD_LOGIC;
			 busy : out STD_LOGIC;
			 tx   : out STD_LOGIC);
	end component;

	signal clk,iclk: std_logic;
	signal reset : std_logic := '1';
	signal cpu_o : std_logic_vector(31 downto 0);
	signal count : std_logic_vector(3 downto 0) := "1111";

	signal rom_o: std_logic_vector(7 downto 0);
	signal send_data: std_logic_vector(7 downto 0) := "00000000";
	signal send_go: std_logic;
	signal send_busy: std_logic := '0';

begin

	--ib: IBUFG port map (i=>MCLK1, o=>iclk);
	--bg: BUFG port map (i=>iclk, o=>clk);
	clk <= MCLK1;

	cpunit : cpu port map (
				CLK => clk,
				RESET => reset,
				IO65_IN  => (others=>'0'),
				IO64_OUT  => cpu_o);
	rs232c: u232c generic map (wtime=>x"0001")
	port map (
		clk=>clk,
		data=>rom_o,
		go=>send_go,
		busy=>send_busy,
		tx=>rs_tx);

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

	send_data <= cpu_o(7 downto 0);
	rom_inf: process(clk)
	begin
		if rising_edge(clk) then
			rom_o <= send_data;
		end if;
	end process;

	send_msg: process(clk)
	begin
		if rising_edge(clk) then
			if send_busy='0' and send_go='0' then
				send_go<='1';
			else
				send_go<='0';
			end if;
		end if;
	end process;

end cpu;
