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
	signal O : std_logic_vector(31 downto 0);
	signal reset : std_logic := '1';

begin

	--ib: IBUFG port map (i=>MCLK1, o=>iclk);
	--bg: BUFG port map (i=>iclk, o=>clk);

	switch: process
	begin
		wait for 1 ns;
		reset <= '0';
	end process;

	clk <= MCLK1;
	cpunit : cpu port map (
				CLK => clk,
				RESET => reset,
				IO65_IN  => (others=>'0'),
				IO64_OUT  => O);
end cpu;
