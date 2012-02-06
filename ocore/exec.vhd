library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity exec is
port
(
CLK_EX	:	in	std_logic;
RESET	:	in	std_logic;
OP_CODE	:	in	std_logic_vector (3 downto 0);
PC_IN	:	in	std_logic_vector (7 downto 0);
REG_A	:	in	std_logic_vector (15 downto 0);
REG_B	:	in	std_logic_vector (15 downto 0);
OP_DATA	:	in	std_logic_vector (7 downto 0);
RAM_OUT	:	in	std_logic_vector (15 downto 0);
PC_OUT	:	out	std_logic_vector (7 downto 0);
REG_IN	:	out	std_logic_vector (15 downto 0);
RAM_IN	:	out	std_logic_vector (15 downto 0);
REG_WEN	:	out	std_logic;
RAM_WEN	:	out	std_logic
);
end exec;
architecture RTL of exec is

signal CMP_FLAG : std_logic;

begin

	process(CLK_EX, RESET) 
	begin
		if(RESET = '1') then 
			PC_OUT <= "00000000";
		elsif(CLK_EX'event and CLK_EX = '1') then

			case OP_CODE is

				when "0000" =>	-- MOV
					REG_IN <= REG_B;
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "0001" => -- ADD
					REG_IN <= REG_A + REG_B;
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "0010" => -- SUB
					REG_IN <= REG_A - REG_B;
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "0011" => -- AND
					REG_IN <= REG_A and REG_B;
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1; 	
				when "0100" => 	-- OR 
					REG_IN <= REG_A or REG_B;
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "0101" => -- SL
					REG_IN <= REG_A(14 downto 0) & '0';
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "0110" => -- SR
					REG_IN <= '0' & REG_A(15 downto 1);
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "0111" => -- SRA
					REG_IN <= REG_A(15) & REG_A(15 downto 1);
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "1000" =>	-- LDL
					REG_IN <= REG_A(15 downto 8) & OP_DATA;
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "1001" =>	-- LDH
					REG_IN <= OP_DATA & REG_A(7 downto 0);
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;
				when "1010" =>	-- CMP
					if(REG_A = REG_B) then
					   CMP_FLAG <= '1';
					else CMP_FLAG <= '0';
					end if;
					REG_WEN <= '0';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;	
				when "1011" =>	-- JE
					REG_WEN <= '0';
					RAM_WEN <= '0';	
					if (CMP_FLAG = '1') then
					   PC_OUT <= OP_DATA;
					else
					   PC_OUT <= PC_IN + 1;
					end if;	
				when "1100" =>	-- JMP
					REG_WEN <= '0';
					RAM_WEN <= '0';	
					PC_OUT <= OP_DATA;	
				when "1101" =>	-- LD
					REG_IN <= RAM_OUT;
					REG_WEN <= '1';
					RAM_WEN <= '0';	
					PC_OUT <= PC_IN + 1;	
				when "1110" =>	-- ST
					RAM_IN <= REG_A;
					REG_WEN <= '0';
					RAM_WEN <= '1'; 
					PC_OUT <= PC_IN + 1;	
				when "1111" =>	-- HLT
				when others =>	

			end case;	
		end if;	
	end process;	

end RTL;

