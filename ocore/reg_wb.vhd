library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;

entity reg_wb is

	port (
		CLK_WB	:	in	std_logic;
		RESET	:	in	std_logic;
		N_REG	:	in	std_logic_vector(4 downto 0);
		REG_IN	:	in	std_logic_vector(31 downto 0);
		LR_IN	:	in	std_logic_vector(31 downto 0);
		RAM_OUT	:	in	std_logic_vector(31 downto 0);
		FR_FLAG	:	in	std_logic;
		REG_COND	:	in	std_logic_vector(3 downto 0);
		REG_00WB	:	out	std_logic_vector(31 downto 0);
		REG_01WB	:	out	std_logic_vector(31 downto 0);
		REG_02WB	:	out	std_logic_vector(31 downto 0);
		REG_03WB	:	out	std_logic_vector(31 downto 0);
		REG_04WB	:	out	std_logic_vector(31 downto 0);
		REG_05WB	:	out	std_logic_vector(31 downto 0);
		REG_06WB	:	out	std_logic_vector(31 downto 0);
		REG_07WB	:	out	std_logic_vector(31 downto 0);
		REG_08WB	:	out	std_logic_vector(31 downto 0);
		REG_09WB	:	out	std_logic_vector(31 downto 0);
		REG_10WB	:	out	std_logic_vector(31 downto 0);
		REG_11WB	:	out	std_logic_vector(31 downto 0);
		REG_12WB	:	out	std_logic_vector(31 downto 0);
		REG_13WB	:	out	std_logic_vector(31 downto 0);
		REG_14WB	:	out	std_logic_vector(31 downto 0);
		REG_15WB	:	out	std_logic_vector(31 downto 0);
		REG_16WB	:	out	std_logic_vector(31 downto 0);
		REG_17WB	:	out	std_logic_vector(31 downto 0);
		REG_18WB	:	out	std_logic_vector(31 downto 0);
		REG_19WB	:	out	std_logic_vector(31 downto 0);
		REG_20WB	:	out	std_logic_vector(31 downto 0);
		REG_21WB	:	out	std_logic_vector(31 downto 0);
		REG_22WB	:	out	std_logic_vector(31 downto 0);
		REG_23WB	:	out	std_logic_vector(31 downto 0);
		REG_24WB	:	out	std_logic_vector(31 downto 0);
		REG_25WB	:	out	std_logic_vector(31 downto 0);
		REG_26WB	:	out	std_logic_vector(31 downto 0);
		REG_27WB	:	out	std_logic_vector(31 downto 0);
		REG_28WB	:	out	std_logic_vector(31 downto 0);
		REG_29WB	:	out	std_logic_vector(31 downto 0);
		REG_30WB	:	out	std_logic_vector(31 downto 0);
		REG_31WB	:	out	std_logic_vector(31 downto 0);
		FREG_00WB	:	out	std_logic_vector(31 downto 0);
		FREG_01WB	:	out	std_logic_vector(31 downto 0);
		FREG_02WB	:	out	std_logic_vector(31 downto 0);
		FREG_03WB	:	out	std_logic_vector(31 downto 0);
		FREG_04WB	:	out	std_logic_vector(31 downto 0);
		FREG_05WB	:	out	std_logic_vector(31 downto 0);
		FREG_06WB	:	out	std_logic_vector(31 downto 0);
		FREG_07WB	:	out	std_logic_vector(31 downto 0);
		FREG_08WB	:	out	std_logic_vector(31 downto 0);
		FREG_09WB	:	out	std_logic_vector(31 downto 0);
		FREG_10WB	:	out	std_logic_vector(31 downto 0);
		FREG_11WB	:	out	std_logic_vector(31 downto 0);
		FREG_12WB	:	out	std_logic_vector(31 downto 0);
		FREG_13WB	:	out	std_logic_vector(31 downto 0);
		FREG_14WB	:	out	std_logic_vector(31 downto 0);
		FREG_15WB	:	out	std_logic_vector(31 downto 0);
		FREG_16WB	:	out	std_logic_vector(31 downto 0);
		FREG_17WB	:	out	std_logic_vector(31 downto 0);
		FREG_18WB	:	out	std_logic_vector(31 downto 0);
		FREG_19WB	:	out	std_logic_vector(31 downto 0);
		FREG_20WB	:	out	std_logic_vector(31 downto 0);
		FREG_21WB	:	out	std_logic_vector(31 downto 0);
		FREG_22WB	:	out	std_logic_vector(31 downto 0);
		FREG_23WB	:	out	std_logic_vector(31 downto 0);
		FREG_24WB	:	out	std_logic_vector(31 downto 0);
		FREG_25WB	:	out	std_logic_vector(31 downto 0);
		FREG_26WB	:	out	std_logic_vector(31 downto 0);
		FREG_27WB	:	out	std_logic_vector(31 downto 0);
		FREG_28WB	:	out	std_logic_vector(31 downto 0);
		FREG_29WB	:	out	std_logic_vector(31 downto 0);
		FREG_30WB	:	out	std_logic_vector(31 downto 0);
		FREG_31WB	:	out	std_logic_vector(31 downto 0);
		LR_WB		:	out	std_logic_vector(31 downto 0)
	);


