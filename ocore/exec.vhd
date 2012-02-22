library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


use work.std_logic_1164_additional.all;

entity exec is
	port
	(
	CLK_EX	:	in	std_logic;	-- clk
	CLK_TABLE	:	in	std_logic;	-- clk
	RESET	:	in	std_logic;	-- reset
	IR		:   in	std_logic_vector(31 downto 0);	-- instruction register
	PC_IN	:	in	std_logic_vector(31 downto 0);	-- current pc
	REG_S	:	in	std_logic_vector(31 downto 0);	-- value of rs
	REG_T	:	in	std_logic_vector(31 downto 0);	-- value of rt
	REG_D	:	in	std_logic_vector(31 downto 0);	-- value of rd
	FREG_S	:	in	std_logic_vector(31 downto 0) :=(others=>'0');	-- value of rs <== new
	FREG_T	:	in	std_logic_vector(31 downto 0) :=(others=>'0');	-- value of rt <== new
	FREG_D	:	in	std_logic_vector(31 downto 0) :=(others=>'0');	-- value of rd <== new
	FP_OUT	:	in	std_logic_vector(19 downto 0);	-- current frame pinter
	LR_OUT	:	in	std_logic_vector(31 downto 0);	-- current link register
	LR_IN	:	out	std_logic_vector(31 downto 0);	-- next link register
	PC_OUT	:	out	std_logic_vector(31 downto 0);	-- next pc

	N_REG	:	out std_logic_vector(4 downto 0);	-- register index
	REG_IN	:	out	std_logic_vector(31 downto 0);	-- value writing to reg
	FR_FLAG :	out std_logic; -- <== new
	RAM_ADDR	:	out	std_logic_vector(19 downto 0) := (others=>'0');	-- ram address
	RAM_IN	:	out	std_logic_vector(31 downto 0);	-- value writing to ram
	REG_COND	:	out	std_logic_vector(3 downto 0);	-- reg flags
	RAM_WEN	:	out	std_logic := '0'	-- ram write enable
);


end exec;
architecture RTL of exec is
	component myfadd is
port ( 
	CLK_TABLE : in std_logic;
    I1, I2 : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));



	end component;
	component myfmul is
port ( 
	CLK_TABLE : in std_logic;
    I1, I2 : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));



	end component;
	component myfsqrt is
port (
	CLK_TABLE : in std_logic;
    I  : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));



	end component;
	component myfinv is
port (
	CLK_TABLE : in std_logic;
    I  : in  std_logic_vector(31 downto 0);
    O  : out std_logic_vector(31 downto 0));



	end component;

	signal op_code : std_logic_vector(5 downto 0);
	signal op_data : std_logic_vector(25 downto 0);

	signal cmp_flag : std_logic;
	signal shamt : std_logic_vector(4 downto 0);
	signal funct : std_logic_vector(5 downto 0);
	signal imm : std_logic_vector(15 downto 0);
	signal ex_imm : std_logic_vector(31 downto 0);
	signal target : std_logic_vector(25 downto 0);

	signal n_reg_s : std_logic_vector(4 downto 0);
	signal n_reg_t : std_logic_vector(4 downto 0);
	signal n_reg_d : std_logic_vector(4 downto 0);
	signal debug_count : std_logic_vector (31 downto 0) := x"00000000";
	signal heap_size : std_logic_vector(31 downto 0) := (others=>'0');
	signal start : std_logic := '0';

	signal fout_add : std_logic_vector(31 downto 0);
	signal fout_sub : std_logic_vector(31 downto 0);
	signal fout_mul : std_logic_vector(31 downto 0);
	signal fout_sqrt : std_logic_vector(31 downto 0);
	signal fout_div : std_logic_vector(31 downto 0);
	signal freg_t_bar : std_logic_vector(31 downto 0);
	signal inverted : std_logic_vector(31 downto 0) := (others=>'0');

