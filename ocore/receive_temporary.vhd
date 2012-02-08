library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity recieve is
	generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
	port (clk	: in std_logic;
				data : in std_logic;
				flag : out std_logic;
				char : out std_logic_vector(7 downto 0));
end entity;

architecture beh of recieve is
	signal countdown: std_logic_vector(15 downto 0) := (others=>'0');
	signal addr: std_logic_vector(3 downto 0) := "0000";
	signal state: std_logic_vector(3 downto 0) := "1111";
	signal char_orig: std_logic_vector(7 downto 0);


begin

	statemachine: process(clk)
	begin
		if rising_edge(clk) then
			case state is
				when "0000" =>
					state<="1010";
					addr<="0000";
				when "1010" =>
					if data='0' then
						state<=state-1;
						countdown<=wtime + 1000;
					end if;
				when others=>
					if countdown=0 then
						char_orig(conv_integer(addr))<=data;
						addr<=addr+1;
						state<=state-1;
						countdown<=wtime;
					else
						countdown<=countdown-1;
					end if;
			end case;
		end if;
	end process;
	flag<= '1' when state="0000" else '0';
	char<=char_orig;

end beh;
