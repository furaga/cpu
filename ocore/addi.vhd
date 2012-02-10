LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY addi IS
	port (
		A, B : in std_logic_vector(31 downto 0);
		O	: out std_logic_vector(31 downto 0));
END addi;

ARCHITECTURE arch OF addi IS 
  
BEGIN
	O <= A + B;
  
END;
