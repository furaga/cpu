library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.std_logic_1164_additional.all;
entity myfmul is
  port (
	CLK_TABLE : in std_logic;
    I1, I2 : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));
end myfmul;

architecture op of myfmul is

	signal S1, S2, SO : std_logic;
	signal E1, E2, EO : std_logic_vector(8 downto 0); -- 9bit for overflow, underflow
	signal F1H, F1L, F2H, F2L : std_logic_vector(12 downto 0);
	signal FO	: std_logic_vector(22 downto 0);
	signal HH,HL,LH: std_logic_vector(25 downto 0);
	signal raw_FO : std_logic_vector(25 downto 0);
	signal raw_EO : std_logic_vector(8 downto 0);

begin
	O	<=	SO&EO(7 downto 0)&FO;
	S1	<=	I1(31);
	S2	<=	I2(31);
	E1	<=	'0'&I1(30 downto 23);
	E2	<=	'0'&I2(30 downto 23);

	F1H	<=	'1'&I1(22 downto 11);
	F1L	<=	"00"&I1(10 downto 0);
	F2H	<=	'1'&I2(22 downto 11);
	F2L	<=	"00"&I2(10 downto 0);

	SO	<=	'0'	when S1=S2 else '1';

	raw_EO	<=	(others=>'0') when E1=0 or E2=0 else
				E1 + E2 - 126 when raw_FO(25)='1' else
				E1 + E2 - 127;


	EO	<=	(others=>'0') when raw_EO(8)='1' else raw_EO;

	FO	<=	(others=>'0') when raw_EO(8)='1' else 
			raw_FO(24 downto 2) when raw_FO(25)='1' else
			raw_FO(23 downto 1);

	HH <= F1H * F2H;
	HL <= F1H * F2L;
	LH <= F1L * F2H;
	raw_FO <= HH + (HL srl 11) + (LH srl 11) + 0;


end op;
