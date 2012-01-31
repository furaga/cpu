library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity fdiv is
  
  port (
    clk : in  std_logic;
    I1  : in  std_logic_vector(0 to 31);
    I2  : in  std_logic_vector(0 to 31);
    O   : out std_logic_vector(0 to 31));

end fdiv;

architecture fdiv_archi of fdiv is

signal FINVI, FINVO, FMULI1, FMULI2, FMULO : std_logic_vector(0 to 31);
  
component FINV
  port (
    CLK : in std_logic;
    I1  : in std_logic_vector(0 to 31);
    O   : out std_logic_vector(0 to 31));
end component;

component FMUL
  port (
    CLK      : in  std_logic;
    I1, I2   : in  std_logic_vector(0 to 31);
    O        : out std_logic_vector(0 to 31));
end component;

  
begin  -- fdiv_archi
  FINVI <= I2;
  FMULI1 <= I1;

  FINV1  : FINV port map (clk, FINVI, FINVO);
  FMUL1  : FMUL port map (clk, FMULI1, FMULI2, FMULO);
  
  inv_process : process(CLK)
    begin
      if rising_edge(CLK) then
        FMULI2 <= FINVO;
      end if;
    end process;
  
  mul_process : process(CLK)
    begin
      if rising_edge(CLK) then
        O <= FMULO;
      end if;
    end process;
  
end fdiv_archi;
