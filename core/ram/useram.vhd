library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;

entity ram is
  port (
    clk     : in  std_logic;
    PCout   : in  std_logic_vector(31 downto 0);
    ALUout  : in  std_logic_vector(31 downto 0);
    exin    : in  std_logic_vector(31 downto 0);  -- 外部入力
    RegB    : in  std_logic_vector(31 downto 0);  -- reg out 2
    LRout   : in  std_logic_vector(31 downto 0);  -- link register
    RorW    : in  std_logic;                      -- read or write(0:read, 1:write)
    Mem     : in  std_logic;            -- 立った時点での操作が行われる
    RamAddr : in  std_logic;
    RamData : in  std_logic_vector(1 downto 0);
    OPflg   : in  std_logic;            -- 立っていたらINST_ROMからの出力を返す
    init    : out std_logic := '1';
    RamOut  : out std_logic_vector(31 downto 0));
end ram;

architecture bram_controller of ram is

  signal ramaddr16 : std_logic_vector(15 downto 0);
  signal romaddr : std_logic_vector(10 downto 0);
--   signal InData : std_logic_vector(31 downto 0);
  signal wenable : std_logic_vector(0 downto 0);
  signal datain,InData : std_logic_vector(31 downto 0) := x"00000000";
  signal dout : std_logic_vector(31 downto 0);
  signal ROM_OUT : std_logic_vector(31 downto 0);
   

   component blkRAM
     port (
       clka  : in  std_logic;
       wea   : in  std_logic_vector(0 downto 0);
       addra : in  std_logic_vector(15 downto 0);
       dina  : in  std_logic_vector(31 downto 0);
       douta : out std_logic_vector(31 downto 0));
   end component;       
   component blk_mem_gen_v6_1
     port (
       clka  : in  std_logic;
       addra : in  std_logic_vector(10 downto 0);
       douta : out std_logic_vector(31 downto 0));
   end component;
begin 
  to_BlkRAM : blkRAM port map (
    clka  => clk,
    wea   => wenable,
    addra => ramaddr16,
    dina  => InData,
    douta => dout);

  to_ROM : blk_mem_gen_v6_1 port map (
    clka  => clk,
    addra => romaddr,
    douta => ROM_OUT);

  main: process (dout, wenable(0), OPflg, ROM_OUT, Mem)
  begin  -- process main
    wenable(0) <= RorW;
    if Mem = '1' then
      if OPflg = '0' then
        RamOut <= dout(31 downto 0);
      else
        RamOut <= ROM_OUT;
      end if;
    end if;
  end process main;

  MuxAddr: process (RamAddr, PCout, ALUout)
  begin  -- process MuxAddr
--    if rising_edge(clk) and Mem = '1'then
    if RamAddr = '1' then
      ramaddr16 <= PCout(17 downto 2);
      romaddr <= PCout(12 downto 2);
    else
      ramaddr16 <= ALUout(17 downto 2);
      romaddr <= ALUout(12 downto 2);
    end if;
--    end if;
  end process;
  
  MuxData: process (RamData, exin, RegB)
  begin  -- process MuxData
--    if rising_edge(clk) and Mem = '1'then
    case RamData is
      when "00" => InData <= RegB;
      when "01" => InData <= exin;
      when "10" => InData <= LRout;
      when others => null;
    end case;
--    end if;
  end process;  
end BRAM_controller;

