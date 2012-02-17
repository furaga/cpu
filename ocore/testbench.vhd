library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;


ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 
  
	COMPONENT top is
	port (
		MCLK1	: in  STD_LOGIC;
		RS_RX	: in  STD_LOGIC;
		RS_TX	: out  STD_LOGIC;

		ZA		: out std_logic_vector(19 downto 0);	-- Address
		XWA		: out std_logic;	-- Write Enable
		ZD		: inout std_logic_vector(31 downto 0);	-- Data InOut
		ZCLKMA	: out std_logic_vector(1 downto 0);	-- clk

---- fixed 
		XE1		: out std_logic := '0'; -- enable
		E2A		: out std_logic := '1'; -- enable
		XE3		: out std_logic := '0'; -- enable
		XZBE	: out std_logic_vector(3 downto 0) := "0000"; -- byte access
		XGA		: out std_logic := '0'; -- output enable
		XZCKE	: out std_logic := '0'; -- clk enable
		ADVA	: out std_logic := '0'; -- burst access off
		XFT		: out std_logic := '0'; -- Flow Through mode on
		XLBO	: out std_logic := '1'; -- burst access off
		ZZA		: out std_logic := '0' -- sleep mode off	
);


	END COMPONENT;
	COMPONENT sram is
	port (
		ZA		: in std_logic_vector(19 downto 0);	-- Address
		XWA		: in std_logic;	-- Write Enable
		ZD		: inout std_logic_vector(31 downto 0);	-- Data InOut
		ZCLKMA	: in std_logic_vector(1 downto 0)	-- clk
	);



	END COMPONENT;

	signal MCLK1 : std_logic := '0';
	signal RS_RX : std_logic := '1';
	signal RS_TX : std_logic;

	signal ZA		: std_logic_vector(19 downto 0);	-- Address
	signal XWA		: std_logic;	-- Write Enable
	signal ZD		: std_logic_vector(31 downto 0);	-- Data InOut

	signal ZCLKMA	: std_logic_vector(1 downto 0);	-- clk
	signal XE1		: std_logic;
	signal E2A		: std_logic;
	signal XE3		: std_logic;
	signal XZBE	: std_logic_vector(3 downto 0);
	signal XGA		: std_logic;
	signal XZCKE	: std_logic;
	signal ADVA	: std_logic;
	signal XFT		: std_logic;
	signal XLBO	: std_logic;
	signal ZZA		: std_logic;
BEGIN
  
  uut: top PORT MAP ( 
	  MCLK1 => MCLK1, 
	  RS_RX => RS_RX,
	  RS_TX => RS_TX,
	  ZA	=> ZA,
	  XWA	=> XWA,
	  ZD	=> ZD,
	  ZCLKMA=> ZCLKMA,
	  XE1	=> XE1,
	  E2A	=> E2A,
	  XE3	=> XE3,
	  XZBE	=> XZBE,
	  XGA	=> XGA,
	  XZCKE	=> XZCKE,
	  ADVA	=> ADVA,
	  XFT	=> XFT,
	  XLBO	=> XLBO,
	  ZZA	=> ZZA
  );
  sram_sim : sram port map (
  	ZA	=> ZA,
	XWA	=> XWA,
	ZD	=> ZD,
	ZCLKMA => ZCLKMA
  );
  
  clkgen: process
  begin
    mclk1<='0';
    wait for 1 ns;
    mclk1<='1';
    wait for 1 ns;
  end process;

  input : process
  	variable wtime : std_logic_vector(3 downto 0) := x"7";
  	variable timer : std_logic_vector(3 downto 0) := x"7";
  begin
	RS_RX <= '1';
  	wait for 1 us;
	RS_RX <= '0'; -- start bit
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1'; -- stop bit
	wait for 116.16 ns;
	RS_RX <= '0'; -- start bit
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1'; -- stop bit
	wait for 116.16 ns;
	RS_RX <= '0'; -- start bit
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '1'; -- stop bit
	wait for 116.16 ns;
	RS_RX <= '0'; -- start bit
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '0';
	wait for 116.16 ns;
	RS_RX <= '1';
	wait for 116.16 ns;
	RS_RX <= '1'; -- stop bit

	wait for 100 ms;
  end process;

END;




