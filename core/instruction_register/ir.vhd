library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity IR is
  port (
    clk        : in  std_logic;
    in1        : in  std_logic_vector(31 downto 0);
    in2        : in  std_logic_vector(31 downto 0);  -- core controllerから
    IRin       : in  std_logic;         -- core controllerからなら1
    DMR        : out std_logic_vector(31 downto 0);   -- Data memory register
    J_addr     : out std_logic_vector(25 downto 0);   -- Jump address
    op         : out std_logic_vector(5 downto 0);
    rs, rt, rd : out std_logic_vector(4 downto 0);
    IRWrite    : in  std_logic;
    Imm        : out std_logic_vector(15 downto 0));  -- Immediate
end IR;

architecture InstructionRegister of IR is
  signal in0 : std_logic_vector(31 downto 0) := x"00000000";
begin  -- InstructionRegister
  main: process (IRWrite, in0)
  begin  -- process main
    if IRWrite = '1' then
      J_addr <= in0(25 downto 0);
      op <= in0(31 downto 26);
      rs <= in0(25 downto 21);
      rt <= in0(20 downto 16);
      rd <= in0(15 downto 11);
      Imm <= in0(15 downto 0);
    end if;
  end process main;

  DMR <= in1;

  Mux: process (IRin, in1, in2)
  begin  -- process Mux
    if IRin = '0' then
      in0 <= in1;
    else
      in0 <= in2;
    end if;
--      in0 <= in1 when IRin = '0' else in2;
  end process Mux;
end InstructionRegister;
