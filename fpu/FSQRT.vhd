library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library UNIMACRO;
use unimacro.Vcomponents.all;


entity FSQRT is
    
  port (
    CLK : in std_logic;
    I1 : in  std_logic_vector (0 to 31);
    O  : out std_logic_vector (0 to 31));

end FSQRT;

architecture fsqrt_archi of FSQRT is
--指数はそのまま　仮数は2で割るので最下位ビットはkeyの方に含める。

  signal S1  : std_logic;
  signal E1  : std_logic_vector(0 to 6);
  signal DATA : std_logic_vector(35 downto 0);
  signal CONST : std_logic_vector(23 downto 0);
  signal INC : std_logic_vector(12 downto 0);
  signal KEY : std_logic_vector(0 to 9);
  signal DIST : std_logic_vector(0 to 13);

component fsqrt_table
  port (
    ADDRA : in std_logic_vector(9 downto 0);
    CLKA  : in std_logic;
    DOUTA : out std_logic_vector(35 downto 0));
end component;

  
begin  -- fsqrt_archi
  S1 <= I1(0);
  E1(0 to 6) <= I1(1 to 7);
  KEY(0 to 9) <= I1(8 to 17);
  DIST(0 to 13) <= I1(18 to 31);
  CONST(23) <= '1';
  CONST(22 downto 0) <= DATA(35 downto 13);
  INC(12 downto 0) <= DATA(12 downto 0);
  
  FSQRT_TABLE1 : fsqrt_table port map(KEY, CLK, DATA);
  
  
  E:process(CLK)
  variable SO : std_logic;
  variable EO : std_logic_vector(0 to 7);
  variable CO : std_logic_vector(0 to 23);
  variable DIFF : std_logic_vector(0 to 23);
  variable DIFF_TMP : std_logic_vector(0 to 26);
	begin
	if rising_edge(CLK) then
        DIFF(0 to 9) := conv_std_logic_vector(0, 10);
		  DIFF_TMP := INC * DIST;
        DIFF(10 to 23) := DIFF_TMP(0 to 13);
	CO := CONST + DIFF;
	SO := S1;
        EO(0) := '0';
        EO(1 to 7) := conv_std_logic_vector(63, 7) + E1(0 to 6);
	end if;

	O(0) <= SO;
	O(1 to 8) <= EO(0 to 7);
	O(9 to 31) <= CO(1 to 23);
  end process;
end fsqrt_archi;
