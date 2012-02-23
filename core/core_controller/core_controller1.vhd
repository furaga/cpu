library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity core_controller is
  port ( 
    clk   : in  std_logic;
    locked: in  std_logic;
    rx    : in  std_logic;
    tx    : out std_logic);
end core_controller; 

architecture cctrl of core_controller is
  
  component ProgramCounter
    port (
      clk      : in std_logic;
      ALUout   : in std_logic_vector(31 downto 0);
      A        : in std_logic_vector(31 downto 0);
      Jaddr    : in std_logic_vector(25 downto 0);
      PCWrite  : in std_logic;
      PCChange : in std_logic;
      PCSource : in std_logic_vector(1 downto 0);
      PCout    : out std_logic_vector(31 downto 0));
  end component;

  component IR
    port (
      clk        : in  std_logic;
      in1        : in  std_logic_vector(31 downto 0);
      in2        : in  std_logic_vector(31 downto 0);
      IRin       : in  std_logic;
      DMR        : out std_logic_vector(31 downto 0);   -- Data memory register
      J_addr     : out std_logic_vector(25 downto 0);   -- Jump address
      op         : out std_logic_vector(5 downto 0);
      rs, rt, rd : out std_logic_vector(4 downto 0);
      IRWrite    : in  std_logic;
      Imm        : out std_logic_vector(15 downto 0));
  end component;


  component Registers
    port (
      clk      : in std_logic;
      rs,rt,rd : in std_logic_vector(4 downto 0);  -- opcode [25 - 0]
      RegDst   : in std_logic_vector(1 downto 0);              -- 書く番号の選択(Mux)
      MemtoReg : in std_logic_vector(1 downto 0);              -- 書きこむデータの選択(Mux)
      BAddr    : in std_logic;
      RegWrite : in std_logic;            -- 立った時点の値が書き込まれる
      GorF     : in std_logic := '0';       -- Grobal or Floating point
      movlr    : in std_logic := '0';
      LR       : in std_logic := '0';
      LRWrite  : in std_logic := '0';
      DMR, ALUOut : in std_logic_vector(31 downto 0); -- DMR:DataMemoryRegister
      REG_InData   : in std_logic_vector(31 downto 0);
      A, B   : out std_logic_vector(31 downto 0);
      LRout  : out std_logic_vector(31 downto 0));
  end component;

  component ALU is
    port (
      clk     : in std_logic;
      A, PC   : in  std_logic_vector(31 downto 0);  -- MuxA でどちらかを選択する。
      B       : in  std_logic_vector(31 downto 0);  -- BとImを符号拡張したもの、imを符号拡張して2bit左シフトしたもの、
      Im      : in  std_logic_vector(15 downto 0);  -- 定数の4をMuxBは選択する。
      control : in std_logic_vector(3 downto 0);  
      branch  : in std_logic;             -- branch命令であれば、計算結果はALUOutに書き込まない。
      MACtrl  : in std_logic;
      MBCtrl  : in std_logic_vector(1 downto 0);
      ANS,ALUout : out std_logic_vector(31 downto 0);  -- aluoutは、一つ前の計算結果を保存しておく
      condreg  : out std_logic_vector(2 downto 0));   -- 計算結果が負->01, 正->10, ゼロ->00
  end component;

  component RAM is
    port (
      clk     : in std_logic;
      PCout   : in  std_logic_vector(31 downto 0);
      ALUout  : in  std_logic_vector(31 downto 0);
      exin    : in  std_logic_vector(31 downto 0);  -- 外部入力
      RegB    : in  std_logic_vector(31 downto 0);  -- reg out 2
      LRout   : in  std_logic_vector(31 downto 0);
      RorW    : in  std_logic;                      -- read or write
      Mem     : in  std_logic;            -- 立った時点での操作が行われる
      RamAddr : in  std_logic;
      RamData : in  std_logic_vector(1 downto 0);
      OPflg   : in  std_logic;
      RamOut  : out std_logic_vector(31 downto 0));
  end component;

  component io_device is
