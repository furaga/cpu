library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity FMUL is
  port (
    CLK : in std_logic;
    I1, I2 : in  std_logic_vector (0 to 31);
    O      : out std_logic_vector (0 to 31));
end FMUL;

architecture fmul_archi of FMUL is
  signal S1, S2 : std_logic;
  signal E1, E2 : std_logic_vector(0 to 8);
  signal C1H, C2H, C1L, C2L : std_logic_vector(0 to 12);
-- Sは符号、Eは指数（繰り上がりに備えて9桁あり、右づめ。）、Cは仮数（Hが上12桁プラスhiddenで13桁、Lが下11桁。繰り上がりに備えて26桁あり。）

begin  -- fmul_archi
  S1 <= I1(0);
  S2 <= I2(0);

  E1(0) <= '0';
  E2(0) <= '0';
  E1(1 to 8) <= I1(1 to 8);
  E2(1 to 8) <= I2(1 to 8);

  C1H(0) <= '1';
  C2H(0) <= '1';
  C1H(1 to 12) <= I1(9 to 20);
  C2H(1 to 12) <= I2(9 to 20);

  C1L(0 to 1) <= conv_std_logic_vector(0, 2);
  C2L(0 to 1) <= conv_std_logic_vector(0, 2);
  C1L(2 to 12) <= I1(21 to 31);
  C2L(2 to 12) <= I2(21 to 31);

  E:process(CLK)
    variable S3 : std_logic := '0';
    variable E3 : std_logic_vector(0 to 8);
    variable C3 : std_logic_vector(0 to 25);
	 
    variable HL_TMP : std_logic_vector(0 to 25);
    variable LH_TMP : std_logic_vector(0 to 25);
    variable HL : std_logic_vector(0 to 25);
    variable LH : std_logic_vector(0 to 25);
    variable C3A : std_logic_vector(0 to 22);

    begin
--符号部
		if (S1 = S2) then
			S3 := '0';
		else 
			S3 := '1';
		end if;
--指数部
     if E1 = conv_std_logic_vector(0, 9) or E2 = conv_std_logic_vector(0, 9) then
       E3 := conv_std_logic_vector(0, 9);
       else
         E3 := E1 + E2 - 127;
     end if;

--仮数部
     HL(0 to 12) := conv_std_logic_vector(0, 13);
     LH(0 to 12) := conv_std_logic_vector(0, 13);
     HL_TMP := C1H * C2L;
     LH_TMP := C1L * C2H;
     HL(13 to 25) := HL_TMP(2 to 14);
     LH(13 to 25) := LH_TMP(2 to 14);
     C3 := (C1H * C2H) + HL + LH + 2;


--繰り上がりがあったか
      if C3(0) = '1' then
        E3 := E3 + 1;
        C3A(0 to 22) := C3(1 to 23);
      else
        C3A(0 to 22) := C3(2 to 24);
      end if;

--underflow, overflow
      if E3(0) = '1' then
        E3(1 to 8) := conv_std_logic_vector(0, 8);
        C3A(0 to 22) := conv_std_logic_vector(0, 23);
		end if;

--return
      O(0) <= S3;
      O(1 to 8) <= E3(1 to 8);
      O(9 to 31) <= C3A(0 to 22);
		
   end process;

end fmul_archi;
