library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity cpu is
	port
	(			
	CLK	:	in	std_logic;
	RESET	:	in	std_logic;
	IO65_IN	:	in	std_logic_vector (31 downto 0);
	IO64_OUT	:	out	std_logic_vector (31 downto 0)
	);				
end cpu;

architecture RTL of cpu is
component clk_gen			
	port
	(				
	CLK	:	in	std_logic;
	CLK_FT	:	out	std_logic;
	CLK_DC	:	out	std_logic;
	CLK_EX	:	out	std_logic;
	CLK_WB	:	out	std_logic
	);				
end component;			
component fetch			
port
(			
	CLK_FT	:	in	std_logic;
	P_COUNT	:	in	std_logic_vector (31 downto 0);
	PROM_OUT	:	out	std_logic_vector (31 downto 0)
);				
end component;			
component decode			
port
(				
	CLK_DC	:	in	std_logic;
	PROM_OUT	:	in	std_logic_vector (31 downto 0);
	OP_CODE	:	out	std_logic_vector (5 downto 0);
	OP_DATA	:	out	std_logic_vector (25 downto 0)
);				
end component;			
component reg_dc			
port
(				
	CLK_DC	:	in	std_logic;
	REG_0	:	in	std_logic_vector (31 downto 0);
	REG_1	:	in	std_logic_vector (31 downto 0);
	REG_2	:	in	std_logic_vector (31 downto 0);
	REG_3	:	in	std_logic_vector (31 downto 0);
	REG_4	:	in	std_logic_vector (31 downto 0);
	REG_5	:	in	std_logic_vector (31 downto 0);
	REG_6	:	in	std_logic_vector (31 downto 0);
	REG_7	:	in	std_logic_vector (31 downto 0);
	N_REG_IN	:	in	std_logic_vector (4 downto 0);
	N_REG_OUT	:	out	std_logic_vector (4 downto 0);
	REG_OUT	:	out	std_logic_vector (31 downto 0)
);				
end component;			


component ram_dc			
port
(				
CLK_DC	:	in	std_logic;
RAM_0	:	in	std_logic_vector (31 downto 0);
RAM_1	:	in	std_logic_vector (31 downto 0);
RAM_2	:	in	std_logic_vector (31 downto 0);
RAM_3	:	in	std_logic_vector (31 downto 0);
RAM_4	:	in	std_logic_vector (31 downto 0);
RAM_5	:	in	std_logic_vector (31 downto 0);
RAM_6	:	in	std_logic_vector (31 downto 0);
RAM_7	:	in	std_logic_vector (31 downto 0);
IO65_IN	:	in	std_logic_vector (31 downto 0);
RAM_ADDR	:	in	std_logic_vector (7 downto 0);
RAM_OUT	:	out	std_logic_vector (31 downto 0)
);				
end component;				


