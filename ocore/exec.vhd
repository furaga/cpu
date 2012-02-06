library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity exec is
port
(
CLK_EX	:	in	std_logic;
RESET	:	in	std_logic;
IR		:   in	std_logic_vector (31 downto 0);
PC_IN	:	in	std_logic_vector (31 downto 0);
REG_S	:	in	std_logic_vector (31 downto 0);
REG_T	:	in	std_logic_vector (31 downto 0);
REG_D	:	in	std_logic_vector (31 downto 0);
RAM_OUT	:	in	std_logic_vector (31 downto 0);
LINK_IN	:	in	std_logic_vector (31 downto 0);
LINK_OUT	:	out	std_logic_vector (31 downto 0);
PC_OUT	:	out	std_logic_vector (31 downto 0);
N_REG	:	out std_logic_vector (4 downto 0);
REG_IN	:	out	std_logic_vector (31 downto 0);
N_RAM	:	out	std_logic_vector (31 downto 0);
RAM_IN	:	out	std_logic_vector (31 downto 0);
REG_WEN	:	out	std_logic;
RAM_WEN	:	out	std_logic
);
end exec;
architecture RTL of exec is

	signal OP_CODE : std_logic_vector(5 downto 0);
	signal OP_DATA : std_logic_vector(25 downto 0);

	signal CMP_FLAG : std_logic;
	signal SHAMT : std_logic_vector(4 downto 0);
	signal FUNCT : std_logic_vector(5 downto 0);
	signal IMM : std_logic_vector(15 downto 0);
	signal TARGET : std_logic_vector(25 downto 0);

	signal N_REG_S : std_logic_vector(4 downto 0);
	signal N_REG_T : std_logic_vector(4 downto 0);
	signal N_REG_D : std_logic_vector(4 downto 0);
	signal INIT : std_logic := '1';

begin
	OP_CODE <= IR(31 downto 26);
	OP_DATA <= IR(25 downto 0);

	SHAMT <= OP_DATA(10 downto 6);
	FUNCT <= OP_DATA(5 downto 0);
	IMM <= OP_DATA(15 downto 0);
	TARGET <= OP_DATA(25 downto 0);

	N_REG_S <= OP_DATA(25 downto 21);
	N_REG_T <= OP_DATA(20 downto 16);
	N_REG_D <= OP_DATA(15 downto 11);

--
-- OPERATION COMPLETED
--
-- MVLO, ADD, JEQ, JMP, STI, OUTPUT
--
	process(CLK_EX, RESET) 
		variable HEAP_SIZE : std_logic_vector(31 downto 0) := (others=>'0');
	begin
		if (RESET = '1') then 
			PC_OUT <= (others=>'0');
			LINK_OUT <= (others=>'0');

		elsif rising_edge(CLK_EX) then
-----------------------------------------------------------
----	initialize (reg, ram, pc)
-----------------------------------------------------------
			if (INIT = '1') then
				case PC_IN is
					when x"00000000" => -- .init_heap_size
						HEAP_SIZE := IR;
						REG_IN <= IR;
						N_REG <= "00010"; -- g2
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when others =>
						RAM_IN <= IR;
						N_RAM <= PC_IN - 1;
						REG_WEN <= '0';
						RAM_WEN <= '1';	
						PC_OUT <= PC_IN + 1;
						if (HEAP_SIZE(31 downto 2) = PC_IN(29 downto 0)) then
							INIT <= '0';
						end if;
				end case;
-----------------------------------------------------------
			else
				case OP_CODE is

					when "000000" =>	-- SPECIAL
						case FUNCT is
							when "100000" => -- ADD
								REG_IN <= REG_S + REG_T;
								N_REG <= N_REG_D;
								REG_WEN <= '1';
								RAM_WEN <= '0';	
								PC_OUT <= PC_IN + 1;
							when "111111" => -- HALT
							when others =>	
						end case;
					when "000001" =>	-- SPECIAL
						case FUNCT is
							when "000000" => -- INPUT
							when "000001" => -- OUTPUT
								RAM_IN <= REG_S;
								N_RAM <= x"00000040";
								REG_WEN <= '0';
								RAM_WEN <= '1'; 
								PC_OUT <= PC_IN + 1;	
							when others =>
						end case;
					when "000111" =>	-- MVLO
						REG_IN <= REG_S(31 downto 16) & IMM;
						N_REG <= N_REG_S;
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001010" =>	-- JEQ
						REG_WEN <= '0';
						RAM_WEN <= '0';	
						if (REG_S = REG_T) then
						   PC_OUT <= PC_IN + ("0000"&"0000"&"0000"&"00"&IMM(15 downto 2));
						else
						   PC_OUT <= PC_IN + 1;
						end if;	
					when "000010" =>	-- JMP
						REG_WEN <= '0';
						RAM_WEN <= '0';	
						PC_OUT <= ("00000000"&TARGET(25 downto 2));
					when "101011" =>	-- STI
						RAM_IN <= REG_T;
						N_RAM <= REG_S + ("0000"&"0000"&"0000"&IMM(15 downto 0));
						REG_WEN <= '0';
						RAM_WEN <= '1'; 
						PC_OUT <= PC_IN + 1;	

					when "001100" => -- SUB
						REG_IN <= REG_S - REG_T;
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "000011" => -- AND
						REG_IN <= REG_S and REG_T;
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1; 	
					when "000100" => 	-- OR 
						REG_IN <= REG_S or REG_T;
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "000101" => -- SL
						REG_IN <= REG_S(14 downto 0) & '0';
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "000110" => -- SR
						REG_IN <= '0' & REG_S(31 downto 1);
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001000" => -- SRA
						REG_IN <= REG_S(31) & REG_S(31 downto 1);
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001001" =>	-- LDH
						REG_IN <= IMM & REG_S(15 downto 0);
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001011" =>	-- CMP
						if(REG_S = REG_T) then
						   CMP_FLAG <= '1';
						else CMP_FLAG <= '0';
						end if;
						REG_WEN <= '0';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;	
					when "001101" =>	-- LD
						REG_IN <= RAM_OUT;
						REG_WEN <= '1';
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;	
					when "001111" =>	-- HLT
					when others =>	
				end case;	
			end if;
		end if;	
	end process;	

end RTL;

