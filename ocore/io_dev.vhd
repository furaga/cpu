library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;

entity io_dev is
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

	type sendbuf_t is array (0 to 16383) of buf_rec_t;
	signal sendbuf : sendbuf_t;
	signal send_head	: std_logic_vector(13 downto 0) := (others=>'0');
	signal send_tail	: std_logic_vector(13 downto 0) := (others=>'0');

	signal send_empty : std_logic := '0';

	signal recv_head	: std_logic_vector(10 downto 0) := (others=>'0');
	signal recv_tail	: std_logic_vector(10 downto 0) := conv_std_logic_vector(2000, 11);
	type recvbuf_t is array (0 to 2047) of buf_rec_t;

	--signal recvbuf : recvbuf_t;
	signal recvbuf : recvbuf_t := (
x"c2", x"8c", x"00", x"00", x"42", x"0c", x"00", x"00", 
x"c1", x"a0", x"00", x"00", x"41", x"a0", x"00", x"00", 
x"41", x"f0", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"42", x"48", x"00", x"00", x"42", x"48", x"00", x"00", 
x"43", x"7f", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"a0", x"00", x"00", 
x"41", x"a0", x"00", x"00", x"42", x"82", x"00", x"00", 
x"00", x"00", x"00", x"00", x"41", x"a0", x"00", x"00", 
x"42", x"34", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"00", x"00", x"00", x"43", x"52", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"c8", x"00", x"00", 
x"42", x"20", x"00", x"00", x"42", x"8c", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"42", x"20", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"00", x"00", x"00", x"43", x"52", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"41", x"f0", x"00", x"00", x"41", x"f0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c0", x"a0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"bf", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"00", x"00", x"00", x"43", x"53", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"a0", x"00", x"00", 
x"41", x"20", x"00", x"00", x"41", x"f0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c1", x"20", x"00", x"00", 
x"42", x"a0", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"00", x"00", x"00", x"43", x"53", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"02", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"bf", x"c0", x"00", x"00", x"bf", x"80", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"42", x"48", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"00", x"00", x"00", x"43", x"53", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"b0", x"00", x"00", 
x"41", x"e0", x"00", x"00", x"41", x"e0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c0", x"a0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"00", x"00", x"00", x"00", x"43", x"53", x"00", x"00", 
x"43", x"53", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"42", x"20", x"00", x"00", 
x"41", x"e0", x"00", x"00", x"41", x"e0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c0", x"a0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"00", x"00", x"00", x"00", x"43", x"53", x"00", x"00", 
x"43", x"53", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"41", x"70", x"00", x"00", x"41", x"70", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c0", x"a0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"bf", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"00", x"00", x"00", x"00", x"43", x"53", x"00", x"00", 
x"43", x"53", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"70", x"00", x"00", 
x"41", x"c8", x"00", x"00", x"41", x"c8", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c0", x"a0", x"00", x"00", 
x"42", x"8c", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"53", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"40", x"a0", x"00", x"00", 
x"41", x"30", x"00", x"00", x"42", x"34", x"00", x"00", 
x"00", x"00", x"00", x"00", x"42", x"0c", x"00", x"00", 
x"42", x"20", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"53", x"00", x"00", x"43", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"f0", x"00", x"00", 
x"42", x"34", x"00", x"00", x"42", x"96", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"42", x"20", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"53", x"00", x"00", x"43", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"c8", x"00", x"00", 
x"42", x"24", x"00", x"00", x"42", x"8c", x"00", x"00", 
x"00", x"00", x"00", x"00", x"40", x"a0", x"00", x"00", 
x"42", x"20", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"42", x"c8", x"00", x"00", 
x"40", x"a0", x"00", x"00", x"43", x"48", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c2", x"0c", x"00", x"00", 
x"43", x"16", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"48", x"00", x"00", x"43", x"48", x"00", x"00", 
x"43", x"48", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"c8", x"00", x"00", 
x"41", x"20", x"00", x"00", x"41", x"20", x"00", x"00", 
x"00", x"00", x"00", x"00", x"c0", x"a0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"7a", x"00", x"00", 
x"43", x"53", x"00", x"00", x"43", x"00", x"00", x"00", 
x"43", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"02", 
x"00", x"00", x"00", x"00", x"41", x"c8", x"00", x"00", 
x"41", x"a0", x"00", x"00", x"41", x"a0", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"42", x"8c", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3e", x"99", x"99", x"9a", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"43", x"7f", x"00", x"00", x"00", x"00", x"00", x"02", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"00", x"41", x"a0", x"00", x"00", 
x"41", x"a0", x"00", x"00", x"41", x"a0", x"00", x"00", 
x"42", x"c8", x"00", x"00", x"42", x"20", x"00", x"00", 
x"42", x"f0", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3f", x"80", x"00", x"00", x"43", x"16", x"00", x"00", 
x"43", x"7f", x"00", x"00", x"43", x"7f", x"00", x"00", 
x"43", x"7f", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"02", x"00", x"00", x"00", x"02", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"bf", x"80", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"43", x"48", x"00", x"00", x"3f", x"80", x"00", x"00", 
x"3e", x"4c", x"cc", x"cd", x"00", x"00", x"00", x"00", 
x"43", x"7f", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"ff", x"ff", x"ff", x"ff", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"02", x"ff", x"ff", x"ff", x"ff", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"01", 
x"00", x"00", x"00", x"04", x"ff", x"ff", x"ff", x"ff", 
x"00", x"00", x"00", x"05", x"00", x"00", x"00", x"06", 
x"00", x"00", x"00", x"07", x"ff", x"ff", x"ff", x"ff", 
x"00", x"00", x"00", x"08", x"ff", x"ff", x"ff", x"ff", 
x"00", x"00", x"00", x"09", x"00", x"00", x"00", x"0a", 
x"ff", x"ff", x"ff", x"ff", x"00", x"00", x"00", x"0c", 
x"ff", x"ff", x"ff", x"ff", x"00", x"00", x"00", x"0d", 
x"ff", x"ff", x"ff", x"ff", x"00", x"00", x"00", x"0e", 
x"ff", x"ff", x"ff", x"ff", x"00", x"00", x"00", x"0f", 
x"ff", x"ff", x"ff", x"ff", x"00", x"00", x"00", x"10", 
x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", x"ff", 
x"00", x"00", x"00", x"0b", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"02", 
x"00", x"00", x"00", x"03", x"00", x"00", x"00", x"04", 
x"00", x"00", x"00", x"06", x"ff", x"ff", x"ff", x"ff", 
x"00", x"00", x"00", x"63", x"00", x"00", x"00", x"09", 
x"00", x"00", x"00", x"08", x"00", x"00", x"00", x"07", 
x"00", x"00", x"00", x"05", x"ff", x"ff", x"ff", x"ff", 
x"ff", x"ff", x"ff", x"ff", x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"

	);
	signal u232c_o : std_logic_vector(7 downto 0);
	signal u232c_i : std_logic_vector(7 downto 0);

	signal send_go : std_logic;
	signal send_busy : std_logic := '0';

	signal recv_ready : std_logic;

	
