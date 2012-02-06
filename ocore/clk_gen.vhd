library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.all;

entity clk_gen is
	port (
		CLK	:	in	std_logic;
		CLK_FT	:	out	std_logic;
		CLK_DC	:	out	std_logic;
		CLK_EX	:	out	std_logic;
		CLK_WB	:	out	std_logic
	);
end clk_gen;

architecture RTL of clk_gen is

	signal COUNT : std_logic_vector (1 downto 0) := "00";

begin

	cascade: process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			COUNT <= COUNT + 1;
			case COUNT is
				when "00" =>
					CLK_FT <= '1';
					CLK_DC <= '0';
					CLK_EX <= '0';
					CLK_WB <= '0';
				when "01" =>
					CLK_FT <= '0';
					CLK_DC <= '1';
					CLK_EX <= '0';
					CLK_WB <= '0';
				when "10" =>
					CLK_FT <= '0';
					CLK_DC <= '0';
					CLK_EX <= '1';
					CLK_WB <= '0';
				when "11" =>
					CLK_FT <= '0';
					CLK_DC <= '0';
					CLK_EX <= '0';
					CLK_WB <= '1';
				when others =>
			end case;
		end if;

	end process;

end RTL;
