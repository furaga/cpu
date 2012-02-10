library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity fpu is
  port (
    clk        : in  std_logic;
    in1, in2   : in  std_logic_vector(31 downto 0);
    FPUControl : in  std_logic_vector(3 downto 0);
    fcond      : out std_logic_vector(2 downto 0) := "000";
    fbusy      : out std_logic;
    ANS        : out std_logic_vector(31 downto 0));
end fpu;


architecture fpu_archi of fpu is
 
  signal FADDO, FSUBO, FMULO, FDIVO, FSQRTO, FNEGO, FABSO : std_logic_vector(31 downto 0);
  component FADD
    port (
      CLK : in std_logic;
      I1, I2 : in  std_logic_vector (0 to 31);
      O      : out std_logic_vector (0 to 31));
  end component;

  component FSUB
    port (
      CLK    : in  std_logic;
      I1, I2 : in  std_logic_vector (0 to 31);
      O      : out std_logic_vector (0 to 31));
  end component;

  component FMUL
    port (
      CLK    : in  std_logic;
      I1, I2 : in  std_logic_vector (0 to 31);
      O      : out std_logic_vector (0 to 31));
  end component;
  
  component FDIV
    port (
      CLK    : in  std_logic;
      I1, I2 : in  std_logic_vector (0 to 31);
      O      : out std_logic_vector (0 to 31));
  end component;
  
  component FSQRT
    port (
      CLK    : in  std_logic;
      I1     : in  std_logic_vector (0 to 31);
      O      : out std_logic_vector (0 to 31));
  end component;
  
  component FNEG
    port (
      CLK    : in  std_logic;
      I1     : in  std_logic_vector (0 to 31);
      O      : out std_logic_vector (0 to 31));
  end component;
  
  component FABS
    port (
      CLK    : in  std_logic;
      I1     : in  std_logic_vector (0 to 31);
      O      : out std_logic_vector (0 to 31));
  end component;

  
begin  -- fpu
  FADD1  : FADD port map (clk, in1, in2, FADDO);
  FSUB1  : FSUB port map (clk, in1, in2, FSUBO);
  FMUL1  : FMUL port map (clk, in1, in2, FMULO);
  FDIV1  : FDIV port map (clk, in1, in2, FDIVO);
  FSQRT1 : FSQRT port map (clk, in1, FSQRTO);
  FNEG1  : FNEG port map (clk, in1, FNEGO);
  FABS1  : FABS port map (clk, in1, FABSO);

  
  fpu_process : process(CLK)
  variable COUNT : integer := 4;
  begin
    if rising_edge(CLK) then
	   if FPUControl = "1111" then
        fbusy <= '1';
        COUNT := 3;

      else
        if FPUControl = "0000" then
			if COUNT = 0 then
		      COUNT := 4;
            fbusy <= '0';
				ANS <= FADDO;
				if FADDO(30 downto 23) = "00000000" then
					fcond <= "010";
				elsif FADDO(31) = '0' then
					fcond <= "001";
				else
					fcond <= "100";
				end if;
			else
				COUNT := 0;
			end if;
      elsif FPUControl = "0001" then
        if COUNT = 0 then
		    COUNT := 4;
          fbusy <= '0';
          ANS <= FSUBO;
          if FSUBO(30 downto 23) = "00000000" then
		  	fcond <= "010";
          elsif FSUBO(31) = '0' then
		  	fcond <= "001";
          else
		  	fcond <= "100";
          end if;
        else
          COUNT := 0;
        end if;
        
          
      elsif FPUControl = "0010" then
        if COUNT = 0 then
		    COUNT := 4;
          fbusy <= '0';
          ANS <= FMULO;
          if FMULO(30 downto 23) = "00000000" then
		  	fcond<= "010";
          elsif FMULO(31) = '0' then
		  	fcond<= "001";
          else
		  	fcond<= "100";
          end if;
        else
          COUNT := 0;
        end if;

  
      elsif FPUControl = "0011" then
        if COUNT = 0 then
		    COUNT := 4;
          fbusy <= '0';
          ANS <= FDIVO;
          if FDIVO(30 downto 23) = "00000000" then
		  	fcond <= "010";
          elsif FDIVO(31) = '0' then
		  	fcond <= "001";
          else
		  	fcond <= "100";
          end if;
        else          
          COUNT := COUNT - 1;
        end if;
  
        
      elsif FPUControl = "1011" then
        if COUNT = 1 then
		    COUNT := 4;
          fbusy <= '0';
          ANS <= FSQRTO;
          if FSQRTO(30 downto 23) = "00000000" then
		  	fcond <= "010";
          elsif FSQRTO(31) = '0' then
		  	fcond <= "001";
          else
		  	fcond <= "100";
          end if;
        else
          COUNT := COUNT - 1;
        end if;

        
      elsif FPUControl = "1100" then
        if COUNT = 0 then
		    COUNT := 4;
          fbusy <= '0';
          ANS <= FNEGO;
          if FNEGO(30 downto 23) = "00000000" then
		  	fcond <= "010";
          elsif FNEGO(31) = '0' then
		  	fcond <= "001";
          else
		  	fcond <= "100";
          end if;
        else
          COUNT := 0;
        end if;
      elsif FPUControl = "1101" then
        if COUNT = 0 then
		    COUNT := 4;
          fbusy <= '0';
          ANS <= FABSO;
          if FABSO(30 downto 23) = "00000000" then
		  	fcond <= "010";
          elsif FABSO(31) = '0' then
		  	fcond <= "001";
          else
		  	fcond <= "100";
          end if;
        else
          COUNT := 0;
        end if;
      else
		  NULL;

      end if;
    end if;
	 end if;
  end process;
end fpu_archi;
