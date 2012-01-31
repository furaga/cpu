library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity FNEG is
    
  port (
    CLK : in std_logic;
    I1 : in  std_logic_vector (0 to 31);
    O  : out std_logic_vector (0 to 31));

end FNEG;

architecture fneg_archi of FNEG is

begin                                   --fneg_archi
  O(0) <= not I1(0);
  O(1 to 31) <= I1(1 to 31);
end fneg_archi;


