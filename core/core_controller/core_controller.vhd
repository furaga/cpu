library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity core_controller is
  port ( 
    clk   : in  std_logic;
    rx    : in  std_logic;
    op    : in  std_logic_vector(5 downto 0);
    funct : in  std_logic_vector(5 downto 0);
    tx    : out std_logic);
end core_controller;

architecture cctrl of core_controller is
  signal RamOut : std_logic_vector(31 downto 0) := x"FFFFFFFF";
  signal A,B : std_logic_vector(31 downto 0);
  signal OBCtrl, set, get, send, recv, busy, got : std_logic;  -- IO制御線
  signal InData : std_logic_vector(31 downto 0);
  signal RorW, Mem, RamAddr, RamData : std_logic;  -- RAM制御線
  signal PCout, ALUout : std_logic_vector(31 downto 0) := x"FFFFFFFF";
  signal ALUControl : std_logic_vector(3 downto 0) := "1111";
  signal ANS, Obuf : std_logic_vector(31 downto 0);  -- Obuf = ALUOut
  signal Im : std_logic_vector(15 downto 0);
  signal ALU_MACtrl, branch : std_logic;  -- ALU制御線
  signal ALU_MBCtrl, CondReg : std_logic_vector(1 downto 0);  --ALU制御線
  signal rs,rt,rd : std_logic_vector(4 downto 0);
  signal RegDst : std_logic_vector(1 downto 0);
  signal MemtoReg, MemWrite, GorF : std_logic := '0';  -- Register制御線
  signal DMR : std_logic_vector(31 downto 0);        -- DataMemoryRegister
  signal IRWrite : std_logic;           -- IR制御線
  signal JAddr : std_logic_vector(25 downto 0);
  signal PCSource : std_logic_vector(1 downto 0);  -- PC制御線

  component ProgramCounter
    port (
      PCplus   : in std_logic_vector(31 downto 0);
      ALUout   : in std_logic_vector(31 downto 0);
      Jaddr    : in std_logic_vector(25 downto 0);
      PCSource : in std_logic_vector(1 downto 0);
      PCout    : out std_logic_vector(31 downto 0));
  end component;

  component IR
    port (
      in1 : in std_logic_vector(31 downto 0);
      DMR        : out std_logic_vector(31 downto 0);   -- Data memory register
      J_addr     : out std_logic_vector(25 downto 0);   -- Jump address
      op         : out std_logic_vector(5 downto 0);
      rs, rt, rd : out std_logic_vector(4 downto 0);
      IRWrite    : in  std_logic_vector;
      Imm        : out std_logic_vector(15 downto 0));
  end component;

  component Registers
    port (
      rs,rt,rd : in std_logic_vector(4 downto 0);  -- opcode [25 - 0]
      RegDst : in std_logic_vector(1 downto 0);              -- 書く番号の選択(Mux)
      MemtoReg : in std_logic;              -- 書きこむデータの選択(Mux)
      MemWrite : in std_logic;            -- 立った時点の値が書き込まれる
      GorF   : in std_logic := '0';       -- Grobal or Floating point
      DMR, ALUOut : in std_logic_vector(31 downto 0); -- DMR:DataMemoryRegister
      InData   : in std_logic_vector(31 downto 0);
      A, B   : out std_logic_vector(31 downto 0));
  end component;

  component ALU is
    port (
      A, PC   : in  std_logic_vector(31 downto 0);  -- MuxA でどちらかを選択する。
      B       : in  std_logic_vector(31 downto 0);  -- BとImを符号拡張したもの、imを符号拡張して2bit左シフトしたもの、
      Im      : in  std_logic_vector(15 downto 0);  -- 定数の4をMuxBは選択する。
      control : in std_logic_vector(3 downto 0);  
      branch  : in std_logic;             -- branch命令であれば、計算結果はALUOutに書き込まない。
      MACtrl  : in std_logic;
      MBCtrl  : in std_logic_vector(1 downto 0);
      ANS,Obuf : out std_logic_vector(31 downto 0);  -- Obufは、一つ前の計算結果を保存しておく
      condreg  : out std_logic_vector(1 downto 0));   -- 計算結果が負->01, 正->10, ゼロ->00
  end component;

  component RAM is
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
  end component;

  component io_device is
    generic (
      wtime : std_logic_vector(15 downto 0) := x"1ADB");
    port (
      clk    : in  std_logic;
      RAMOut : in  std_logic_vector(31 downto 0);
      RegB   : in  std_logic_vector(31 downto 0);
      OBCtrl : in  std_logic;             --  out buffer 付属のMultiplexer
      set,get: in  std_logic;
      send,recv: in  std_logic;
      RX     : in  std_logic;
      TX     : out std_logic;
      busy   : out std_logic;
      got    : out std_logic;             -- getが立った後にget終了した場合に1を返す
      InData : out std_logic_vector(31 downto 0));
  end component;
begin  -- cctrl
  usePC: ProgramCounter
    port map (
      PCplus   => PCplus,
      ALUout   => Obuf,
      Jaddr    => JAddr,
      PCSource => PCSource,
      PCout    => PCout )

  useIR: IR
    port map (
      in1     => RamOut,
      DMR     => DMR,
      J_addr  => JAddr,
      op      => op,                    -- entity宣言内の信号
      rs      => rs,
      rt      => rt,
      rd      => rd,
      IRWrite => IRWrite,
      Imm     => Im)

  useReg: Registers
    port map (
      rs       => rs,
      rt       => rt,
      rd       => rd,
      RegDst   => RegDst,
      MemtoReg => MemtoReg,
      MemWrite => MemWrite,
      GorF     => GorF,
      DMR      => DMR,
      ALUOut   => Obuf,
      InData   => InData,
      A        => A,
      B        => B)

  useALU: ALU
    port map (
      A       => A,
      PC      => PCout,
      B       => B,
      Im      => Im,
      control => ALUControl,
      branch  => branch,
      MACtrl  => ALU_MACtrl,
      MBCtrl  => ALU_MBCtrl,
      ANS     => ANS,
      Obuf    => Obuf,
      condreg => CondReg)

  useram: RAM
    port map (
      PCout   => PCout,
      ALUout  => ALUout,
      exin    => InData,
      RegB    => B,
      RorW    => RorW,
      Mem     => Mem,
      RamAddr => RamAddr,
      RamData => RamData,
      RamOut  => RamOut)

  io: io_device generic map (wtime => x"1ADB")
    port map (
      clk    => clk,
      RAMOut => RamOut,
      RegB   => B,
      OBCtrl => OBCtrl,
      set    => set,
      get    => get,
      send   => send,
      recv   => recv,
      RX     => rx,
      TX     => tx,
      busy   => busy,
      got    => got,
      InData => InData)

end cctrl;
