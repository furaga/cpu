library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity cpu15e is
port
(			
CLK	:	in	std_logic;
RESET	:	in	std_logic;
IO65_IN	:	in	std_logic_vector (15 downto 0);
IO64_OUT	:	out	std_logic_vector (15 downto 0)
);				
end cpu15e;


architecture RTL of cpu15e is


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
P_COUNT	:	in	std_logic_vector (7 downto 0);
PROM_OUT	:	out	std_logic_vector (14 downto 0)
);				
end component;			


component decode			
port
(				
CLK_DC	:	in	std_logic;
PROM_OUT	:	in	std_logic_vector (14 downto 0);
OP_CODE	:	out	std_logic_vector (3 downto 0);
OP_DATA	:	out	std_logic_vector (7 downto 0)
);				
end component;			


component reg_dc			
port
(				
CLK_DC	:	in	std_logic;
REG_0	:	in	std_logic_vector (15 downto 0);
REG_1	:	in	std_logic_vector (15 downto 0);
REG_2	:	in	std_logic_vector (15 downto 0);
REG_3	:	in	std_logic_vector (15 downto 0);
REG_4	:	in	std_logic_vector (15 downto 0);
REG_5	:	in	std_logic_vector (15 downto 0);
REG_6	:	in	std_logic_vector (15 downto 0);
REG_7	:	in	std_logic_vector (15 downto 0);
N_REG_IN	:	in	std_logic_vector (2 downto 0);
N_REG_OUT	:	out	std_logic_vector (2 downto 0);
REG_OUT	:	out	std_logic_vector (15 downto 0)
);				
end component;			


component ram_dc			
port
(				
CLK_DC	:	in	std_logic;
RAM_0	:	in	std_logic_vector (15 downto 0);
RAM_1	:	in	std_logic_vector (15 downto 0);
RAM_2	:	in	std_logic_vector (15 downto 0);
RAM_3	:	in	std_logic_vector (15 downto 0);
RAM_4	:	in	std_logic_vector (15 downto 0);
RAM_5	:	in	std_logic_vector (15 downto 0);
RAM_6	:	in	std_logic_vector (15 downto 0);
RAM_7	:	in	std_logic_vector (15 downto 0);
IO65_IN	:	in	std_logic_vector (15 downto 0);
RAM_ADDR	:	in	std_logic_vector (7 downto 0);
RAM_OUT	:	out	std_logic_vector (15 downto 0)
);				
end component;				


component exec
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
end component;


component reg_wb			
port
(				
CLK_WB	:	in	std_logic;
RESET	:	in	std_logic;
N_REG	:	in	std_logic_vector (2 downto 0);
REG_IN	:	in	std_logic_vector (15 downto 0);
REG_WEN	:	in	std_logic;
REG_0WB	:	out	std_logic_vector (15 downto 0);
REG_1WB	:	out	std_logic_vector (15 downto 0);
REG_2WB	:	out	std_logic_vector (15 downto 0);
REG_3WB	:	out	std_logic_vector (15 downto 0);
REG_4WB	:	out	std_logic_vector (15 downto 0);
REG_5WB	:	out	std_logic_vector (15 downto 0);
REG_6WB	:	out	std_logic_vector (15 downto 0);
REG_7WB	:	out	std_logic_vector (15 downto 0)
);				
end component;


