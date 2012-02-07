library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity clk_gen is
	port (
		CLK	:	in	std_logic;
		CLK_FT	:	out	std_logic;
		CLK_DC	:	out	std_logic;
		CLK_EX	:	out	std_logic;
		CLK_MA	:	out	std_logic;
		CLK_WB	:	out	std_logic
	);



end clk_gen;

architecture RTL of clk_gen is

	signal count : std_logic_vector (2 downto 0) := "000";

begin

	cascade: process(CLK)
	begin
		if (CLK'event and CLK = '1') then
			case count is
				when "000" =>
					CLK_FT <= '1';
					CLK_DC <= '0';
					CLK_EX <= '0';
					CLK_MA <= '0';
					CLK_WB <= '0';
					count <= count + 1;
				when "001" =>
					CLK_FT <= '0';
					CLK_DC <= '1';
					CLK_EX <= '0';
					CLK_MA <= '0';
					CLK_WB <= '0';
					count <= count + 1;
				when "010" =>
					CLK_FT <= '0';
					CLK_DC <= '0';
					CLK_EX <= '1';
					CLK_MA <= '0';
					CLK_WB <= '0';
					count <= count + 1;
				when "011" =>
					CLK_FT <= '0';
					CLK_DC <= '0';
					CLK_EX <= '0';
					CLK_MA <= '1';
					CLK_WB <= '0';
					count <= count + 1;
				when "100" =>
					CLK_FT <= '0';
					CLK_DC <= '0';
					CLK_EX <= '0';
					CLK_MA <= '0';
					CLK_WB <= '1';
					count <= "000";
				when others =>
			end case;
		end if;

	end process;

end RTL;


