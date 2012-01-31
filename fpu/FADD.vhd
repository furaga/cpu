library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity FADD is
    
  port (
    CLK : in std_logic;
    I1, I2 : in  std_logic_vector (0 to 31);
    O  : out std_logic_vector (0 to 31));

end FADD;

architecture fadd_archi of FADD is

  signal S1, S2 : std_logic;
  signal E1, E2 : std_logic_vector(0 to 7);
  signal C1, C2 : std_logic_vector(0 to 23);

  signal E1I, E2I, C1I, C2I : integer;
  
begin  -- fadd_archi
  C1(0) <= '1';
  C2(0) <= '1';
  S1 <= I1(0);
  S2 <= I2(0);
  E1(0 to 7) <= I1(1 to 8);
  E2(0 to 7) <= I2(1 to 8);
  C1(1 to 23) <= I1(9 to 31);
  C2(1 to 23) <= I2(9 to 31);

  E1I <= conv_integer(E1(0 to 7));
  E2I <= conv_integer(E2(0 to 7));
  C1I <= conv_integer(C1(0 to 23));
  C2I <= conv_integer(C2(0 to 23));
  

  
  E:process(CLK)
    variable S3 : std_logic := '0';
    variable E3V : std_logic_vector(0 to 7);
    variable E3VI : integer;
    variable C1V, C2V : std_logic_vector(0 to 23);
    variable C3V : std_logic_vector(0 to 24);
    variable C3VA : std_logic_vector(0 to 24) := conv_std_logic_vector(0, 25);
    variable COUNT : integer := 25;
    
  begin
    if E1I = 0 then O <= I2;
    elsif E2I = 0 then O <= I1;
    else
  
      if (S1 = '1' and S2 = '1') or ((S1 = '1') and ((E1I > E2I) or ((E1I = E2I) and (C1I > C2I)))) or ((S2 = '1') and ((E1I < E2I) or ((E1I = E2I) and (C1I < C2I)))) then
        S3 := '1';
      else s3 := '0';
      end if;
    
      if E1I < E2I then
        E3V := E2;
        if (E2I - E1I) < 24 then
          C1V((E2I - E1I) to 23) := C1(0 to (23 - (E2I - E1I)));
          C1V(0 to (E2I - E1I -1)) := C1(0 to (E2I - E1I - 1)) - C1(0 to (E2I - E1I - 1));
        else
          C1V := conv_std_logic_vector(0, 24);
        end if;
        C2V := C2;
      
      else
        E3V := E1;
        if (E1I - E2I) < 24 then
          C2V((E1I - E2I) to 23)  := C2(0 to (23 - (E1I - E2I)));
          C2V(0 to (E1I - E2I -1)) := C2(0 to (E1I - E2I - 1)) - C2(0 to (E1I - E2I - 1));
        else
          C2V := conv_std_logic_vector(0, 24);
        end if;
        C1V := C1;          
      end if;
    
      E3VI := conv_integer(E3V);
    
      if S1 = S2 then
        C3V(0 to 24) := ('0' & C1V(0 to 23)) + ('0' & C2V(0 to 23));
      else
        if C1V > C2V then
          C3V(0 to 24) := ('0' & C1V(0 to 23)) - ('0' & C2V(0 to 23));
        else
          C3V(0 to 24) := ('0' & C2V(0 to 23)) - ('0' & C1V(0 to 23));
        end if;
      end if;
    
      for I in C3V'range loop
        if C3V(I) = '1' then
          if COUNT = 25  then
            COUNT := I;
          end if;
        end if;
      end loop;
    
      C3VA := conv_std_logic_vector(0, 25);
      E3VI := E3VI - COUNT + 1;
      E3V := conv_std_logic_vector(E3VI, 8);
      if COUNT = 0 then
        C3VA(1 to 24) := C3V(0 to 23);
      elsif COUNT = 25 then
        E3V := conv_std_logic_vector(0, 8);
      else
        C3VA(1 to (25 - COUNT)) := C3V(COUNT to 24);
      end if;
      COUNT := 25;
      O <= S3 & E3V & C3VA(2 to 24);
    end if;
  end process;
end fadd_archi;
