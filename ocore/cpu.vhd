library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

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
	port (
		CLK	:	in	std_logic;
		CLK_FT	:	out	std_logic;
		CLK_DC	:	out	std_logic;
		CLK_EX	:	out	std_logic;
		CLK_MA	:	out	std_logic;
		CLK_WB	:	out	std_logic
	);



end component;			
component fetch			
port (
	CLK_FT	:	in	std_logic;
	P_COUNT	:	in	std_logic_vector(31 downto 0);
	PROM_OUT	:	out	std_logic_vector(31 downto 0)
);


end component;			
component decode			
port (
	CLK_DC	:	in	std_logic;
	PROM_OUT	:	in std_logic_vector(31 downto 0);
	FP_OUT	:	in std_logic_vector(31 downto 0);
	LINK_OUT	:	in std_logic_vector(31 downto 0);
	IR	: out std_logic_vector(31 downto 0);
	FP	:	out std_logic_vector(19 downto 0);
	LR	:	out std_logic_vector(31 downto 0)
);


end component;			
component reg_dc			

	port (
		CLK_DC	:	in	std_logic;
		REG_00	:	in	std_logic_vector(31 downto 0);
		REG_01	:	in	std_logic_vector(31 downto 0);
		REG_02	:	in	std_logic_vector(31 downto 0);
		REG_03	:	in	std_logic_vector(31 downto 0);
		REG_04	:	in	std_logic_vector(31 downto 0);
		REG_05	:	in	std_logic_vector(31 downto 0);
		REG_06	:	in	std_logic_vector(31 downto 0);
		REG_07	:	in	std_logic_vector(31 downto 0);
		REG_08	:	in	std_logic_vector(31 downto 0);
		REG_09	:	in	std_logic_vector(31 downto 0);
		REG_10	:	in	std_logic_vector(31 downto 0);
		REG_11	:	in	std_logic_vector(31 downto 0);
		REG_12	:	in	std_logic_vector(31 downto 0);
		REG_13	:	in	std_logic_vector(31 downto 0);
		REG_14	:	in	std_logic_vector(31 downto 0);
		REG_15	:	in	std_logic_vector(31 downto 0);
		REG_16	:	in	std_logic_vector(31 downto 0);
		REG_17	:	in	std_logic_vector(31 downto 0);
		REG_18	:	in	std_logic_vector(31 downto 0);
		REG_19	:	in	std_logic_vector(31 downto 0);
		REG_20	:	in	std_logic_vector(31 downto 0);
		REG_21	:	in	std_logic_vector(31 downto 0);
		REG_22	:	in	std_logic_vector(31 downto 0);
		REG_23	:	in	std_logic_vector(31 downto 0);
		REG_24	:	in	std_logic_vector(31 downto 0);
		REG_25	:	in	std_logic_vector(31 downto 0);
		REG_26	:	in	std_logic_vector(31 downto 0);
		REG_27	:	in	std_logic_vector(31 downto 0);
		REG_28	:	in	std_logic_vector(31 downto 0);
		REG_29	:	in	std_logic_vector(31 downto 0);
		REG_30	:	in	std_logic_vector(31 downto 0);
		REG_31	:	in	std_logic_vector(31 downto 0);
		N_REG_IN	:	in	std_logic_vector (4 downto 0);
		N_REG_OUT	:	out	std_logic_vector (4 downto 0);
		REG_OUT	:	out	std_logic_vector(31 downto 0)
	);



end component;			
component exec
	port
	(
	CLK_EX	:	in	std_logic;	-- clk
	RESET	:	in	std_logic;	-- reset
	IR		:   in	std_logic_vector (31 downto 0);	-- instruction register
	PC_IN	:	in	std_logic_vector(31 downto 0);	-- current pc
	REG_S	:	in	std_logic_vector(31 downto 0);	-- value of rs
	REG_T	:	in	std_logic_vector(31 downto 0);	-- value of rt
	REG_D	:	in	std_logic_vector(31 downto 0);	-- value of rd
	FP_OUT	:	in	std_logic_vector(19 downto 0);	-- current frame pinter
	LR_OUT	:	in	std_logic_vector(31 downto 0);	-- current link register
	LR_IN	:	out	std_logic_vector(31 downto 0);	-- next link register
	PC_OUT	:	out	std_logic_vector(31 downto 0);	-- next pc
	N_REG	:	out std_logic_vector(4 downto 0);	-- register index
	REG_IN	:	out	std_logic_vector(31 downto 0);	-- value writing to reg
	N_RAM	:	out	std_logic_vector(19 downto 0);	-- ram address
	RAM_IN	:	out	std_logic_vector(31 downto 0);	-- value writing to ram
	REG_COND	:	out	std_logic_vector(3 downto 0);	-- reg flags
	RAM_WEN	:	out	std_logic	-- ram write enable
);


