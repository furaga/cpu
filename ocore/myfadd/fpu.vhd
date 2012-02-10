library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fpu is
	port ( a, b	: in  std_logic_vector(31 downto 0);
				 o  	: out std_logic_vector(31 downto 0));
end fpu;

architecture structure of fpu is
	
	component expo
		port ( a,b	: in  std_logic_vector(7 downto 0);
					 flag : out std_logic;
					 d,o	: out std_logic_vector(7 downto 0));
	end component;
	
	component sign
		port ( a,b	: in  std_logic_vector(31 downto 0);
					 s		: out std_logic);
	end component;

	component sel is
		port (a, b: in std_logic_vector(26 downto 0);
					flag: in std_logic;
					w, l:	out std_logic_vector(26 downto 0));
	end component;

	component rshifter is
		port ( f		: in  std_logic_vector(26 downto 0);
					 n		: in  std_logic_vector( 7 downto 0);
					 o		: out std_logic_vector(26 downto 0));
	end component;

	component fpadder is
		port ( s1,s2: in std_logic;
					 e		: in std_logic_vector(7 downto 0);
					 a, b	: in std_logic_vector(26 downto 0);
					 eo		: out std_logic_vector(7 downto 0);
					 fo  	: out std_logic_vector(26 downto 0));
	end component;


	component rounding is
		port ( f		: in std_logic_vector(26 downto 0);
					 o  	: out std_logic_vector(22 downto 0));
	end component;

	signal so,s1,s2: std_logic;
	signal etmp,eo,e1,e2: std_logic_vector(7 downto 0);
	signal flag: std_logic;
	signal w,l,f1,f2,ff,fff: std_logic_vector(26 downto 0);
	signal fo: std_logic_vector(22 downto 0);

	signal dif: std_logic_vector(7 downto 0);

begin
	s1<=a(31);
	s2<=b(31);
	e1<=a(30 downto 23);
	e2<=b(30 downto 23);
	f1<='1'&a(22 downto 0)&"000";
	f2<='1'&b(22 downto 0)&"000";

	expu:  expo port map(e1, e2, flag, dif, etmp);
  signu: sign port map(a, b, so);
	selector: sel port map(f1, f2, flag, w, l);
	rshu: rshifter port map(l, dif, ff);
	addu:	fpadder port map(s1,s2,etmp,ff,w,eo,fff);
	ru	: rounding port map(fff,fo); 
	o <= so&eo&fo;

end structure;
