library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity exec is
	port
	(
	CLK_EX	:	in	std_logic;	-- clk
	RESET	:	in	std_logic;	-- reset
	IR		:   in	std_logic_vector (31 downto 0);	-- instruction register
	PC_IN	:	in	std_logic_vector(31 downto 0);	-- current pc
	REG_S	:	in	std_logic_vector(31 downto 0);	-- value of rs
	REG_T	:	in	std_logic_vector(31 downto 0);	-- value of rt
	REG_D	:	in	std_logic_vector(31 downto 0);	-- value of rd
	LINK_IN	:	in	std_logic_vector(31 downto 0);	-- current link register
	LINK_OUT	:	out	std_logic_vector(31 downto 0);	-- next link register
	PC_OUT	:	out	std_logic_vector(31 downto 0);	-- next pc
	N_REG	:	out std_logic_vector(4 downto 0);	-- register index
	REG_IN	:	out	std_logic_vector(31 downto 0);	-- value writing to reg
	N_RAM	:	out	std_logic_vector(19 downto 0);	-- ram address
	RAM_IN	:	out	std_logic_vector(31 downto 0);	-- value writing to ram
	REG_WEN_SRC	:	out	std_logic_vector(1 downto 0);	-- reg write enable and src flag
	RAM_WEN	:	out	std_logic	-- ram write enable
);


end exec;
architecture RTL of exec is

	signal op_code : std_logic_vector(5 downto 0);
	signal op_data : std_logic_vector(25 downto 0);

	signal cmp_flag : std_logic;
	signal shamt : std_logic_vector(4 downto 0);
	signal funct : std_logic_vector(5 downto 0);
	signal imm : std_logic_vector(15 downto 0);
	signal target : std_logic_vector(25 downto 0);

	signal n_reg_s : std_logic_vector(4 downto 0);
	signal n_reg_t : std_logic_vector(4 downto 0);
	signal n_reg_d : std_logic_vector(4 downto 0);
	signal init : std_logic := '1';

begin
	op_code <= IR(31 downto 26);
	op_data <= IR(25 downto 0);

	shamt <= op_data(10 downto 6);
	funct <= op_data(5 downto 0);
	imm <= op_data(15 downto 0);
	target <= op_data(25 downto 0);

	n_reg_s <= op_data(25 downto 21);
	n_reg_t <= op_data(20 downto 16);
	n_reg_d <= op_data(15 downto 11);

--
-- OPERATION COMPLETED
--
-- MVLO, ADD, JEQ, JMP, STI, (OUTPUT)
--
	process(CLK_EX, RESET) 
		variable heap_size : std_logic_vector(31 downto 0) := (others=>'0');
		variable v : std_logic_vector(31 downto 0);
	begin
		if (RESET = '1') then 
			PC_OUT <= (others=>'0');
			LINK_OUT <= (others=>'0');
		elsif rising_edge(CLK_EX) then
-----------------------------------------------------------
----	initialize (reg, ram, pc)
-----------------------------------------------------------
			if (init = '1') then
				case PC_IN is
					when x"00000000" => -- .init_heap_size
						heap_size := IR;
						REG_IN <= IR;
						N_REG <= "00010"; -- g2
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when others =>
						RAM_IN <= IR;
						v := PC_IN - 1;
						N_RAM <= v(19 downto 0);
						REG_WEN_SRC <= "10";
						RAM_WEN <= '1';	
						PC_OUT <= PC_IN + 1;
						if (heap_size(31 downto 2) = PC_IN(29 downto 0)) then
							init <= '0';
						end if;
				end case;
-----------------------------------------------------------
			else
				case op_code is

					when "000000" =>	-- SPECIAL
						case funct is
							when "100000" => -- ADD
								REG_IN <= REG_S + REG_T;
								N_REG <= n_reg_d;
								REG_WEN_SRC <= "10";
								RAM_WEN <= '0';	
								PC_OUT <= PC_IN + 1;
							when "111111" => -- HALT
							when others =>	
						end case;
					when "000001" =>	-- SPECIAL
						case funct is
							when "000000" => -- INPUT
							when "000001" => -- OUTPUT
								RAM_IN <= REG_S;
								N_RAM <= x"00040";
								REG_WEN_SRC <= "10";
								RAM_WEN <= '1'; 
								PC_OUT <= PC_IN + 1;	
							when others =>
						end case;
					when "000111" =>	-- MVLO
						REG_IN <= REG_S(31 downto 16) & imm;
						N_REG <= n_reg_s;
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001010" =>	-- JEQ
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						if (REG_S = REG_T) then
						   PC_OUT <= PC_IN + ("0000"&"0000"&"0000"&"00"&imm(15 downto 2));
						else
						   PC_OUT <= PC_IN + 1;
						end if;	
					when "000010" =>	-- JMP
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= ("00000000"&target(25 downto 2));
					when "101011" =>	-- STI
						RAM_IN <= REG_T;
						if (imm(15)='1') then
							v := REG_S + (x"ffff"&imm(15 downto 0));
						else
							v := REG_S + (x"0000"&imm(15 downto 0));
						end if;
						N_RAM <= v(21 downto 2);
						REG_WEN_SRC <= "10";
						RAM_WEN <= '1'; 
						PC_OUT <= PC_IN + 1;	
					when "100011" =>	-- LDI
						if (imm(15)='1') then
							v := REG_S + (x"ffff"&imm(15 downto 0));
						else
							v := REG_S + (x"0000"&imm(15 downto 0));
						end if;
						N_RAM <= v(21 downto 2);
						N_REG <= n_reg_t;
						REG_WEN_SRC <= "11";
						RAM_WEN <= '0'; 
						PC_OUT <= PC_IN + 1;	


					when "001100" => -- SUB
						REG_IN <= REG_S - REG_T;
						REG_WEN_SRC <= "10";
						PC_OUT <= PC_IN + 1;
					when "000011" => -- AND
						REG_IN <= REG_S and REG_T;
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1; 	
					when "000100" => 	-- OR 
						REG_IN <= REG_S or REG_T;
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "000101" => -- SL
						REG_IN <= REG_S(14 downto 0) & '0';
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "000110" => -- SR
						REG_IN <= '0' & REG_S(31 downto 1);
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001000" => -- SRA
						REG_IN <= REG_S(31) & REG_S(31 downto 1);
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001001" =>	-- LDH
						REG_IN <= imm & REG_S(15 downto 0);
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;
					when "001011" =>	-- CMP
						if(REG_S = REG_T) then
						   cmp_flag <= '1';
						else cmp_flag <= '0';
						end if;
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;	
					when "001101" =>	-- LD
						REG_WEN_SRC <= "10";
						RAM_WEN <= '0';	
						PC_OUT <= PC_IN + 1;	
					when "001111" =>	-- HLT
					when others =>	
				end case;	
			end if;
		end if;	
	end process;	

end RTL;




