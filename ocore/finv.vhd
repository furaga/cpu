library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity myfinv is
  port (
	CLK_TABLE : in std_logic;
    I  : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));
end myfinv;

architecture op of myfinv is
	component finv_table is
	  port (
		clka : in std_logic;
		addra : in std_logic_vector(9 downto 0);
		douta : out std_logic_vector(35 downto 0));
	end component;

	signal SO: std_logic;
	signal E,EO : std_logic_vector(7 downto 0);
	signal F,FO : std_logic_vector(22 downto 0);

	signal key : std_logic_vector(9 downto 0);
	signal table_out : std_logic_vector(35 downto 0);

	signal const23 : std_logic_vector(22 downto 0);
	signal grad13  : std_logic_vector(12 downto 0);
	signal in13    : std_logic_vector(12 downto 0);

	signal mul_ret	: std_logic_vector(25 downto 0);

begin
	O <= SO&EO&FO;
	SO <= I(31);
	E <= I(30 downto 23);
	F <= I(22 downto 0);
	table : finv_table port map(CLK_TABLE, key, table_out);

	key <= I(22 downto 13);
	const23 <= table_out(35 downto 13);
	grad13  <= table_out(12 downto 0);
	in13  	<= I(12 downto 0);

	mul_ret <= grad13 * in13;
	FO <= (others=>'0') when F=0 else
		  const23 - ("000000000"&mul_ret(25 downto 12));

	EO <= (others=>'1') when E=255 or E=0 else
		  (others=>'0') when E=254 else
		  254 - E when F=0 else
		  253 - E;


end op;
