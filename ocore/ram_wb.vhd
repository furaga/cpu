library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ram_wb is
port (
CLK_WB	:	in	std_logic;
RAM_ADDR	:	in	std_logic_vector (7 downto 0);
RAM_IN	:	in	std_logic_vector (15 downto 0);
RAM_WEN	:	in	std_logic;
RAM_0	:	out	std_logic_vector (15 downto 0);
RAM_1	:	out	std_logic_vector (15 downto 0);
RAM_2	:	out	std_logic_vector (15 downto 0);
RAM_3	:	out	std_logic_vector (15 downto 0);
RAM_4	:	out	std_logic_vector (15 downto 0);
RAM_5	:	out	std_logic_vector (15 downto 0);
RAM_6	:	out	std_logic_vector (15 downto 0);
RAM_7	:	out	std_logic_vector (15 downto 0);
IO64_OUT	:	out	std_logic_vector (15 downto 0)
);
end ram_wb;
architecture RTL of ram_wb is

begin
process(CLK_WB)
begin
if(CLK_WB'event and CLK_WB = '1') then
if(RAM_WEN = '1') then
case RAM_ADDR is
when "00000000" => RAM_0 <= RAM_IN;	-- RAM_0
when "00000001" => RAM_1 <= RAM_IN;	-- RAM_1
when "00000010" => RAM_2 <= RAM_IN;	-- RAM_2
when "00000011" => RAM_3 <= RAM_IN;	-- RAM_3
when "00000100" => RAM_4 <= RAM_IN;	-- RAM_4
when "00000101" => RAM_5 <= RAM_IN;	-- RAM_5
when "00000110" => RAM_6 <= RAM_IN;	-- RAM_6
when "00000111" => RAM_7 <= RAM_IN;	-- RAM_7
when "01000000" => IO64_OUT <= RAM_IN;	-- IO_64
when others =>	
end case;
end if;
end if;
end process;
end RTL;

