library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;

entity ram is
  port (
    PCout   : in  std_logic_vector(31 downto 0);
    ALUout  : in  std_logic_vector(31 downto 0);
    exin    : in  std_logic_vector(31 downto 0);  -- 外部入力
    RegB    : in  std_logic_vector(31 downto 0);  -- reg out 2
    RorW    : in  std_logic;                      -- read or write
    Mem     : in  std_logic;            -- 立った時点での操作が行われる
    RamAddr : in  std_logic;
    RamData : in  std_logic;
    RamOut  : out std_logic_vector(31 downto 0))
end ram;

architecture blockram of ram is
   type memory is array (0 to 1024) of std_logic_vector(35 downto 0);
   signal memory : mem;
   signal addr : std_logic_vector(31 downto 0);
   signal InData : std_logic_vector(31 downto 0);
begin  -- blockram

  man: process (Mem)
  begin  -- process main
    if Mem = '1' then
      if RorW = '0' then
        RamOut <= mem(conv_integer(addr(11 downto 2)));
      else
        mem(conv_integer(addr(11 downto 2))) <= InData;
      end if;
    end if;
  end process main;

  MuxAddr: process (PCout, ALUout, RamAddr)
  begin  -- process MuxAddr
    if RamAddr = '1' then
      addr <= PCout;
    else
      addr <= ALUout;
    end if;
  end process MuxAddr;
  
  MuxData: process (exin, RegB, RamData)
  begin  -- process MuxData
    if RamData = '1' then
      InData <= exin;
    else
      InData <= RegB;
    end if;
  end process MuxData;
end block;