component ram_wb			
port
(				
CLK_WB	:	in	std_logic;
RAM_ADDR	:	in	std_logic_vector (7 downto 0);
RAM_IN	:	in	std_logic_vector (15 downto 0);
RAM_WEN	:	in	std_logic;
RAM_0	:	out	std_logic_vector (15 downto 0);
RAM_1	:	out	std_logic_vector (15 downto 0);
RAM_2	:	out	std_logic_vector (15 downto 0);
RAM_3	:	out	std_logic_vector (15 downto 0);
RAM_4	:	out	std_logic_vector (15 downto 0);
RAM_5	:	out	std_logic_vector (15 downto 0);
RAM_6	:	out	std_logic_vector (15 downto 0);
RAM_7	:	out	std_logic_vector (15 downto 0);
IO64_OUT	:	out	std_logic_vector (15 downto 0)
);				
end component;				
signal	CLK_FT	:	std_logic;
signal	CLK_DC	:	std_logic;
signal	CLK_EX	:	std_logic;
signal	CLK_WB	:	std_logic;
signal	P_COUNT	:	std_logic_vector (7 downto 0);
signal	PROM_OUT	:	std_logic_vector (14 downto 0);
signal	OP_CODE	:	std_logic_vector (3 downto 0);
signal	OP_DATA	:	std_logic_vector (7 downto 0);
signal	N_REG_A	:	std_logic_vector (2 downto 0);
signal	N_REG_B	:	std_logic_vector (2 downto 0);
signal	REG_IN	:	std_logic_vector (15 downto 0);
signal	REG_A	:	std_logic_vector (15 downto 0);
signal	REG_B	:	std_logic_vector (15 downto 0);
signal	REG_WEN	:	std_logic;
signal	REG_0	:	std_logic_vector (15 downto 0);
signal	REG_1	:	std_logic_vector (15 downto 0);
signal	REG_2	:	std_logic_vector (15 downto 0);
signal	REG_3	:	std_logic_vector (15 downto 0);
signal	REG_4	:	std_logic_vector (15 downto 0);
signal	REG_5	:	std_logic_vector (15 downto 0);
signal	REG_6	:	std_logic_vector (15 downto 0);
signal	REG_7	:	std_logic_vector (15 downto 0);
signal	RAM_IN	:	std_logic_vector (15 downto 0);
signal	RAM_OUT	:	std_logic_vector (15 downto 0);
signal	RAM_WEN	:	std_logic;
signal	RAM_0	:	std_logic_vector (15 downto 0);
signal	RAM_1	:	std_logic_vector (15 downto 0);
signal	RAM_2	:	std_logic_vector (15 downto 0);
signal	RAM_3	:	std_logic_vector (15 downto 0);
signal	RAM_4	:	std_logic_vector (15 downto 0);
signal	RAM_5	:	std_logic_vector (15 downto 0);
signal	RAM_6	:	std_logic_vector (15 downto 0);
signal	RAM_7	:	std_logic_vector (15 downto 0);

begin			

	clk_u	:	clk_gen port map(CLK, CLK_FT, CLK_DC, CLK_EX, CLK_WB);
	fetch_u	:	fetch port map(CLK_FT, P_COUNT, PROM_OUT);
	dec_u	:	decode port map(CLK_DC, PROM_OUT, OP_CODE, OP_DATA);

	regdec_u1	:	reg_dc port map(CLK_DC, REG_0, REG_1, REG_2, REG_3,
		 REG_4, REG_5, REG_6, REG_7,
		 PROM_OUT(10 downto 8), N_REG_A, REG_A);
	regdec_u2	:	reg_dc port map(CLK_DC, REG_0, REG_1, REG_2, REG_3,
		 REG_4, REG_5, REG_6, REG_7,
		 PROM_OUT(7 downto 5), N_REG_B, REG_B);

	ramdec_u	:	ram_dc port map(CLK_DC, RAM_0, RAM_1, RAM_2, RAM_3,
		 RAM_4, RAM_5, RAM_6, RAM_7,
		 IO65_IN, PROM_OUT(7 downto 0), RAM_OUT);
	exec_u	:	exec port map(CLK_EX, RESET, OP_CODE, P_COUNT,
		 REG_A, REG_B, OP_DATA, RAM_OUT, P_COUNT,
		 REG_IN, RAM_IN, REG_WEN, RAM_WEN);
	regwb_u	:	reg_wb port map(CLK_WB, RESET,
		 N_REG_A, REG_IN, REG_WEN,
		 REG_0, REG_1, REG_2, REG_3,
		 REG_4, REG_5, REG_6, REG_7);
	ramwb_u	:	ram_wb port map(CLK_WB, OP_DATA, RAM_IN, RAM_WEN,
		 RAM_0, RAM_1, RAM_2, RAM_3,
		 RAM_4, RAM_5, RAM_6, RAM_7, IO64_OUT);

end RTL;			
