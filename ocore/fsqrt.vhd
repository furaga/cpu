library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity myfsqrt is
  port (
	CLK_TABLE : in std_logic;
    I  : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));
end myfsqrt;

architecture op of myfsqrt is
	component fsqrt_table is
	  port (
		clka : in std_logic;
		addra : in std_logic_vector(9 downto 0);
		douta : out std_logic_vector(35 downto 0));
	end component;

	signal SO: std_logic;
	signal E,EO : std_logic_vector(7 downto 0);
	signal Etmp : std_logic_vector(8 downto 0);
	signal FO : std_logic_vector(22 downto 0);

	signal key : std_logic_vector(9 downto 0);
	signal table_out : std_logic_vector(35 downto 0);

	signal const23 : std_logic_vector(22 downto 0);
	signal grad13  : std_logic_vector(12 downto 0);
	signal in14    : std_logic_vector(13 downto 0);

	signal mul_ret	: std_logic_vector(27 downto 0);

begin
	O <= SO&EO&FO;
	SO <= '0';
	table : fsqrt_table port map(CLK_TABLE, key, table_out);

	E <= I(30 downto 23);
	key <= I(23 downto 14);

	const23 <= table_out(35 downto 13);
	grad13  <= table_out(12 downto 0);
	in14  	<= I(13 downto 0);
	mul_ret <= ('0'&grad13) * in14;
	FO <= const23 + ("00000000"&mul_ret(27 downto 13));
	Etmp <= 127 + ('0'&E);
	EO	<= Etmp(8 downto 1);


end op;