--    generic (wtime : std_logic_vector(15 downto 0) := x"1ADB");
    port (
      clk    : in  std_logic;
      RegA   : in  std_logic_vector(31 downto 0);
      get    : in  std_logic;
      send   : in  std_logic;
      RX     : in  std_logic;
      sbusy  : out std_logic;
      rbusy  : out std_logic;
      TX     : out std_logic;
      OutData: out std_logic_vector(7 downto 0);
      InData : out std_logic_vector(31 downto 0));
  end component;



  --signals

  signal chst : std_logic := '1';
  signal CV: std_logic_vector(2 downto 0) := "000";
  signal substate : std_logic_vector(1 downto 0) := "11";
  signal init : std_logic := '1';       -- init
  signal RorW, Mem, RamAddr : std_logic := '0';  -- RAM制御線
  signal RamData : std_logic_vector(1 downto 0) := "00";
  signal RamOut : std_logic_vector(31 downto 0) := x"FFFFFFFF";
  signal coreop: std_logic_vector(31 downto 0) := x"00000000";  
  signal op : std_logic_vector(5 downto 0) := "000000";
  signal funct : std_logic_vector(5 downto 0);
  signal rs,rt,rd : std_logic_vector(4 downto 0);
  signal Imm : std_logic_vector(15 downto 0);
  signal JAddr : std_logic_vector(25 downto 0);

  signal DMR : std_logic_vector(31 downto 0);        -- DataMemoryRegister
  signal IRWrite, IRin : std_logic := '0';           -- IR制御線

  signal branch,MACtrl : std_logic := '0';  -- ALU制御線
  signal MBCtrl : std_logic_vector(1 downto 0);  --ALU制御線
  signal condreg : std_logic_vector(2 downto 0);

  signal Jflg : std_logic := '0';       -- JUMP成立なら1
  signal ALUControl : std_logic_vector(3 downto 0) := "1111";
  signal A,B : std_logic_vector(31 downto 0);
  signal ALUout, PCout : std_logic_vector(31 downto 0) := x"00000000";
  signal LRout : std_logic_vector(31 downto 0);
  signal wait_clk : std_logic_vector(3 downto 0) := "0000";

  signal PCWrite : std_logic := '0';
  signal PCChange : std_logic := '0';
  signal PCSource : std_logic_vector(1 downto 0);  -- PC制御線

  signal RegWrite, GorF : std_logic := '0';  -- Register制御線
  signal RegDst : std_logic_vector(1 downto 0) := "01";
  signal BAddr, movlr, LR, LRflg, LRWrite : std_logic := '0';
  signal memtoReg : std_logic_vector(1 downto 0) := "11";
  signal OPflg : std_logic := '1';
  signal InData : std_logic_vector(31 downto 0);

  signal get, send : std_logic := '0';  -- IO制御線

  signal JumpCond : std_logic_vector(2 downto 0) := "000";

  signal recv_busy : std_logic := '0';
  signal send_busy : std_logic := '0';

  signal OutData : std_logic_vector(7 downto 0);


  type OProm is array (0 to 7) of std_logic_vector(31 downto 0);
  constant init_op : OProm :=
    --("00000100010000000000000000000001", -- *4 output r2
    --"00001000000000000000000000000000", -- *8 jmp 4
    --"00000000000000000000000000000000", -- *c nop
    --"00000000000000000000000000000000", -- 10 nop
    --"00000000000000000000000000000000", -- 10 npo
    --"00000000000000000000000000000000", -- 14 nop
    --"00000000000000000000000000000000", -- 18 nop
    --"00000000000000000000000000000000");-- 1c nop
    ("10000000000000100000000000000000",  -- *0 ldrom r2 <- ROM[r0 - 0]
     "00100000011000110000000000000100",  -- *4 addi  r3 <- r3 + 4
     "10000000011001000000000000000000",  -- *8 ldrom r4 <- ROM[r3 - 0]
     "10101100011001000000000000000100",  -- *c sti   RAM[r3 - 4] <- r4
     "01001000010000111111111111110100",  -- 10 jne   r2, r3, -3
     "00100000000000110000000000000000",  -- 14 addi  r3 <- r0, 0
     "00100000000001000000000000000000",  -- 18 addi  r4 <- r0, 0
     "00101100010000000000000000000100"); -- 1c bri   r2, 4(001011)

  --Outputs


  -- Clock period definitions
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)

  usePC: ProgramCounter
    port map (
      clk      => clk,
      ALUout   => ALUout,
      A        => A,
      Jaddr    => JAddr,
      PCWrite  => PCWrite,
      PCChange => PCChange,
      PCSource => PCSource,
      PCout    => PCout);

  useIR: IR
    port map (
      clk     => clk,
      in1     => RamOut,
      in2     => coreop,
      IRin    => IRin,
      DMR     => DMR,
      J_addr  => JAddr,
      op      => op,                    -- entity宣言内の信号
      rs      => rs,
      rt      => rt,
      rd      => rd,
      IRWrite => IRWrite,
      Imm     => Imm);

  useReg: Registers
    port map (
      clk      => clk,
      rs       => rs,
      rt       => rt,
      rd       => rd,
      RegDst   => RegDst,
      MemtoReg => MemtoReg,
      BAddr    => BAddr,
      RegWrite => RegWrite,
      GorF     => GorF,
      movlr    => movlr,
      LR       => LR,
      LRWrite  => LRWrite,
      DMR      => DMR,
      ALUOut   => ALUOut,
      REG_InData  => InData,
      A        => A,
      B        => B,
      LRout    => LRout);

  useALU: ALU
    port map (
      clk     => clk,
      A       => A,
      PC      => PCout,
      B       => B,
      Im      => Imm,
      control => ALUControl,
      branch  => branch,
      MACtrl  => MACtrl,
      MBCtrl  => MBCtrl,
      ANS     => open,
      aluout  => ALUOut,
      condreg => CondReg);

  useRAM: RAM
    port map (
      clk     => clk,
      PCout   => PCout,
      ALUout  => ALUout,
      exin    => InData,
      RegB    => B,
      LRout   => LRout,
      RorW    => RorW,
      Mem     => Mem,
      RamAddr => RamAddr,
      RamData => RamData,
      OPflg   => OPflg,
      RamOut  => RamOut);

  io: io_device --generic map (wtime => x"1ADB")
    port map (
      clk    => clk,
      RegA   => A,
      get    => get,
      send   => send,
      RX     => rx,
      sbusy  => send_busy,
      rbusy  => recv_busy,
      TX     => tx,
      OutData => OutData,
      InData => InData);


  funct <= Imm(5 downto 0);

