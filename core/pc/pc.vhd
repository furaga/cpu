library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ProgramCounter is
  port (
    clk    : in  std_logic;
    PCplus : in  std_logic_vector(31 downto 0);   -- 前のPCをインクリメントした値
    ALUout : in  std_logic_vector(31 downto 0);  -- 分岐先アドレス
    Jaddr  : in  std_logic_vector(25 downto 0);   -- ジャンプ先アドレス
    PCWrite: in  std_logic;
    PCChange : in std_logic := '1';
    PCSource : in std_logic_vector(1 downto 0);
    PCout  : out std_logic_vector(31 downto 0) := x"00000000");
end ProgramCounter;

architecture PC of ProgramCounter is
  signal PC, ExJaddr : std_logic_vector(31 downto 0) := x"00000000";
begin  -- PC
  
  main: process (PC, PCChange)
  begin  -- process main
--    if rising_edge(clk) then
      if PCChange = '1' then
        PCout <= PC;
      end if;
--    end if;
  end process;

  ExJaddr <= PC(31 downto 26) & Jaddr;
--  ExJaddr <= PC(31 downto 28) & Jaddr & "00";

  multiplexer: process (PCplus, ALUout, ExJaddr, PCWrite)
  begin  -- process multiplexer
    if PCWrite = '1' then
      case PCSource is
        when "00" => PC <= PCplus;
        when "01" => PC <= ALUout;
        when "10" => PC <= ExJaddr;
        when others => null;
      end case;
    end if;
  end process;
end PC;
