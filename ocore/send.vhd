library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity send is
port(
	CLK		:	in	std_logic;
	RESET	:	in	std_logic;
	CPU_GO	:	in	std_logic;
	CPU_OUT	:	in	std_logic_vector(7 downto 0);
	RS_RX	:	in	std_logic;
	RS_TX	:	out	std_logic
);



end send;

architecture beh of send is
	component u232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
  Port ( clk  : in  std_logic;
		 send_data : in  std_logic_vector (7 downto 0);
		 send_go   : in  std_logic;
		 send_busy : out std_logic;
		 tx   : out std_logic;
		 recv_data : out std_logic_vector (7 downto 0);
		 recv_go   : in  std_logic;
		 recv_busy : out std_logic;
		 rx   : in std_logic
		);
	end component;

	subtype buf_rec_t is std_logic_vector(7 downto 0);
	type sendbuf_t is array (0 to 1023) of buf_rec_t;
	signal sendbuf : sendbuf_t;
	signal head	: integer range 0 to 1023 := 0;
	signal tail	: integer range 0 to 1023 := 0;

	signal rom_o : std_logic_vector(7 downto 0);
	signal rom_i : std_logic_vector(7 downto 0);
	signal send_go : std_logic;
	signal recv_go : std_logic;
	signal empty : std_logic := '0';
	signal send_busy : std_logic := '0';
	signal recv_busy : std_logic := '0';

	signal state : std_logic := '0';
	
begin
	rs232c: u232c generic map (wtime=>x"0000")
	port map (clk, rom_o, send_go, send_busy, RS_TX,
				rom_i, recv_go,recv_busy, RS_RX);

	enqueue : process(clk, CPU_GO, CPU_OUT)
	begin
		if rising_edge(clk) then
			if CPU_GO='1' then
				sendbuf(tail) <= CPU_OUT;
				tail <= tail + 1;
			end if;
		end if;
	end process;

	empty <= '1' when head=tail else '0';
	dequeue: process(clk, send_busy)
	begin
		if rising_edge(clk) then
			rom_o <= sendbuf(head);
			if send_busy='0' and send_go='0' then
				send_go<=not empty;
				head <= head + conv_integer(not empty);
			else
				send_go<='0';
			end if;
		end if;
	end process;

end beh;