begin
	freg_t_bar <= (not FREG_T(31))&FREG_T(30 downto 0);
	fadd_u : myfadd port map (CLK_TABLE, FREG_S, FREG_T, fout_add);
	fsub_u : myfadd port map (CLK_TABLE, FREG_S, freg_t_bar, fout_sub);
	fmul_u : myfmul port map (CLK_TABLE, FREG_S, FREG_T, fout_mul);
	fsqrt_u : myfsqrt port map (CLK_TABLE, FREG_S, fout_sqrt);
	finv_u : myfinv port map (CLK_TABLE, FREG_T, inverted);
	fdiv_u : myfmul port map (CLK_TABLE, FREG_S, inverted, fout_div);

	op_code <= IR(31 downto 26);
	op_data <= IR(25 downto 0);
	shamt <= op_data(10 downto 6);
	funct <= op_data(5 downto 0);
	imm <= op_data(15 downto 0);
	ex_imm <= (x"0000"&imm) when (imm(15)='0') else (x"ffff"&imm);
	target <= op_data(25 downto 0);

	n_reg_s <= op_data(25 downto 21);
	n_reg_t <= op_data(20 downto 16);
	n_reg_d <= op_data(15 downto 11);

	process(CLK_EX, RESET) 
		variable v64 : std_logic_vector(63 downto 0);
		variable v32 : std_logic_vector(31 downto 0);
		variable v20 : std_logic_vector(19 downto 0);
		variable v_mul : std_logic_vector(63 downto 0);
		variable slide_num : integer range 0 to 65535;
	begin
		if (RESET = '1') then 
			PC_OUT <= (others=>'0');
		elsif rising_edge(CLK_EX) then
-----------------------------------------------------------
----	initialize (reg, ram, pc)
-----------------------------------------------------------
			if PC_IN=0 then
				heap_size <= IR;
				REG_IN <= IR;
				REG_COND <= "1000";
				N_REG <= "00010"; -- g2
				FR_FLAG <= '0';
				RAM_WEN <= '0';
				RAM_ADDR <= x"00000";
				PC_OUT <= PC_IN + 1;
			elsif heap_size > 0 then
				heap_size<=heap_size-4;
				RAM_IN<=IR;
				v32 := PC_IN - 1;
				RAM_ADDR <= v32(17 downto 0)&"00";
				REG_COND <= "0000";
				RAM_WEN <= '1';	
				FR_FLAG <= '0';
				PC_OUT <= PC_IN + 1;
			elsif start='0' then
				FR_FLAG <= '0';
				PC_OUT <= PC_IN;
				REG_COND <= "0000";
				RAM_WEN <= '1';
				RAM_IN <= x"000000aa";
				RAM_ADDR <= x"80000";
				start<='1';
