library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ram_dc is
port (
CLK_DC	:	in	std_logic;
RAM_0	:	in	std_logic_vector (15 downto 0);
RAM_1	:	in	std_logic_vector (15 downto 0);
RAM_2	:	in	std_logic_vector (15 downto 0);
RAM_3	:	in	std_logic_vector (15 downto 0);
RAM_4	:	in	std_logic_vector (15 downto 0);
RAM_5	:	in	std_logic_vector (15 downto 0);
RAM_6	:	in	std_logic_vector (15 downto 0);
RAM_7	:	in	std_logic_vector (15 downto 0);
IO65_IN	:	in	std_logic_vector (15 downto 0);
RAM_ADDR	:	in	std_logic_vector (7 downto 0);
RAM_OUT	:	out	std_logic_vector (15 downto 0)
);
end ram_dc;
architecture RTL of ram_dc is

begin
process(CLK_DC)
begin
if(CLK_DC'event and CLK_DC = '1') then
case RAM_ADDR is
when "00000000" => RAM_OUT <= RAM_0;
when "00000001" => RAM_OUT <= RAM_1;
when "00000010" => RAM_OUT <= RAM_2;
when "00000011" => RAM_OUT <= RAM_3;
when "00000100" => RAM_OUT <= RAM_4;
when "00000101" => RAM_OUT <= RAM_5;
when "00000110" => RAM_OUT <= RAM_6;
when "00000111" => RAM_OUT <= RAM_7;
when "01000001" => RAM_OUT <= IO65_IN;
when others =>
end case;
end if;
end process;
end RTL;