-- CV: FT DC EX MA WB
  CPU_START: process (clk)
  begin  -- process CPU_START
    if rising_edge(clk) and locked='1'then
      if CV="101" then
        CV <= "100";
      else
        if chst='0' then
          CV <= "111";
        else
          CV <= (not CV(0))&CV(2 downto 1);
        end if;
      end if;
    end if;
  end process CPU_START;

-- Instruction Fetch
-- IR <= Memory[PC]
-- PC <= PC + 4
  state_machine: process (clk)
  begin  -- process state_machine
    if rising_edge(clk) then
      case CV is
        when "100" =>                     -- FETCH_STEP
--          CVDBG <= "10000"; dcount <= dcount+1;
          GorF <= '0'; PCChange <= '0'; LRWrite <= '0'; LRflg <= '0';
          PCWrite <= '0'; OPflg <= '1'; RamAddr <= '1';
          IRWrite <= '1'; ALUControl <= "0000"; MBCtrl <= "01"; Mem <= '1';
          MACtrl <= '0'; branch <= '0'; PCSource <= "01";
          send <= '0'; movlr <= '0';
          RorW <= '0'; RegWrite <= '0'; LR <= '0';
          if init = '0' then
            IRin <= '0';
          else
            IRin <= '1';
            coreop <= init_op(conv_integer(PCout(31 downto 2)));
            if PCout(4 downto 2) = "111" then
              init <= '0';-- dcount <= x"FFFF";
            end if;
          end if;
        when "110" =>                     -- DECODE_STEP