-----------------------------------------------------------
-----------------------------------------------------------
			else
				debug_count <= debug_count + 1;
				case op_code is

					when "000000" =>	-- SPECIAL
						case funct is
							when "100000" => -- ADD
								REG_IN <= REG_S + REG_T;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';	
								FR_FLAG <= '0';
								RAM_ADDR <= x"00000";
								PC_OUT <= PC_IN + 1;
							when "100010" => -- SUB
								REG_IN <= REG_S - REG_T;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';	
								FR_FLAG <= '0';
								RAM_ADDR <= x"00000";
								PC_OUT <= PC_IN + 1;
							when "011000" => -- MUL
								v64 := signed(REG_S) * signed(REG_T);
								REG_IN <= v64(31 downto 0);
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';	
								FR_FLAG <= '0';
								RAM_ADDR <= x"00000";
								PC_OUT <= PC_IN + 1;
							when "001000" =>	-- B (BRANCH)
								REG_COND <= "0000";
								RAM_WEN <= '0';	
								FR_FLAG <= '0';
								PC_OUT <= REG_S;
								RAM_ADDR <= x"00000";
							when "110000" =>	-- CALLR
								REG_COND <= "1010";
								N_REG <= "00001"; -- g1
								REG_IN <= x"000"&(FP_OUT - 4); -- push
								RAM_WEN <= '1';
								RAM_ADDR <= FP_OUT;
								RAM_IN <= LR_OUT;
								LR_IN <= PC_IN + 1;
								FR_FLAG <= '0';
								PC_OUT <= REG_S;

							when "111001" =>	-- FST
								v32 := signed(REG_S) + signed(REG_T);
								RAM_ADDR <= v32(19 downto 0);
								RAM_IN <= FREG_D;
								FR_FLAG <= '1';
								REG_COND <= "0000";
								RAM_WEN <= '1'; 
								PC_OUT <= PC_IN + 1;	
							when "110001" =>	-- FLD
								v32 := signed(REG_S) + signed(REG_T);
								RAM_ADDR <= v32(19 downto 0);
								N_REG <= n_reg_d;
								FR_FLAG <= '1';
								REG_COND <= "1100";
								RAM_WEN <= '0'; 
								PC_OUT <= PC_IN + 1;	
							when "111111" => -- HALT
								REG_COND <= "0000";
								RAM_WEN <= '0';	
								FR_FLAG <= '0';
								PC_OUT <= PC_IN;
								RAM_ADDR <= x"00000";
							when others =>	
						end case;
					when "000001" =>	-- IO
						case funct is
							when "000000" => -- INPUT (BYTE)
								REG_COND <= "1100";
								N_REG <= n_reg_d;
								RAM_WEN <= '0';
								RAM_ADDR <= x"80000";
								FR_FLAG <= '0';
								PC_OUT <= PC_IN + 1;	
							when "000001" => -- OUTPUT (BYTE)
								REG_COND <= "0000";
								RAM_WEN <= '1'; 
								RAM_IN <= REG_S;
								RAM_ADDR <= x"80000";
								FR_FLAG <= '0';
								PC_OUT <= PC_IN + 1;	
							when others =>
						end case;
					when "010001" => -- FPI
						case funct is
							when "000000" => -- FADD
								REG_IN <= fout_add;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when "000001" => -- FSUB
								REG_IN <= fout_sub;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when "000010" => -- FMUL
								REG_IN <= fout_mul;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when "000011" => -- FDIV
								REG_IN <= fout_div;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when "000100" => -- FSQRT
								REG_IN <= fout_sqrt;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when "000101" => -- FABS
								REG_IN <= '0'&FREG_S(30 downto 0);
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when "000110" => -- FMOV
								REG_IN <= FREG_S;
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when "000111" => -- FNEG
								REG_IN <= (not FREG_S(31))&FREG_S(30 downto 0);
								N_REG <= n_reg_d;
								REG_COND <= "1000";
								RAM_WEN <= '0';
								FR_FLAG <= '1';
								PC_OUT <= PC_IN + 1;
								RAM_ADDR <= x"00000";
							when others=>
						end case;

					when "000111" =>	-- MVLO
						REG_IN <= REG_S(31 downto 16) & imm;
						N_REG <= n_reg_s;
						REG_COND <= "1000";
						RAM_WEN <= '0';	
						FR_FLAG <= '0';
						PC_OUT <= PC_IN + 1;
						RAM_ADDR <= x"00000";
					when "001111" =>	-- MVHI
						REG_IN <= imm &  REG_S(15 downto 0);
						N_REG <= n_reg_s;
						REG_COND <= "1000";
						RAM_WEN <= '0';	
						FR_FLAG <= '0';
						PC_OUT <= PC_IN + 1;
						RAM_ADDR <= x"00000";
					when "001000" =>	-- ADDI
						REG_IN <= signed(REG_S) + signed(ex_imm);
						N_REG <= n_reg_t;
						REG_COND <= "1000";
						RAM_WEN <= '0';	
						FR_FLAG <= '0';
						PC_OUT <= PC_IN + 1;
						RAM_ADDR <= x"00000";
					when "010000" =>	-- SUBI
						REG_IN <= signed(REG_S) - signed(ex_imm);
						N_REG <= n_reg_t;
						REG_COND <= "1000";
						RAM_WEN <= '0';	
						FR_FLAG <= '0';
						PC_OUT <= PC_IN + 1;
						RAM_ADDR <= x"00000";
					when "011000" =>	-- MULI
						v64 := signed(REG_S) * signed(ex_imm);
						REG_IN <= v64(31 downto 0);
						N_REG <= n_reg_t;
						REG_COND <= "1000";
						RAM_WEN <= '0';	
						FR_FLAG <= '0';
						PC_OUT <= PC_IN + 1;
						RAM_ADDR <= x"00000";
					when "101000" =>	-- SLLI
						slide_num := conv_integer(imm);
						REG_IN <= REG_S sll slide_num;

						N_REG <= n_reg_t;
						REG_COND <= "1000";
						RAM_WEN <= '0';	
						FR_FLAG <= '0';
						PC_OUT <= PC_IN + 1;
						RAM_ADDR <= x"00000";

					when "101010" =>	-- SRLI
						slide_num := conv_integer(imm);
						REG_IN <= REG_S sra slide_num;

						N_REG <= n_reg_t;
						REG_COND <= "1000";
						RAM_WEN <= '0';	
						FR_FLAG <= '0';
						PC_OUT <= PC_IN + 1;
						RAM_ADDR <= x"00000";

					when "110010" =>	-- FJEQ
						REG_COND <= "0000";
						FR_FLAG <= '0'; -- ok
						RAM_WEN <= '0';	
						RAM_ADDR <= x"00000";
						if (FREG_S = FREG_T) then
							PC_OUT <= signed(PC_IN) + signed(ex_imm);
						else
							PC_OUT <= PC_IN + 1;
						end if;

					when "111010" =>	-- FJLT jump when (FREG_S < FREG_T)
						REG_COND <= "0000";
						FR_FLAG <= '0'; -- ok
						RAM_WEN <= '0';	
						RAM_ADDR <= x"00000";

						if (FREG_S(31)='1') and (FREG_T(31)='0') then
							PC_OUT <= signed(PC_IN) + signed(ex_imm);	-- true
						elsif (FREG_S(31)='0' and FREG_T(31)='1') then
							PC_OUT <= PC_IN + 1;		-- false
						elsif (FREG_S(31)='0' and FREG_T(31)='0') then

							if (unsigned(FREG_S(30 downto 0)) < unsigned(FREG_T(30 downto 0))) then
								PC_OUT <= signed(PC_IN) + signed(ex_imm);	-- true
							else
								PC_OUT <= PC_IN + 1;		-- false
							end if;

						else --(FREG_S(31)='1' and FREG_T(31)='1')
							if (unsigned(FREG_S(30 downto 0)) > unsigned(FREG_T(30 downto 0))) then
								PC_OUT <= signed(PC_IN) + signed(ex_imm);	-- true
							else
								PC_OUT <= PC_IN + 1;		-- false
							end if;

						end if;
					when "110000" =>	-- CALL
						REG_COND <= "1010";
						N_REG <= "00001"; -- g1
						REG_IN <= x"000"&(FP_OUT - 4); -- push
						RAM_WEN <= '1';
						RAM_ADDR <= FP_OUT;
						RAM_IN <= LR_OUT;
						LR_IN <= PC_IN + 1;
						FR_FLAG <= '0';
						PC_OUT <= "000000"&target(25 downto 0);
					when "111000" =>	-- RETURN
						REG_COND <= "1011";
						N_REG <= "00001"; -- g1
						REG_IN <= x"000"&(FP_OUT + 4); -- pop
						RAM_WEN <= '0';
						RAM_ADDR <= FP_OUT + 4;
						FR_FLAG <= '0';
						PC_OUT <= LR_OUT;
					when "001010" =>	-- JEQ
						REG_COND <= "0000";
						FR_FLAG <= '0';
						RAM_WEN <= '0';	
						RAM_ADDR <= x"00000";
						if (REG_S = REG_T) then
							PC_OUT <= signed(PC_IN) + signed(ex_imm);
						else
							PC_OUT <= PC_IN + 1;
						end if;

					when "010010" =>	-- JNE
						REG_COND <= "0000";
						FR_FLAG <= '0';
						RAM_WEN <= '0';	
						RAM_ADDR <= x"00000";
						if (REG_S /= REG_T) then
							PC_OUT <= signed(PC_IN) + signed(ex_imm);
						else
							PC_OUT <= PC_IN + 1;
						end if;
					when "011010" =>	-- JLT
						REG_COND <= "0000";
						FR_FLAG <= '0';
						RAM_WEN <= '0';	
						RAM_ADDR <= x"00000";
						if (signed(REG_S) < signed(REG_T)) then
							PC_OUT <= signed(PC_IN) + signed(ex_imm);
						else
							PC_OUT <= PC_IN + 1;
						end if;
					when "000010" =>	-- JMP
						REG_COND <= "0000";
						RAM_WEN <= '0';	
						RAM_ADDR <= x"00000";
						PC_OUT <= "000000"&target(25 downto 0);

					when "011011" =>	-- ST
						v32 := signed(REG_S) + signed(REG_T);
						RAM_ADDR <= v32(19 downto 0);
						RAM_IN <= REG_D;
						FR_FLAG <= '0';
						REG_COND <= "0000";
						RAM_WEN <= '1'; 
						PC_OUT <= PC_IN + 1;	
					when "010011" =>	-- LD
						v32 := signed(REG_S) + signed(REG_T);
						RAM_ADDR <= v32(19 downto 0);
						N_REG <= n_reg_d;
						FR_FLAG <= '0';
						REG_COND <= "1100";
						RAM_WEN <= '0'; 
						PC_OUT <= PC_IN + 1;	

					when "101011" =>	-- STI
						v32 := signed(REG_S) - signed(ex_imm);
						RAM_ADDR <= v32(19 downto 0);
						RAM_IN <= REG_T;
						FR_FLAG <= '0';
						REG_COND <= "0000";
						RAM_WEN <= '1'; 
						PC_OUT <= PC_IN + 1;	

					when "111001" =>	-- FSTI
						v32 := signed(REG_S) - signed(ex_imm);
						RAM_ADDR <= v32(19 downto 0);
						RAM_IN <= FREG_T;
						FR_FLAG <= '1';
						REG_COND <= "0000";
						RAM_WEN <= '1'; 
						PC_OUT <= PC_IN + 1;	

					when "100011" =>	-- LDI
						v32 := signed(REG_S) - signed(ex_imm);
						RAM_ADDR <= v32(19 downto 0);
						FR_FLAG <= '0';
						N_REG <= n_reg_t;
						REG_COND <= "1100";
						RAM_WEN <= '0'; 
						PC_OUT <= PC_IN + 1;	
					when "110001" =>	-- FLDI
						v32 := signed(REG_S) - signed(ex_imm);
						RAM_ADDR <= v32(19 downto 0);
						FR_FLAG <= '1';
						N_REG <= n_reg_t;
						REG_COND <= "1100";
						RAM_WEN <= '0'; 
						PC_OUT <= PC_IN + 1;	
					when others =>	
						REG_COND <= "0000";
						RAM_WEN <= '1'; 
						FR_FLAG <= '0';
						RAM_ADDR <= x"80000";
						RAM_IN <= x"00000065";
						debug_count <= x"ffffffff";
						PC_OUT <= PC_IN;
				end case;	
			end if;
		end if;	
	end process;	

end RTL;





