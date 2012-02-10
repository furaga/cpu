library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fpadder is
	port ( s1,s2: in std_logic;
				 e		: in std_logic_vector(7 downto 0);
				 a, b	: in std_logic_vector(26 downto 0);
				 eo		: out std_logic_vector(7 downto 0);
				 fo  	: out std_logic_vector(26 downto 0));
end fpadder;

architecture arch of fpadder is
	signal ftmp : std_logic_vector(26 downto 0);
	signal etmp : std_logic_vector(7 downto 0);

begin

	arith: process(s1,s2,e,a,b)
		variable tmp : std_logic_vector(27 downto 0);
	begin
		if s1 = s2 then
			tmp := ('0'&a) + ('0'&b);
			if tmp(27) = '1' then
				ftmp <= tmp(27 downto 2)&(tmp(1) or tmp(0));
				etmp <= e+1;
			else
				ftmp <= tmp(26 downto 0);
				etmp <= e;
			end if;
		else
			if a > b then
				tmp := ('0'&a) - ('0'&b);
			else
				tmp := ('0'&b) - ('0'&a);
			end if;
			
			if tmp(26) = '1' then
				ftmp <= tmp(26 downto 0);
				etmp <= e;
			elsif tmp(25) = '1' then
				ftmp <= tmp(25 downto 0)&'0';
				etmp <= e-1;
			elsif tmp(24) = '1' then
				ftmp <= tmp(24 downto 0)&"00";
				etmp <= e-2;
			elsif tmp(23) = '1' then
				ftmp <= tmp(23 downto 0)&"000";
				etmp <= e-3;
			elsif tmp(22) = '1' then
				ftmp <= tmp(22 downto 0)&"0000";
				etmp <= e-4;
			elsif tmp(21) = '1' then
				ftmp <= tmp(21 downto 0)&"00000";
				etmp <= e-5;
			elsif tmp(20) = '1' then
				ftmp <= tmp(20 downto 0)&"000000";
				etmp <= e-6;
			elsif tmp(19) = '1' then
				ftmp <= tmp(19 downto 0)&"0000000";
				etmp <= e-7;
			elsif tmp(18) = '1' then
				ftmp <= tmp(18 downto 0)&"00000000";
				etmp <= e-8;
			elsif tmp(17) = '1' then
				ftmp <= tmp(17 downto 0)&"000000000";
				etmp <= e-9;
			elsif tmp(16) = '1' then
				ftmp <= tmp(16 downto 0)&"0000000000";
				etmp <= e-10;
			elsif tmp(15) = '1' then
				ftmp <= tmp(15 downto 0)&"00000000000";
				etmp <= e-11;
			elsif tmp(14) = '1' then
				ftmp <= tmp(14 downto 0)&"000000000000";
				etmp <= e-12;
			elsif tmp(13) = '1' then
				ftmp <= tmp(13 downto 0)&"0000000000000";
				etmp <= e-13;
			elsif tmp(12) = '1' then
				ftmp <= tmp(12 downto 0)&"00000000000000";
				etmp <= e-14;
			elsif tmp(11) = '1' then
				ftmp <= tmp(11 downto 0)&"000000000000000";
				etmp <= e-15;
			elsif tmp(10) = '1' then
				ftmp <= tmp(10 downto 0)&x"0000";
				etmp <= e-16;
			elsif tmp(9) = '1' then
				ftmp <= tmp(9 downto 0)&x"0000"&"0";
				etmp <= e-17;
			elsif tmp(8) = '1' then
				ftmp <= tmp(8 downto 0)&x"0000"&"00";
				etmp <= e-18;
			elsif tmp(7) = '1' then
				ftmp <= tmp(7 downto 0)&x"0000"&"000";
				etmp <= e-19;
			elsif tmp(6) = '1' then
				ftmp <= tmp(6 downto 0)&x"0000"&"0000";
				etmp <= e-20;
			elsif tmp(5) = '1' then
				ftmp <= tmp(5 downto 0)&x"0000"&"00000";
				etmp <= e-21;
			elsif tmp(4) = '1' then
				ftmp <= tmp(4 downto 0)&x"0000"&"000000";
				etmp <= e-22;
			elsif tmp(3) = '1' then
				ftmp <= tmp(3 downto 0)&x"0000"&"0000000";
				etmp <= e-23;
			elsif tmp(2) = '1' then
				ftmp <= tmp(2 downto 0)&x"0000"&"00000000";
				etmp <= e-24;
			elsif tmp(1) = '1' then
				ftmp <= tmp(1 downto 0)&x"0000"&"000000000";
				etmp <= e-25;
			elsif tmp(0) = '1' then
				ftmp <= tmp(0)&x"0000"&"0000000000";
				etmp <= e-26;
			end if;

		end if;

	end process;


	fo <= ftmp;
	eo <= etmp;

end arch;
