--Wed Oct  5 19:33:13 2011
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Registers is
  port (
    clk      : in STD_LOGIC;
    rs,rt,rd : in std_logic_vector(4 downto 0);  -- opcode [25 - 0]
    RegDst   : in std_logic_vector(1 downto 0);  -- 書く番号の選択(Mux)
    MemtoReg : in std_logic_vector(1 downto 0);    -- 書きこむデータの選択(Mux)
    RegWrite : in std_logic;            -- 立った時点の値が書き込まれる
    GorF     : in std_logic := '0';     -- Grobal or Floating point
    movlr    : in std_logic := '0';     -- 立ったら、tmplr <= lr
    LR       : in std_logic := '0';     -- 立ったら、A<=tmplr, B<=lr
    LRWrite  : in std_logic := '0';     -- 立っていたら、lr <= Wdata
    DMR, ALUOut : in std_logic_vector(31 downto 0); -- DMR:DataMemoryRegister
    REG_InData  : in std_logic_vector(31 downto 0);  -- input from USB
    A, B     : out std_logic_vector(31 downto 0);
    LRout    : out std_logic_vector(31 downto 0));
  
end Registers;

architecture rgstr of Registers is
  type reg_set is array(0 to 31) of std_logic_vector(35 downto 0);
  signal greg, freg : reg_set :=
    (x"000000000",x"0003FFFFC",x"000000000",x"000000000",  -- g1 = 4194300(10)
     x"000000000",x"000000000",x"000000000",x"000000000",
     x"000000000",x"000000000",x"000000000",x"000000000",
     x"000000000",x"000000000",x"000000000",x"000000000",
     x"000000000",x"000000000",x"000000000",x"000000000",
     x"000000000",x"000000000",x"000000000",x"000000000",
     x"000000000",x"000000000",x"000000000",x"000000000",
     x"000000000",x"000000000",x"000000000",x"000000000");                 -- grobal regster set
  signal lr0, tmplr0 : std_logic_vector(31 downto 0) := x"00000000";
  signal Wnum : std_logic_vector(4 downto 0);
  signal Wdata : std_logic_vector(31 downto 0);
  signal A0, B0 : std_logic_vector(31 downto 0);
begin  -- reg
    
  move_link_register: process (movlr)
  begin  -- process move_link_register
    if movlr = '1' then
      tmplr0 <= lr0;
    end if;
  end process move_link_register;

  LRout <= lr0;

  readout: process (rs, rt, Gorf)
  begin  -- process read
      if GorF = '1' then
        A0 <= freg(conv_integer(rs))(31 downto 0);
        B0 <= freg(conv_integer(rt))(31 downto 0);
      else
        A0 <= greg(conv_integer(rs))(31 downto 0);
        B0 <= greg(conv_integer(rt))(31 downto 0);
      end if;
  end process;

  z: process (rs, rt, LR, A0, B0)
  begin  -- process z
    if LR='0' then
      if rs="00000" then
        A <= x"00000000";
      else
        A <= A0;
      end if;
      if rt="00000" then
        B <= x"00000000";
      else
        B <= B0;
      end if;
    else
      A <= tmplr0; B <= lr0;
    end if;
  end process z;

  MuxA: process (RegDst, rt, rd, Wdata)
  begin  -- process MuxA
--    if rising_edge(clk) then
--      Wnum <= rt when RegDst = '0' else rd;
    case RegDst is
      when "00" => Wnum <= rs;
      when "01" => Wnum <= rt;
      when "10" => Wnum <= rd;
      when others => null;
    end case;
    --if RegDst = '0' then
    --    Wnum <= rt;
    --  else
    --    Wnum <= rd;
    --  end if;
--    end if;
  end process;

  MuxB: process (ALUOut, DMR, REG_InData, MemtoReg, RegWrite)
  begin  -- process MuxB
--    if rising_edge(clk) then
      case MemtoReg is
        when "00" => Wdata <= ALUOut;
        when "01" => Wdata <= DMR;
        when "10" => Wdata <= REG_InData;
        when others => null;
      end case;
--    end if;
  end process;
  
  wp: process (Wdata, RegWrite, LRWrite)
  begin  -- process wp
    if RegWrite = '1' then
      if GorF = '1' then
        freg(conv_integer(Wnum)) <= "0000"&Wdata;
      else
        greg(conv_integer(Wnum)) <= "0000"&Wdata;
      end if;
    end if;
    if LRWrite = '1' then
      lr0 <= Wdata;
    end if;
  end process wp;
end rgstr;
