library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;

entity io_dev is
	port(
		CLK		:	in	std_logic;
		CPU_WR	:	in	std_logic_vector(1 downto 0);
		CPU_RD	:	in	std_logic_vector(1 downto 0);
		CPU_OUT	:	in	std_logic_vector(31 downto 0);
		CPU_IN	:	out	std_logic_vector(31 downto 0);
		NYET	:	out std_logic_vector(1 downto 0);
		RS_RX	:	in	std_logic;
		RS_TX	:	out	std_logic
	);



end io_dev;

architecture RTL of io_dev is
	component u232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
  Port ( clk  : in  std_logic;
		 send_data : in  std_logic_vector (7 downto 0);
		 send_go   : in  std_logic;
		 send_busy : out std_logic;
		 tx   : out std_logic;
		 recv_data : out std_logic_vector (7 downto 0);
		 recv_ready : out std_logic;
		 rx   : in std_logic
		);


	end component;
	subtype buf_rec_t is std_logic_vector(7 downto 0);

	-- (4 * 4096) = 16384 bytes
	type sendbuf_t is array (0 to 4095) of buf_rec_t;
	signal sendbuf0 : sendbuf_t;
	signal sendbuf1 : sendbuf_t;
	signal sendbuf2 : sendbuf_t;
	signal sendbuf3 : sendbuf_t;
	signal send_head	: std_logic_vector(13 downto 0) := (others=>'0');
	signal send_tail	: std_logic_vector(13 downto 0) := (others=>'0');
	signal sheadi	: integer range 0 to 4095;
	signal staili	: integer range 0 to 4095;
	signal send_empty : std_logic := '0';

	-- (4 * 512) = 2048 bytes
	type recvbuf_t is array (0 to 511) of buf_rec_t;
	signal recv_head	: std_logic_vector(10 downto 0) := (others=>'0');
	signal recv_tail	: std_logic_vector(10 downto 0) := (others=>'0');
	signal rheadi	: integer range 0 to 511;
	signal rtaili	: integer range 0 to 511;
	signal recvbuf0 : recvbuf_t;
	signal recvbuf1 : recvbuf_t;
	signal recvbuf2 : recvbuf_t;
	signal recvbuf3 : recvbuf_t;
	--signal recvbuf : recvbuf_t := (
	--);

	signal u232c_o : std_logic_vector(7 downto 0);
	signal u232c_i : std_logic_vector(7 downto 0);

	signal send_go : std_logic := '0';
	signal send_busy : std_logic := '0';
	signal recv_ready : std_logic;

	signal nyetb : std_logic;
	signal nyetw : std_logic;
	
begin
	
	rs232c: u232c generic map (wtime=>x"0000")
	port map (clk, u232c_o, send_go, send_busy, RS_TX, 
				   u232c_i, recv_ready, RS_RX);

------------------------------------------------------------------------
---- send
------------------------------------------------------------------------
	sheadi <= conv_integer(send_head(13 downto 2));
	staili <= conv_integer(send_tail(13 downto 2));

	send_empty <= '1' when send_head=send_tail else '0';
	send: process(CLK)
	begin
		if rising_edge(CLK) then
			if CPU_WR="10" then
				send_tail <= send_tail + 1;
				case send_tail(1 downto 0) is
					when "00" =>
						sendbuf0(staili) <= CPU_OUT(7 downto 0);
					when "01" =>
						sendbuf1(staili) <= CPU_OUT(7 downto 0);
					when "10" =>
						sendbuf2(staili) <= CPU_OUT(7 downto 0);
					when "11" =>
						sendbuf3(staili) <= CPU_OUT(7 downto 0);
					when others =>
				end case;
			elsif CPU_WR="11" then
				send_tail <= send_tail + 4;
				case send_tail(1 downto 0) is
					when "00" =>
						sendbuf0(staili) <= CPU_OUT(7 downto 0);
						sendbuf1(staili) <= CPU_OUT(15 downto 8);
						sendbuf2(staili) <= CPU_OUT(23 downto 16);
						sendbuf3(staili) <= CPU_OUT(31 downto 24);
					when "01" =>
						sendbuf0(staili+1) <= CPU_OUT(7 downto 0);
						sendbuf1(staili)   <= CPU_OUT(15 downto 8);
						sendbuf2(staili)   <= CPU_OUT(23 downto 16);
						sendbuf3(staili)   <= CPU_OUT(31 downto 24);
					when "10" =>
						sendbuf0(staili+1) <= CPU_OUT(7 downto 0);
						sendbuf1(staili+1) <= CPU_OUT(15 downto 8);
						sendbuf2(staili)   <= CPU_OUT(23 downto 16);
						sendbuf3(staili)   <= CPU_OUT(31 downto 24);
					when "11" =>
						sendbuf0(staili+1) <= CPU_OUT(7 downto 0);
						sendbuf1(staili+1) <= CPU_OUT(15 downto 8);
						sendbuf2(staili+1) <= CPU_OUT(23 downto 16);
						sendbuf3(staili)   <= CPU_OUT(31 downto 24);
					when others =>
				end case;
			end if;

			if send_busy='0' and send_go='0' then
				case send_head(1 downto 0) is
					when "00" =>
						u232c_o <= sendbuf0(sheadi);
					when "01" =>
						u232c_o <= sendbuf1(sheadi);
					when "10" =>
						u232c_o <= sendbuf2(sheadi);
					when "11" =>
						u232c_o <= sendbuf3(sheadi);
					when others =>
				end case;
				send_go <= not send_empty;
				send_head <= send_head + conv_integer(not send_empty);
			else
				send_go<='0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------
