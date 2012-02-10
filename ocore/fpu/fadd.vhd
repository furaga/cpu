library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity fadd is
  port (
    I1, I2 : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));
end fadd;

architecture fadd_archi of fadd is
  signal S1, S2, SO: std_logic;
  signal E1, E2, EO : std_logic_vector(7 downto 0);
  signal F1, F2, FO : std_logic_vector(23 downto 0); -- added hidden bit

  signal C1,C2,E1I, E2I, C1I, C2I : integer;

begin
	O  <= x"12345678";
	F1 <= '1'&I1(22 downto 0);
	F2 <= '1'&I2(22 downto 0);
	E1 <= I1(30 downto 23);
	E2 <= I2(30 downto 23);
	S1 <= I1(31);
	S2 <= I2(31);

	--O <= SO&EO&FO(22 downto 0);
	add : process(I1, I2)

   	begin
		if E1=0 then
			SO <= S2; EO <= E2; FO <= F2;
		elsif E2=0 then						---- I2 is zero
			SO <= S1; EO <= E1; FO <= F1;
		else
------------------------------------------------------------------------
--	sign bit
------------------------------------------------------------------------
		  if  (S1='1'and S2='1') 
		  	  or ((S1='1') and ((E1>E2) or ((E1=E2) and (C1>C2)))) 
			  or ((S2='1') and ((E1<E2) or ((E1=E2) and (C1<C2)))) then
			  SO <= '1';
		  else 
			  SO <= '0';
		  end if;
------------------------------------------------------------------------

		end if;
	end process;
end fadd_archi;
