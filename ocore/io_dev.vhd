library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity io_dev is
	port(
		CLK		:	in	std_logic;
		CPU_WR	:	in	std_logic;
		CPU_RD	:	in	std_logic;
		CPU_OUT	:	in	std_logic_vector(7 downto 0);
		CPU_IN	:	out	std_logic_vector(7 downto 0);
		RS_RX	:	in	std_logic;
		RS_TX	:	out	std_logic
	);



end io_dev;

architecture arch of io_dev is
	component u232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
  Port ( clk  : in  std_logic;
		 send_data : in  std_logic_vector (7 downto 0);
		 send_go   : in  std_logic;
		 send_busy : out std_logic;
		 tx   : out std_logic;
		 recv_data : out std_logic_vector (7 downto 0);
		 recv_busy : out std_logic;
		 rx   : in std_logic
		);
	end component;

	subtype buf_rec_t is std_logic_vector(7 downto 0);

	type sendbuf_t is array (0 to 1023) of buf_rec_t;
	signal sendbuf : sendbuf_t;
	signal send_head	: integer range 0 to 1023 := 0;
	signal send_tail	: integer range 0 to 1023 := 0;
	signal send_empty : std_logic := '0';

	type recvbuf_t is array (0 to 1023) of buf_rec_t;
	signal recvbuf : recvbuf_t;
	signal recv_head	: integer range 0 to 1023 := 0;
	signal recv_tail	: integer range 0 to 1023 := 0;
	signal recv_empty : std_logic := '0';

	signal u232c_o : std_logic_vector(7 downto 0);
	signal u232c_i : std_logic_vector(7 downto 0);

	signal send_go : std_logic;
	signal send_busy : std_logic := '0';

	signal recv_busy : std_logic;

	
begin
	rs232c: u232c generic map (wtime=>x"0000")
	port map (clk, u232c_o, send_go, send_busy, RS_TX, u232c_i, recv_busy, RS_RX);

	send_enqueue : process(clk, CPU_WR, CPU_OUT)
	begin
		if rising_edge(clk) then
			if CPU_WR='1' then
				sendbuf(send_tail) <= CPU_OUT;
				send_tail <= send_tail + 1;
			end if;
		end if;
	end process;

	send_empty <= '1' when send_head=send_tail else '0';
	send_dequeue: process(clk, send_busy)
	begin
		if rising_edge(clk) then
			u232c_o <= sendbuf(send_head);
			if send_busy='0' and send_go='0' then
				send_go<=not send_empty;
				send_head <= send_head + conv_integer(not send_empty);
			else
				send_go<='0';
			end if;
		end if;
	end process;

	recv_empty <= '1' when recv_head=recv_tail else '0';
	CPU_IN <= recvbuf(recv_head);
	recv_enqueue : process(recv_busy, u232c_i)
	begin
		if falling_edge(recv_busy) then
			recvbuf(recv_tail)<=u232c_i;
			recv_tail <= recv_tail+1;
		end if;
	end process;
	recv_dequeue : process(CPU_RD)
	begin
		if rising_edge(CPU_RD) then
			recv_head <= recv_head+1;
		end if;
	end process;

end arch;



