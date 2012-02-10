

  signal S1 : std_logic;
  signal E1 : std_logic_vector(0 to 7);
  signal DATA : std_logic_vector(35 downto 0);
  signal CONST : std_logic_vector(23 downto 0);
  signal INC : std_logic_vector(12 downto 0);
  signal KEY : std_logic_vector(0 to 9);
  signal DIST : std_logic_vector(0 to 12);

component finv_table
  port (
    ADDRA : in std_logic_vector(9 downto 0);
    CLKA  : in std_logic;
    DOUTA : out std_logic_vector(35 downto 0));
end component;

  
begin  -- finv_archi
  S1 <= I1(0);
  E1(0 to 7) <= I1(1 to 8);
  KEY(0 to 9) <= I1(9 to 18);
  DIST(0 to 12) <= I1(19 to 31);
  CONST(23) <= '1';
  CONST(22 downto 0) <= DATA(35 downto 13);
  INC(12 downto 0) <= DATA(12 downto 0);
  
  FINV_TABLE1 : finv_table port map(KEY, CLK, DATA);
  
  
  E:process(CLK)
  
  variable DIFF : std_logic_vector(0 to 25);
  variable SO : std_logic;
  variable CO : std_logic_vector(0 to 23);
  variable EO : std_logic_vector(0 to 7);
	begin
	if rising_edge(CLK) then

	DIFF := INC * DIST;
	if KEY = conv_std_logic_vector(0, 10) and DIFF = conv_std_logic_vector(0, 13) then
		CO := conv_std_logic_vector(0, 24);
		else
		CO := CONST - DIFF(1 to 13);
	end if;
	
	SO := S1;
	
	if E1 = conv_std_logic_vector(255, 8) then EO := conv_std_logic_vector(255, 8);
	elsif E1 = conv_std_logic_vector(254, 8) then EO := conv_std_logic_vector(0, 8);
	elsif E1 = conv_std_logic_vector(0, 8) then EO := conv_std_logic_vector(255, 8);
	elsif KEY = conv_std_logic_vector(0, 10) and DIFF = conv_std_logic_vector(0, 13) then 
	EO := conv_std_logic_vector(254, 8) - E1;
	else EO := conv_std_logic_vector(253, 8) - E1;
	end if;

	O(0) <= SO;
	O(1 to 8) <= EO(0 to 7);
	O(9 to 31) <= CO(1 to 23);
	end if;
  end process;
end finv_archi;
