library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity FABS is
    
  port (
    CLK : in std_logic;
    I1 : in  std_logic_vector (0 to 31);
    O  : out std_logic_vector (0 to 31));

end FABS;

architecture fabs_archi of FABS is

begin                                   --fabs_archi
process(CLK)
begin
if rising_edge(CLK) then
	  O(0) <= '0';
	  O(1 to 31) <= I1(1 to 31);
end if;

end process;
end fabs_archi;