---- recv
------------------------------------------------------------------------
	rheadi <= conv_integer(recv_head(10 downto 2));
	rtaili <= conv_integer(recv_tail(10 downto 2));

	NYET(1)	<= nyetw;
	NYET(0)	<= nyetb;
	nyetw	<= '1' when 
					  recv_head   =recv_tail or
					 (recv_head+1)=recv_tail or
					 (recv_head+2)=recv_tail or
					 (recv_head+3)=recv_tail
				   else '0';
	nyetb	<= '1' when recv_head=recv_tail else '0';
	receive : process(CLK)
	begin
		if rising_edge(CLK) then
			if CPU_RD="10" then
				recv_head <= recv_head+1;
				case recv_head(1 downto 0) is
					when "00" =>
						CPU_IN <= x"000000"&recvbuf0(rheadi);
					when "01" =>
						CPU_IN <= x"000000"&recvbuf1(rheadi);
					when "10" =>
						CPU_IN <= x"000000"&recvbuf2(rheadi);
					when "11" =>
						CPU_IN <= x"000000"&recvbuf3(rheadi);
					when others =>
				end case;
			elsif CPU_RD="11" then
				recv_head <= recv_head+4;
				case recv_head(1 downto 0) is
					when "00" =>
						CPU_IN(7  downto 0)  <= recvbuf0(rheadi);
						CPU_IN(15 downto 8)  <= recvbuf1(rheadi);
						CPU_IN(23 downto 16) <= recvbuf2(rheadi);
						CPU_IN(31 downto 24) <= recvbuf3(rheadi);
					when "01" =>
						CPU_IN(7  downto 0)  <= recvbuf1(rheadi);
						CPU_IN(15 downto 8)  <= recvbuf2(rheadi);
						CPU_IN(23 downto 16) <= recvbuf3(rheadi);
						CPU_IN(31 downto 24) <= recvbuf0(rheadi+1);
					when "10" =>
						CPU_IN(7  downto 0)  <= recvbuf2(rheadi);
						CPU_IN(15 downto 8)  <= recvbuf3(rheadi);
						CPU_IN(23 downto 16) <= recvbuf0(rheadi+1);
						CPU_IN(31 downto 24) <= recvbuf1(rheadi+1);
					when "11" =>
						CPU_IN(7  downto 0)  <= recvbuf3(rheadi);
						CPU_IN(15 downto 8)  <= recvbuf0(rheadi+1);
						CPU_IN(23 downto 16) <= recvbuf1(rheadi+1);
						CPU_IN(31 downto 24) <= recvbuf2(rheadi+1);
					when others =>
				end case;
			end if;

			if recv_ready='1' then
				case recv_tail(1 downto 0) is
					when "00" =>
						recvbuf0(rtaili)<=u232c_i;
					when "01" =>
						recvbuf1(rtaili)<=u232c_i;
					when "10" =>
						recvbuf2(rtaili)<=u232c_i;
					when "11" =>
						recvbuf3(rtaili)<=u232c_i;
					when others =>
				end case;
				recv_tail <= recv_tail+1;
			end if;
		end if;
	end process;


end RTL;



