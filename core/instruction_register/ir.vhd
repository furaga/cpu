library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity IR is
  port (
    in1        : in  std_logic_vector(31 downto 0);
    DMR        : out std_logic_vector(31 downto 0);   -- Data memory register
    J_addr     : out std_logic_vector(25 downto 0);   -- Jump address
    op         : out std_logic_vector(5 downto 0);
    rs, rt, rd : out std_logic_vector(4 downto 0);
    IRWrite    : in  std_logic_vector;
    Imm        : out std_logic_vector(15 downto 0));  -- Immediate
end IR;

architecture InstructionRegister of IR is
begin  -- InstructionRegister
  main: process (in1,IRWrite)
  begin  -- process main
    DMR <= in1;
    if IRWrite = '1' then
      J_addr <= in1(25 downto 0);
      op <= in1(31 downto 26);
      rs <= in1(25 downto 21);
      rt <= in1(20 downto 16);
      Imm <= in1(15 downto 0);
    end if;
  end process main;
end InstructionRegister;
