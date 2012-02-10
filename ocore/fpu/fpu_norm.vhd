library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity fpu_norm is
	port (
		I	:	in	std_logic_vector(0 to 31);
		O	:	out	std_logic_vector(31 downto 0));
end fpu_norm;

architecture converter of fpu_norm is

begin

	O(0) <= I(0);
	O(1) <= I(1);
	O(2) <= I(2);
	O(3) <= I(3);

	O(4) <= I(4);
	O(5) <= I(5);
	O(6) <= I(6);
	O(7) <= I(7);

	O(8) <= I(8);
	O(9) <= I(9);
	O(10) <= I(10);
	O(11) <= I(11);

	O(12) <= I(12);
	O(13) <= I(13);
	O(14) <= I(14);
	O(15) <= I(15);

	O(16) <= I(16);
	O(17) <= I(17);
	O(18) <= I(18);
	O(19) <= I(19);

	O(20) <= I(20);
	O(21) <= I(21);
	O(22) <= I(22);
	O(23) <= I(23);

	O(24) <= I(24);
	O(25) <= I(25);
	O(26) <= I(26);
	O(27) <= I(27);

	O(28) <= I(28);
	O(29) <= I(29);
	O(30) <= I(30);
	O(31) <= I(31);

end;
