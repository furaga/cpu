library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity decode is
port (
CLK_DC	:	in	std_logic;
PROM_OUT	:	in	std_logic_vector (14 downto 0);
OP_CODE	:	out	std_logic_vector (3 downto 0);
OP_DATA	:	out	std_logic_vector (7 downto 0)
);
end decode;
architecture RTL of decode is


begin
process(CLK_DC)
begin
if (CLK_DC'event and CLK_DC = '1') then
   	OP_CODE <= PROM_OUT(14 downto 11);
OP_DATA <= PROM_OUT(7 downto 0);
end if;
end process;
end RTL;
