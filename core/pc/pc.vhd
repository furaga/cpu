library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ProgramCounter is
  port (
    PCplus : in  std_logic_vector(31 downto 0);   -- 前のPCをインクリメントした値
    ALUout : in  std_logic_vector(31 downto 0);  -- 分岐先アドレス
    Jaddr  : in  std_logic_vector(25 downto 0);   -- ジャンプ先アドレス
    PCSource : in std_logic_vector(1 downto 0);
    PCout  : out std_logic_vector(31 downto 0));
end ProgramCounter;

architecture ir of ProgramCounter is
  signal PC, ExJaddr : std_logic_vector(31 downto 0);
begin  -- ir
  
  main: process (PC)
  begin  -- process main
    PCout <= PC;
  end process main;

-- purpose: to expand Jaddr
  expand: process (Jaddr)
  begin  -- process expand
    ExJaddr <= PC(31 downto 28) & Jaddr & "00";
  end process expand;

  multiplexer: process (PCplus, ALUout, ExJaddr, PCSource)
  begin  -- process multiplexer
    case PCSource is
      when "00" => PC <= PCplus;
      when "01" => PC <= ALUout;
      when "10" => PC <= ExJaddr;
      when others => null;
    end case;
  end process multiplexer;

end ir;
