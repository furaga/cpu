library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


entity clk_gen is
	port (
		CLK	:	in	std_logic;
		INPUT_FLAG	: in std_logic_vector(1 downto 0);
		NYET		: in std_logic_vector(1 downto 0);
		CLK_FT	:	out	std_logic;
		CLK_DC	:	out	std_logic;
		CLK_EX	:	out	std_logic;
		CLK_MA	:	out	std_logic;
		CLK_WB	:	out	std_logic
	);



end clk_gen;

architecture RTL of clk_gen is

	signal count : std_logic_vector (2 downto 0) := "000";
	signal nyetb : std_logic;
	signal nyetw : std_logic;

begin
	nyetw <= NYET(1);
	nyetb <= NYET(0);

	cascade: process(CLK)
	begin
		if rising_edge(CLK) then
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
					if (INPUT_FLAG="01" and nyetb='1') or
					   (INPUT_FLAG="10" and nyetw='1') then
						CLK_FT <= '0';
						CLK_DC <= '1';
						CLK_EX <= '0';
						CLK_MA <= '0';
						CLK_WB <= '0';
						count <= count;
					else
						CLK_FT <= '0';
						CLK_DC <= '0';
						CLK_EX <= '1';
						CLK_MA <= '0';
						CLK_WB <= '0';
						count <= count + 1;
					end if;
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



