library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity myfadd is
  port (
    I1, I2 : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));
end myfadd;

architecture op of myfadd is

	signal S1, S2, SO: std_logic;
	signal E1, E2, EO : std_logic_vector(7 downto 0);
	signal F1, F2, FO : std_logic_vector(23 downto 0); -- added hidden bit
	signal RAW_O : std_logic_vector(31 downto 0);

	signal winnerE : std_logic_vector(7 downto 0);
	signal loserE  : std_logic_vector(7 downto 0);
	signal winnerF : std_logic_vector(23 downto 0);
	signal loserF  : std_logic_vector(23 downto 0);
	signal rshiftedF : std_logic_vector(23 downto 0);

	signal raw_frac : std_logic_vector(24 downto 0);

	signal lshiftwidth : integer range 0 to 25; -- left shift width
	signal rshiftwidth 	: integer range 0 to 255; -- right shift width

begin
	F1 <= '1'&I1(22 downto 0);
	F2 <= '1'&I2(22 downto 0);
	E1 <= I1(30 downto 23);
	E2 <= I2(30 downto 23);
	S1 <= I1(31);
	S2 <= I2(31);

	O <= x"00000000" when RAW_O(30 downto 23)=0 else
		 RAW_O;

	RAW_O <= I1 when E2=0 else
			 I2 when E1=0 else 
			 SO&EO&FO(22 downto 0);

------------------------------------------------------------------------
--	sign bit
------------------------------------------------------------------------
	SO <= '1' when (S1='1'and S2='1') 
			  or ((S1='1') and (I1(30 downto 0)>I2(30 downto 0))) 
			  or ((S2='1') and (I1(30 downto 0)<I2(30 downto 0)))
			  --or ((S1='1') and ((E1>E2) or ((E1=E2) and (F1>F2)))) 
			  --or ((S2='1') and ((E1<E2) or ((E1=E2) and (F1<F2))))
			  else '0';
------------------------------------------------------------------------
	
	winnerE <= E1 when E1>E2 else E2;
	winnerF <= F1 when E1>E2 else F2;
	loserE  <= E2 when E1>E2 else E1;
	loserF  <= F2 when E1>E2 else F1;

	rshiftwidth	<= conv_integer(winnerE - loserE);
	rshiftedF <= conv_std_logic_vector(0,rshiftwidth)&loserF(23 downto rshiftwidth) 	
				when rshiftwidth < 24 else (others=>'0');

	raw_frac <= ('0'&rshiftedF) + ('0'&winnerF) 
				when S1=S2 and E1/=0 and E2 /=0 else
			  ('0'&rshiftedF) - ('0'&winnerF)
			  	when S1/=S2 and E1/=0 and E2 /= 0 and rshiftedF > winnerF else 
			  ('0'&winnerF) - ('0'&rshiftedF)
			  	when S1/=S2 and E1/=0 and E2 /= 0 and rshiftedF < winnerF else 
				raw_frac;
	
	EO	<=	winnerE+1  when lshiftwidth=0 else
			(others=>'0') when lshiftwidth=25 or winnerE<(lshiftwidth-1) else
			winnerE-(lshiftwidth-1);

	FO	<=	raw_frac(24 downto 1) when lshiftwidth=0 else
			(others=>'0') when lshiftwidth=25 else
			raw_frac((23-(lshiftwidth-1)) downto 0) & 
			conv_std_logic_vector(0,lshiftwidth-1);
			
	LZC : process(raw_frac)
		variable V : std_logic_vector(25 downto 0);
		variable count : integer range 0 to 25;
	begin
		V := raw_frac&'1';
		count := 0;
		for I in 25 downto 0 loop
			if V(I)='0' then
				count := count + 1;
			else
				V := (others=>'1');
				count := count;
				lshiftwidth <= count;
			end if;
		end loop;
	end process;


end op;