--          CVDBG <= "01000";
          MACtrl <= '0'; MBCtrl <= "10"; branch <= '0'; PCWrite <= '1';
          IRWrite <= '0'; Mem <= '0'; JumpCond <= "000";
        when "111" =>                     -- EXEC_STEP
--          CVDBG <= "00100";
          PCWrite <= '0';
          case op is
--SPECIAL
            when "000000" =>              -- SPECIAL
              MACtrl <= '1'; MBCtrl <= "00";
              MemtoReg <= "00"; branch <= '0'; RegDst <= "10";
              case funct is
                when "000000" => ALUControl <= "0100";  -- SLL
                when "000010" => ALUControl <= "0101";  -- SRL
                when "001000" => PCSource <= "00";      -- branch (PC <- rs)
                when "010000" => -- btmplr(PC <- tmplr)
                  LR <= '1'; PCSource <= "00"; JumpCond <= "111";
                when "011000" => ALUControl <= "0010";  -- MUL
                when "100000" => ALUControl <= "0000";  -- ADD
                when "100010" => ALUControl <= "0001";  -- SUB
                when "100011" => ALUControl <= "0110";  -- AND
                when "100101" => ALUControl <= "0111";  -- OR
                when "110011" => movlr <= '1'; RegDst <= "11";  -- movlr
                when "111111" => chst <= '0';    -- halt
                when others => null;
              end case;