end component;
component reg_wb			

	port (
		CLK_WB	:	in	std_logic;
		RESET	:	in	std_logic;
		N_REG	:	in	std_logic_vector(4 downto 0);
		REG_IN	:	in	std_logic_vector(31 downto 0);
		LR_IN	:	in	std_logic_vector(31 downto 0);
		RAM_OUT	:	in	std_logic_vector(31 downto 0);
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
		LR_WB		:	out	std_logic_vector(31 downto 0)
	);


end component;
component ram is
	port (
		CLK_MA		: in	std_logic;
		RAM_WEN		: in	std_logic;
		ADDR		: in	std_logic_vector(19 downto 0);
		DATA_IN		: in	std_logic_vector(31 downto 0);
		DATA_OUT	: out	std_logic_vector(31 downto 0);
		IO65_IN		: in	std_logic_vector(31 downto 0);
		IO64_OUT	: out	std_logic_vector(31 downto 0)
	);


end component;

	signal	CLK_FT	:	std_logic;
	signal	CLK_DC	:	std_logic;
	signal	CLK_EX	:	std_logic;
	signal	CLK_MA	:	std_logic;
	signal	CLK_WB	:	std_logic;
	signal	P_COUNT	:	std_logic_vector (31 downto 0);
	signal	PROM_OUT	:	std_logic_vector (31 downto 0);
	signal	IR	:	std_logic_vector (31 downto 0);

	signal	N_REG	:	std_logic_vector (4 downto 0);
	signal	N_REG_S	:	std_logic_vector (4 downto 0);
	signal	N_REG_T	:	std_logic_vector (4 downto 0);
	signal	N_REG_D	:	std_logic_vector (4 downto 0);
	signal	FramePointer	: std_logic_vector(19 downto 0);
	signal	REG_IN	:	std_logic_vector (31 downto 0);
	signal	REG_S	:	std_logic_vector (31 downto 0);
	signal	REG_T	:	std_logic_vector (31 downto 0);
	signal	REG_D	:	std_logic_vector (31 downto 0);
	signal	REG_COND	:	std_logic_vector (3 downto 0);

	signal	REG_00	:	std_logic_vector(31 downto 0);
	signal	REG_01	:	std_logic_vector(31 downto 0);
	signal	REG_02	:	std_logic_vector(31 downto 0);
	signal	REG_03	:	std_logic_vector(31 downto 0);
	signal	REG_04	:	std_logic_vector(31 downto 0);
	signal	REG_05	:	std_logic_vector(31 downto 0);
	signal	REG_06	:	std_logic_vector(31 downto 0);
	signal	REG_07	:	std_logic_vector(31 downto 0);
	signal	REG_08	:	std_logic_vector(31 downto 0);
	signal	REG_09	:	std_logic_vector(31 downto 0);
	signal	REG_10	:	std_logic_vector(31 downto 0);
	signal	REG_11	:	std_logic_vector(31 downto 0);
	signal	REG_12	:	std_logic_vector(31 downto 0);
	signal	REG_13	:	std_logic_vector(31 downto 0);
	signal	REG_14	:	std_logic_vector(31 downto 0);
	signal	REG_15	:	std_logic_vector(31 downto 0);
	signal	REG_16	:	std_logic_vector(31 downto 0);
	signal	REG_17	:	std_logic_vector(31 downto 0);
	signal	REG_18	:	std_logic_vector(31 downto 0);
	signal	REG_19	:	std_logic_vector(31 downto 0);
	signal	REG_20	:	std_logic_vector(31 downto 0);
	signal	REG_21	:	std_logic_vector(31 downto 0);
	signal	REG_22	:	std_logic_vector(31 downto 0);
	signal	REG_23	:	std_logic_vector(31 downto 0);
	signal	REG_24	:	std_logic_vector(31 downto 0);
	signal	REG_25	:	std_logic_vector(31 downto 0);
	signal	REG_26	:	std_logic_vector(31 downto 0);
	signal	REG_27	:	std_logic_vector(31 downto 0);
	signal	REG_28	:	std_logic_vector(31 downto 0);
	signal	REG_29	:	std_logic_vector(31 downto 0);
	signal	REG_30	:	std_logic_vector(31 downto 0);
	signal	REG_31	:	std_logic_vector(31 downto 0);
	signal	N_RAM	:	std_logic_vector (19 downto 0);
	signal	RAM_IN	:	std_logic_vector (31 downto 0);
	signal	RAM_OUT	:	std_logic_vector (31 downto 0);
	signal	RAM_WEN	:	std_logic;

	signal	LR_IN	:	std_logic_vector(31 downto 0);
	signal	LR_OUT	:	std_logic_vector(31 downto 0);
	signal	LinkRegister	:	std_logic_vector(31 downto 0);