end reg_wb;
architecture RTL of reg_wb is
	constant reg1_init : std_logic_vector(31 downto 0)
				:= conv_std_logic_vector(524284, 32);
	signal reg_v : std_logic_vector(31 downto 0);
	signal lr_v : std_logic_vector(31 downto 0);
	signal reg_wen :std_logic;
	signal reg_src :std_logic;
	signal lr_wen :std_logic;
	signal lr_src :std_logic;

begin
	reg_wen <= REG_COND(3);
	reg_src <= REG_COND(2);
	lr_wen <= REG_COND(1);
	lr_src <= REG_COND(0);

	reg_v <= RAM_OUT when reg_src='1' else REG_IN;
	lr_v  <= RAM_OUT when lr_src='1' else LR_IN;
	

	process(CLK_WB, RESET)
	begin
	if (RESET='1') then
		REG_00WB	<= (others=>'0');
		REG_01WB 	<= reg1_init;
		REG_02WB	<= (others=>'0');
		REG_03WB	<= (others=>'0');
		REG_04WB	<= (others=>'0');
		REG_05WB	<= (others=>'0');
		REG_06WB	<= (others=>'0');
		REG_07WB	<= (others=>'0');
		REG_08WB	<= (others=>'0');
		REG_09WB	<= (others=>'0');
		REG_10WB	<= (others=>'0');
		REG_11WB	<= (others=>'0');
		REG_12WB	<= (others=>'0');
		REG_13WB	<= (others=>'0');
		REG_14WB	<= (others=>'0');
		REG_15WB	<= (others=>'0');
		REG_16WB	<= (others=>'0');
		REG_17WB	<= (others=>'0');
		REG_18WB	<= (others=>'0');
		REG_19WB	<= (others=>'0');
		REG_20WB	<= (others=>'0');
		REG_21WB	<= (others=>'0');
		REG_22WB	<= (others=>'0');
		REG_23WB	<= (others=>'0');
		REG_24WB	<= (others=>'0');
		REG_25WB	<= (others=>'0');
		REG_26WB	<= (others=>'0');
		REG_27WB	<= (others=>'0');
		REG_28WB	<= (others=>'0');
		REG_29WB	<= (others=>'0');
		REG_30WB	<= (others=>'0');
		REG_31WB	<= (others=>'0');
		FREG_00WB 	<= (others=>'0');
		FREG_01WB 	<= (others=>'0');
		FREG_02WB 	<= (others=>'0');
		FREG_03WB 	<= (others=>'0');
		FREG_04WB 	<= (others=>'0');
		FREG_05WB 	<= (others=>'0');
		FREG_06WB 	<= (others=>'0');
		FREG_07WB 	<= (others=>'0');
		FREG_08WB 	<= (others=>'0');
		FREG_09WB 	<= (others=>'0');
		FREG_10WB 	<= (others=>'0');
		FREG_11WB 	<= (others=>'0');
		FREG_12WB 	<= (others=>'0');
		FREG_13WB 	<= (others=>'0');
		FREG_14WB 	<= (others=>'0');
		FREG_15WB 	<= (others=>'0');
		FREG_16WB 	<= (others=>'0');
		FREG_17WB 	<= (others=>'0');
		FREG_18WB 	<= (others=>'0');
		FREG_19WB 	<= (others=>'0');
		FREG_20WB 	<= (others=>'0');
		FREG_21WB 	<= (others=>'0');
		FREG_22WB 	<= (others=>'0');
		FREG_23WB 	<= (others=>'0');
		FREG_24WB 	<= (others=>'0');
		FREG_25WB 	<= (others=>'0');
		FREG_26WB 	<= (others=>'0');
		FREG_27WB 	<= (others=>'0');
		FREG_28WB 	<= (others=>'0');
		FREG_29WB 	<= (others=>'0');
		FREG_30WB 	<= (others=>'0');
		FREG_31WB 	<= (others=>'0');
		LR_WB <= (others=>'0');
	elsif rising_edge(CLK_WB) then

		if reg_wen='1' then
			if FR_FLAG='0' then
				case N_REG is
					--when "00000" => REG_00WB <= x"00000000";	-- REG_0
					when "00001" => REG_01WB <= reg_v;
					when "00010" => REG_02WB <= reg_v;
					when "00011" => REG_03WB <= reg_v;
					when "00100" => REG_04WB <= reg_v;
					when "00101" => REG_05WB <= reg_v;
					when "00110" => REG_06WB <= reg_v;
					when "00111" => REG_07WB <= reg_v;
					when "01000" => REG_08WB <= reg_v;
					when "01001" => REG_09WB <= reg_v;
					when "01010" => REG_10WB <= reg_v;
					when "01011" => REG_11WB <= reg_v;
					when "01100" => REG_12WB <= reg_v;
					when "01101" => REG_13WB <= reg_v;
					when "01110" => REG_14WB <= reg_v;
					when "01111" => REG_15WB <= reg_v;
					when "10000" => REG_16WB <= reg_v;
					when "10001" => REG_17WB <= reg_v;
					when "10010" => REG_18WB <= reg_v;
					when "10011" => REG_19WB <= reg_v;
					when "10100" => REG_20WB <= reg_v;
					when "10101" => REG_21WB <= reg_v;
					when "10110" => REG_22WB <= reg_v;
					when "10111" => REG_23WB <= reg_v;
					when "11000" => REG_24WB <= reg_v;
					when "11001" => REG_25WB <= reg_v;
					when "11010" => REG_26WB <= reg_v;
					when "11011" => REG_27WB <= reg_v;
					when "11100" => REG_28WB <= reg_v;
					when "11101" => REG_29WB <= reg_v;
					when "11110" => REG_30WB <= reg_v;
					when "11111" => REG_31WB <= reg_v;
					when others =>	
				end case;
			else
				case N_REG is
					when "00000" => FREG_00WB <= reg_v;
					when "00001" => FREG_01WB <= reg_v;
					when "00010" => FREG_02WB <= reg_v;
					when "00011" => FREG_03WB <= reg_v;
					when "00100" => FREG_04WB <= reg_v;
					when "00101" => FREG_05WB <= reg_v;
					when "00110" => FREG_06WB <= reg_v;
					when "00111" => FREG_07WB <= reg_v;
					when "01000" => FREG_08WB <= reg_v;
					when "01001" => FREG_09WB <= reg_v;
					when "01010" => FREG_10WB <= reg_v;
					when "01011" => FREG_11WB <= reg_v;
					when "01100" => FREG_12WB <= reg_v;
					when "01101" => FREG_13WB <= reg_v;
					when "01110" => FREG_14WB <= reg_v;
					when "01111" => FREG_15WB <= reg_v;
					when "10000" => FREG_16WB <= reg_v;
					when "10001" => FREG_17WB <= reg_v;
					when "10010" => FREG_18WB <= reg_v;
					when "10011" => FREG_19WB <= reg_v;
					when "10100" => FREG_20WB <= reg_v;
					when "10101" => FREG_21WB <= reg_v;
					when "10110" => FREG_22WB <= reg_v;
					when "10111" => FREG_23WB <= reg_v;
					when "11000" => FREG_24WB <= reg_v;
					when "11001" => FREG_25WB <= reg_v;
					when "11010" => FREG_26WB <= reg_v;
					when "11011" => FREG_27WB <= reg_v;
					when "11100" => FREG_28WB <= reg_v;
					when "11101" => FREG_29WB <= reg_v;
					when "11110" => FREG_30WB <= reg_v;
					when "11111" => FREG_31WB <= reg_v;
					when others =>	
				end case;
			end if;
		end if;
		REG_00WB <= (others=>'0');
		if lr_wen='1' then
			LR_WB <= lr_v;
		end if;
	end if;

	end process;

end RTL;