-- I/O
            when "000001" =>              -- I/O
              case funct(0) is
                when '0' =>          -- input
                  if chst='1' then
                    chst <= '0';
                  else
                    if recv_busy='0' then
                      chst <= '1'; RegDst <= "10"; MemtoReg <= "10";
                    end if;
                  end if;
                when '1' =>          -- output
                  if send_busy='1' then
                    chst <= '0';
                  else
                    send <= '1'; chst <= '1';
                  end if;
                when others => null;
              end case;
            when "000011" =>              -- padd (rt <- pc + imm
              MACtrl <= '0'; MBCtrl <= "10"; RegDst <= "01"; ALUControl <= "0000"; MemtoReg <= "00"; branch <= '0';
-- mvlo, mvhi
            when "000111" =>              -- mvlo (rs <- rs(31 - 16) & Immediate
              ALUControl <= "1010"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "00"; MemtoReg <= "00"; branch <= '0';
            when "001111" =>              -- mvhi
              ALUControl <= "1001"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "00"; MemtoReg <= "00"; branch <= '0';
--Immediate instructions
            when "001000" =>              -- addi
              ALUControl <= "0000"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "01"; MemtoReg <= "00"; branch <= '0';
            when "010000" =>              -- subi
              ALUControl <= "0001"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "01"; MemtoReg <= "00"; branch <= '0';
            when "011000" =>              -- muli
              ALUControl <= "0010"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "01"; MemtoReg <= "00"; branch <= '0';
            when "101000" =>              -- slli
              ALUControl <= "0100"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "01"; MemtoReg <= "00"; branch <= '0';
            when "101010" =>              -- srli
              ALUControl <= "0101"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "01"; MemtoReg <= "00"; branch <= '0';
-- JUMP
            when "001011" =>              -- branch immediate( PC <- rs + imm
              JumpCond <= "111"; PCSource <= "01"; branch <= '0';
              ALUControl <= "0000"; MACtrl <= '1'; MBCtrl <= "10"; RegDst <= "11";
            when "000010" =>              -- PC <- target
              JumpCond <= "111"; PCSource <= "10"; RegDst <= "11";
            when "001010" =>              -- jeq
              branch <= '1'; PCSource <= "01"; MACtrl <= '1'; MBCtrl <= "00";
              JumpCond <= "010"; ALUControl <= "0001"; RegDst <= "11";
            when "010010" =>              -- jne
              branch <= '1'; PCSource <= "01"; MACtrl <= '1'; MBCtrl <= "00";
              JumpCond <= "101"; ALUControl <= "0001"; RegDst <= "11";
            when "011010" =>              -- jlt (jump less than
              branch <= '1'; PCSource <= "01"; MACtrl <= '1'; MBCtrl <= "00";
              JumpCond <= "100"; ALUControl <= "0001"; RegDst <= "11";
            when "100010" =>              -- jle (jump less than or equal to
              branch <= '1'; PCSource <= "01"; MACtrl <= '1'; MBCtrl <= "00";
              JumpCond <= "110"; ALUControl <= "0001"; RegDst <= "11";
-- LINK
            when "111101" =>              -- lr <- PC + imm
              MACtrl <= '0'; MBCtrl <= "10"; RegDst <= "11"; MemtoReg <= "00";
              LRflg <= '1'; branch <= '0';
-- LOAD(アドレス計算
            when "100000" =>              -- ldrom(load ROM[rs - imm] to rt
              ALUControl <= "0001"; MACtrl <= '1'; MBCtrl <= "10"; RamAddr <= '0';
              RegDst <= "01"; MemtoReg <= "01"; OPflg <= '1'; branch <= '0';
            when "010011" =>              -- load (load[rs + rt] to rd
              ALUControl <= "0000"; MACtrl <= '1'; MBCtrl <= "00"; RamAddr <= '0';
              RegDst <= "01"; MemtoReg <= "01"; OPflg <= '0'; branch <= '0';
            when "100011" =>              -- load imm (load rs - imm to rt
              ALUControl <= "0001"; MACtrl <= '1'; MBCtrl <= "10"; RamAddr <= '0';
              RegDst <= "01"; MemtoReg <= "01"; RorW <= '0'; OPflg <= '0'; branch <= '0';
            when "110011" =>              -- ldlr (load rs - imm to LR
              ALUControl <= "0001"; MACtrl <= '1'; MBCtrl <= "10"; RamAddr <= '0'; branch <= '0';
              RegDst <= "11"; MemtoReg <= "01"; LRflg <= '1'; RorW <= '0'; OPflg <= '0';
-- STORE(アドレス計算
            when "011011" =>              -- store(store rd to rs + rt
              ALUControl <= "0000"; MACtrl <= '1'; MBCtrl <= "00"; RamAddr <= '0';
              RegDst <= "11"; RamData <= "00"; RorW <= '1'; branch <= '0';
            when "101011" =>              -- sti  (store rt to rs - imm
              ALUControl <= "0001"; MACtrl <= '1'; MBCtrl <= "10"; RamAddr <= '0';
              RegDst <= "11"; RamData <= "00"; RorW <= '1'; branch <= '0';
            when "111011" =>              -- stlr (store lr to rs - imm
              ALUControl <= "0001"; MACtrl <= '1'; MBCtrl <= "00"; RamAddr <= '0';
              RegDst <= "11"; RamData <= "10"; RorW <= '1'; branch <= '0';
            when others => null;
          end case;
        when "011" =>                     -- MEMORY_ACCESS_STEP
--          CVDBG <= "00010";
          branch <= '1';
          if op="011011" then             -- store rd to [rs+rt]
            BAddr <= '1';
          else
            Mem<='1';
          end if;
        when "001" =>                   -- JUMP_DECISION_STEP（あまり要らない
          Mem <= '1';
          if Jflg='1' then
            PCWrite <= '1';
          end if;
        when "000" =>                     -- WRITE_BACK_STEP
--          CVDBG <= "00001";
          PCChange <= '1';
          Mem <= '0'; RorW <= '0'; RamAddr <= '1';
          RegWrite <= '1'; 
          if LRflg='1' then
            LRWrite <= '1';
          end if;
        when others => null;
      end case;
    end if;    
  end process state_machine;

  Jump_decision: process (condreg, JumpCond)
  begin  -- process Jump_decision
    if (condreg and JumpCond)/="000" then
      Jflg <= '1';
    else
      Jflg <= '0';
    end if;
  end process Jump_decision;


end cctrl;