begin
	
	rs232c: u232c generic map (wtime=>x"0000")
	port map (clk, u232c_o, send_go, send_busy, RS_TX, 
				   u232c_i, recv_ready, RS_RX);

------------------------------------------------------------------------
---- send
------------------------------------------------------------------------
	send_empty <= '1' when send_head=send_tail else '0';
	send: process(CLK)
	begin
		if rising_edge(CLK) then
			if CPU_WR='1' then
				sendbuf(conv_integer(send_tail)) <= CPU_OUT(7 downto 0);
				send_tail <= send_tail + 1;
			end if;

			if send_busy='0' and send_go='0' then
				u232c_o <= sendbuf(conv_integer(send_head));
				send_go<=not send_empty;
				send_head <= send_head + conv_integer(not send_empty);
			else
				send_go<='0';
			end if;
		end if;
	end process;

------------------------------------------------------------------------
---- recv
------------------------------------------------------------------------
	NYET <= '1' when recv_head=recv_tail else '0';
	receive : process(CLK)
	begin
		if rising_edge(CLK) then
			if CPU_RD='1' then
				CPU_IN <= x"000000"&recvbuf(conv_integer(recv_head));
				recv_head <= recv_head+1;
			end if;

			if recv_ready='1' then
				recvbuf(conv_integer(recv_tail))<=u232c_i;
				recv_tail <= recv_tail+1;
			end if;
		end if;
	end process;


end RTL;