component exec
port
(
CLK_EX	:	in	std_logic;						-- clk
RESET	:	in	std_logic;						-- reset
OP_CODE	:	in	std_logic_vector (5 downto 0);	-- opcode
PC_IN	:	in	std_logic_vector (31 downto 0);	-- current pc
REG_S	:	in	std_logic_vector (31 downto 0);	-- value from rs(arg1)
REG_T	:	in	std_logic_vector (31 downto 0);	-- value from rt(arg2)
REG_D	:	in	std_logic_vector (31 downto 0);	-- value from rt(arg3)
OP_DATA	:	in	std_logic_vector (25 downto 0);	-- _funct, _imm, _target(prom's lower bits)
RAM_OUT	:	in	std_logic_vector (31 downto 0);	-- value from RAM
PC_OUT	:	out	std_logic_vector (31 downto 0);	-- next pc
N_REG	:	out std_logic_vector (4 downto 0);
REG_IN	:	out	std_logic_vector (31 downto 0);	-- value writing to reg
N_RAM	:	out std_logic_vector (31 downto 0);
RAM_IN	:	out	std_logic_vector (31 downto 0);	-- value writing to ram
REG_WEN	:	out	std_logic;						-- reg write enable
RAM_WEN	:	out	std_logic						-- ram write enable
);
end component;


component reg_wb			
port
(				
CLK_WB	:	in	std_logic;
RESET	:	in	std_logic;
N_REG	:	in	std_logic_vector (4 downto 0);
REG_IN	:	in	std_logic_vector (31 downto 0);
REG_WEN	:	in	std_logic;
REG_0WB	:	out	std_logic_vector (31 downto 0);
REG_1WB	:	out	std_logic_vector (31 downto 0);
REG_2WB	:	out	std_logic_vector (31 downto 0);
REG_3WB	:	out	std_logic_vector (31 downto 0);
REG_4WB	:	out	std_logic_vector (31 downto 0);
REG_5WB	:	out	std_logic_vector (31 downto 0);
REG_6WB	:	out	std_logic_vector (31 downto 0);
REG_7WB	:	out	std_logic_vector (31 downto 0)
);				
end component;


component ram_wb			
port
(				
CLK_WB	:	in	std_logic;
RAM_ADDR	:	in	std_logic_vector (31 downto 0);
RAM_IN	:	in	std_logic_vector (31 downto 0);
RAM_WEN	:	in	std_logic;
RAM_0	:	out	std_logic_vector (31 downto 0);
RAM_1	:	out	std_logic_vector (31 downto 0);
RAM_2	:	out	std_logic_vector (31 downto 0);
RAM_3	:	out	std_logic_vector (31 downto 0);
RAM_4	:	out	std_logic_vector (31 downto 0);
RAM_5	:	out	std_logic_vector (31 downto 0);
RAM_6	:	out	std_logic_vector (31 downto 0);
RAM_7	:	out	std_logic_vector (31 downto 0);
IO64_OUT	:	out	std_logic_vector (31 downto 0)
);				
end component;				
signal	CLK_FT	:	std_logic;
signal	CLK_DC	:	std_logic;
signal	CLK_EX	:	std_logic;
signal	CLK_WB	:	std_logic;
signal	P_COUNT	:	std_logic_vector (31 downto 0);
signal	PROM_OUT	:	std_logic_vector (31 downto 0);
signal	OP_CODE	:	std_logic_vector (5 downto 0);
signal	OP_DATA	:	std_logic_vector (25 downto 0);

signal	N_REG	:	std_logic_vector (4 downto 0);
signal	N_REG_S	:	std_logic_vector (4 downto 0);
signal	N_REG_T	:	std_logic_vector (4 downto 0);
signal	N_REG_D	:	std_logic_vector (4 downto 0);
signal	REG_IN	:	std_logic_vector (31 downto 0);
signal	REG_S	:	std_logic_vector (31 downto 0);
signal	REG_T	:	std_logic_vector (31 downto 0);
signal	REG_D	:	std_logic_vector (31 downto 0);
signal	REG_WEN	:	std_logic;
signal	REG_0	:	std_logic_vector (31 downto 0);
signal	REG_1	:	std_logic_vector (31 downto 0);
signal	REG_2	:	std_logic_vector (31 downto 0);
signal	REG_3	:	std_logic_vector (31 downto 0);
signal	REG_4	:	std_logic_vector (31 downto 0);
signal	REG_5	:	std_logic_vector (31 downto 0);
signal	REG_6	:	std_logic_vector (31 downto 0);
signal	REG_7	:	std_logic_vector (31 downto 0);

signal	N_RAM	:	std_logic_vector (31 downto 0);
signal	RAM_IN	:	std_logic_vector (31 downto 0);
signal	RAM_OUT	:	std_logic_vector (31 downto 0);
signal	RAM_WEN	:	std_logic;
signal	RAM_0	:	std_logic_vector (31 downto 0);
signal	RAM_1	:	std_logic_vector (31 downto 0);
signal	RAM_2	:	std_logic_vector (31 downto 0);
signal	RAM_3	:	std_logic_vector (31 downto 0);
signal	RAM_4	:	std_logic_vector (31 downto 0);
signal	RAM_5	:	std_logic_vector (31 downto 0);
signal	RAM_6	:	std_logic_vector (31 downto 0);
signal	RAM_7	:	std_logic_vector (31 downto 0);

begin			

-- clk(state machine)
	clk_u	:	clk_gen port map(CLK, CLK_FT, CLK_DC, CLK_EX, CLK_WB);

-- fetch phase
	fetch_u	:	fetch port map(CLK_FT, P_COUNT, PROM_OUT);

-- decode phase
	dec_u	:	decode port map(CLK_DC, PROM_OUT, OP_CODE, OP_DATA);

	regdec_rs	:	reg_dc port map(CLK_DC, REG_0, REG_1, REG_2, REG_3,
		 REG_4, REG_5, REG_6, REG_7, PROM_OUT(25 downto 21),
		 N_REG_S, REG_S);
	regdec_rt	:	reg_dc port map(CLK_DC, REG_0, REG_1, REG_2, REG_3,
		 REG_4, REG_5, REG_6, REG_7, PROM_OUT(20 downto 16),
		 N_REG_T, REG_T);
	regdec_rd	:	reg_dc port map(CLK_DC, REG_0, REG_1, REG_2, REG_3,
		 REG_4, REG_5, REG_6, REG_7, PROM_OUT(15 downto 11),
		 N_REG_D, REG_D);

	ramdec_u	:	ram_dc port map(CLK_DC, RAM_0, RAM_1, RAM_2, RAM_3,
		 RAM_4, RAM_5, RAM_6, RAM_7, 
		 IO65_IN,
		 PROM_OUT(7 downto 0), RAM_OUT);

-- exec phase
	exec_u	:	exec port map(CLK_EX, RESET, OP_CODE, P_COUNT,
		 REG_S, REG_T, REG_D, OP_DATA, RAM_OUT, 
		 P_COUNT, N_REG, REG_IN, N_RAM, RAM_IN, REG_WEN, RAM_WEN);

-- write-back phase
	regwb_u	:	reg_wb port map(CLK_WB, RESET,
		 N_REG, REG_IN, REG_WEN,
		 REG_0, REG_1, REG_2, REG_3,
		 REG_4, REG_5, REG_6, REG_7);
	ramwb_u	:	ram_wb port map(CLK_WB, N_RAM, RAM_IN, RAM_WEN,
		 RAM_0, RAM_1, RAM_2, RAM_3,
		 RAM_4, RAM_5, RAM_6, RAM_7, IO64_OUT);

end RTL;			