begin			

-- clk(state machine)
	clk_u	:	clk_gen port map(CLK, CLK_FT, CLK_DC, CLK_EX, CLK_MA, CLK_WB);

-- fetch phase
	fetch_u	:	fetch port map(CLK_FT, P_COUNT, PROM_OUT);

-- decode phase
	dec_u	:	decode port map(CLK_DC,
					PROM_OUT, REG_01, LR_OUT,
					IR, FramePointer, LinkRegister
					);

	regdec_rs	:	reg_dc port map(CLK_DC, 
		
		 REG_00, REG_01, REG_02, REG_03, REG_04, REG_05, REG_06, REG_07, 
		 REG_08, REG_09, REG_10, REG_11, REG_12, REG_13, REG_14, REG_15, 
		 REG_16, REG_17, REG_18, REG_19, REG_20, REG_21, REG_22, REG_23, 
		 REG_24, REG_25, REG_26, REG_27, REG_28, REG_29, REG_30, REG_31
,
		PROM_OUT(25 downto 21),
		 N_REG_S, REG_S);

	regdec_rt	:	reg_dc port map(CLK_DC, 
		
		 REG_00, REG_01, REG_02, REG_03, REG_04, REG_05, REG_06, REG_07, 
		 REG_08, REG_09, REG_10, REG_11, REG_12, REG_13, REG_14, REG_15, 
		 REG_16, REG_17, REG_18, REG_19, REG_20, REG_21, REG_22, REG_23, 
		 REG_24, REG_25, REG_26, REG_27, REG_28, REG_29, REG_30, REG_31
,
		PROM_OUT(20 downto 16),
		 N_REG_T, REG_T);

	regdec_rd	:	reg_dc port map(CLK_DC, 
		
		 REG_00, REG_01, REG_02, REG_03, REG_04, REG_05, REG_06, REG_07, 
		 REG_08, REG_09, REG_10, REG_11, REG_12, REG_13, REG_14, REG_15, 
		 REG_16, REG_17, REG_18, REG_19, REG_20, REG_21, REG_22, REG_23, 
		 REG_24, REG_25, REG_26, REG_27, REG_28, REG_29, REG_30, REG_31
,
		PROM_OUT(15 downto 11),
		 N_REG_D, REG_D);

-- exec phase
	exec_u	:	exec port map(CLK_EX, RESET, IR, P_COUNT,
		 REG_S, REG_T, REG_D, FramePointer, LinkRegister,
		 LR_IN, P_COUNT, N_REG, REG_IN, N_RAM, RAM_IN, REG_COND,
		 RAM_WEN);

-- memory access phase
	ram_u	: ram port map (CLK_MA, RAM_WEN, N_RAM, RAM_IN,
							RAM_OUT, IO65_IN, IO64_OUT);
	
-- write-back phase
	regwb_u	:	reg_wb port map(CLK_WB, RESET,
		 N_REG, REG_IN, LR_IN, RAM_OUT, REG_COND,
		 
		 REG_00, REG_01, REG_02, REG_03, REG_04, REG_05, REG_06, REG_07, 
		 REG_08, REG_09, REG_10, REG_11, REG_12, REG_13, REG_14, REG_15, 
		 REG_16, REG_17, REG_18, REG_19, REG_20, REG_21, REG_22, REG_23, 
		 REG_24, REG_25, REG_26, REG_27, REG_28, REG_29, REG_30, REG_31
, LR_OUT
	 );

end RTL;			






