library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity core_controller is
  port ( 
    clk   : in  std_logic;
    rx    : in  std_logic;
    tx    : out std_logic);
end core_controller; 

architecture cctrl of core_controller is
  
  -- Components Declaration for the Unit Under Test (UUT)
  component ProgramCounter
    port (
      clk      : in std_logic;
      PCplus   : in std_logic_vector(31 downto 0);
      ALUout   : in std_logic_vector(31 downto 0);
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
      RegDst : in std_logic_vector(1 downto 0);              -- 書く番号の選択(Mux)
      MemtoReg : in std_logic_vector(1 downto 0);              -- 書きこむデータの選択(Mux)
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
      RAMOut : in  std_logic_vector(31 downto 0);
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
  signal cstate : std_logic_vector(3 downto 0) := "1111";
  signal substate : std_logic_vector(1 downto 0) := "11";
  signal init : std_logic := '1';       -- init
  signal RorW, Mem, RamAddr : std_logic := '0';  -- RAM制御線
  signal RamData : std_logic_vector(1 downto 0) := "00";
  signal RamOut : std_logic_vector(31 downto 0) := x"FFFFFFFF";
  signal op : std_logic_vector(5 downto 0) := "000000";
  signal rs,rt,rd : std_logic_vector(4 downto 0);
  signal Imm : std_logic_vector(15 downto 0);
  signal JAddr : std_logic_vector(25 downto 0);

  signal DMR : std_logic_vector(31 downto 0);        -- DataMemoryRegister
  signal coreop: std_logic_vector(31 downto 0) := x"00000000";  
  signal IRWrite, IRin : std_logic := '0';           -- IR制御線

  signal branch,MACtrl : std_logic := '0';  -- ALU制御線
  signal MBCtrl : std_logic_vector(1 downto 0);  --ALU制御線
  signal condreg : std_logic_vector(2 downto 0);
  signal ALUControl : std_logic_vector(3 downto 0) := "1111";
  signal Iflg : std_logic := '0';       -- i命令 なら1
  signal A,B : std_logic_vector(31 downto 0);
  signal LRout : std_logic_vector(31 downto 0);
  signal ANS : std_logic_vector(31 downto 0);
  signal wait_clk : std_logic_vector(3 downto 0) := "0000";
  signal PCout, ALUout : std_logic_vector(31 downto 0) := x"00000004";
  signal PCWrite : std_logic := '0';
  signal PCChange : std_logic := '0';
  signal PCSource : std_logic_vector(1 downto 0);  -- PC制御線
--   signal PCplus : std_logic_vector(31 downto 0) := (others => '0');

  signal RegWrite, GorF : std_logic := '0';  -- Register制御線
  signal RegDst : std_logic_vector(1 downto 0) := "01";
  signal movlr, LR, LRWrite : std_logic;
  signal memtoReg : std_logic_vector(1 downto 0) := "11";
  signal OPflg : std_logic := '1';
  signal InData : std_logic_vector(31 downto 0);

  signal get, send : std_logic := '0';  -- IO制御線

  signal JumpCond : std_logic_vector(2 downto 0) := "000";

  signal recv_busy : std_logic := '0';
  signal send_busy : std_logic := '0';
  signal OutData : std_logic_vector(7 downto 0);

  signal funct : std_logic_vector(5 downto 0);
  type OProm is array (0 to 7) of std_logic_vector(31 downto 0);
  constant init_op : OProm :=
    ("10000000000000100000000000000000",  -- *0 ldrom r2 <- ROM[r0 - 0]
     "00100000011000110000000000000100",  -- *4 addi  r3 <- r3 + 4
     "10000000011001000000000000000000",  -- *8 ldrom r4 <- ROM[r3 - 0]
     "10101100011001000000000000000100",  -- 12 sti   RAM[r3 - 4] <- r4
     "01001000010000111111111111110100",  -- 16 jne   r2, r3, -3
     "00100000000000110000000000000000",  -- 20 addi  r3 <- r0, 0
     "00100000000001000000000000000000",  -- 24 addi  r4 <- r0, 0
     "00101100010000000000000000000100"   -- 28 bri   r2, 4(001011)
--    ,"00000000000000000000000000000000"
     );


  --Outputs


  -- Clock period definitions
  constant clk_period : time := 10 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)

  usePC: ProgramCounter
    port map (
      clk      => clk,
      PCplus   => ANS,
      ALUout   => aluout,
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
      RegWrite => RegWrite,
      GorF     => GorF,
      movlr    => movlr,
      LR       => LR,
      LRWrite  => LRWrite,
      DMR      => DMR,
      ALUOut   => aluout,
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
      ANS     => ANS,
      aluout  => aluout,
      condreg => CondReg);

  useRAM: RAM
    port map (
      clk      => clk,
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
      RAMOut => RamOut,
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

  statemachine: process (clk)
  begin  -- process statemachine
    if rising_edge(clk) then
      if wait_clk(2 downto 0)/="000" then
        wait_clk <= wait_clk-1;
      else
      case cstate is
-------------------------------------------------------------------------------
-- Instruction Fetch
-- IR <= Memory[PC]
-- PC <= PC + 4
-------------------------------------------------------------------------------
        when "0000" =>
            GorF <= '0'; PCChange <= '0';Iflg <= '0'; LRWrite <= '0';
            PCWrite <= '1'; OPflg <= '1'; RamAddr <= '1';
            IRWrite <= '1'; ALUControl <= "0000"; MBCtrl <= "01"; Mem <= '1';
            MACtrl <= '0'; branch <= '1'; PCSource <= "00"; OPflg <= '1';
            cstate <= "0001";  send <= '0'; movlr <= '0';
            RorW <= '0'; RegWrite <= '0'; PCWrite <= '1';LR <= '0';
          if init = '0' then
            IRin <= '0';
          else
            IRin <= '1';
            coreop <= init_op(conv_integer(PCout(31 downto 2)));
            if PCout(4 downto 2) = "111" then
              init <= '0';
            end if;
          end if;
-------------------------------------------------------------------------------
-- Instruction Decode and Register Fetch
-------------------------------------------------------------------------------
        when "0001" =>                  -- Inst. Decode and Register Fetch
          MACtrl <= '0'; MBCtrl <= "10"; branch <= '1'; PCWrite <= '0';
          IRWrite <= '0'; Mem <= '0';
          case op is
            when "000000" => cstate <= x"3";  -- SPECIAL
            when "000001" => cstate <= x"5";  -- I/O
            when "000011" => cstate <= x"3";  -- padd(I
                             Iflg <= '1';
            when "000111" => cstate <= x"3";  -- mvlo
            when "001111" => cstate <= x"3";  -- mvhi
            when "001000" => cstate <= x"3";  -- addi
                             Iflg <= '1';
            when "001011" => cstate <= x"3";  -- bri branch to rs + imm
            when "010000" => cstate <= x"3";  -- subi
                             Iflg <= '1';
            when "011000" => cstate <= x"3";  -- muli
                             Iflg <= '1';
            when "100000" => cstate <= x"2";  -- ldrom (ROMから読み出す(初期化用
            when "101000" => cstate <= x"3";  -- slli
                             Iflg <= '1';
            when "010001" => cstate <= x"0";  -- FP inst.
            when "010011" => cstate <= x"2";  -- ld
            when "011011" => cstate <= x"2";  -- st
            when "100011" => cstate <= x"2";  -- ldi
                             Iflg <= '1';
            when "101010" => cstate <= x"3";
                             Iflg <= '1';
            when "101011" => cstate <= x"2";  -- sti
                             Iflg <= '1';
            when "110011" => cstate <= x"2";  -- ldlr
            when "111011" => cstate <= x"2";  -- stlr
            when "110001" => cstate <= x"2";  -- fld
            when "111001" => cstate <= x"2";  -- fst
            when "000010" => cstate <= x"4";  -- jmp
                             JumpCond <= "111";
            when "001010" => cstate <= x"4";  -- jeq
                             JumpCond <= "010";
            when "010010" => cstate <= x"4";  -- jne
                             JumpCond <= "101";
            when "011010" => cstate <= x"4";  -- jlt
                             JumpCond <= "100";
            when "100010" => cstate <= x"4";  -- jle
                             JumpCond <= "110";
            when "111101" => cstate <= x"3";  -- link ( lr <- pc + imm)
                             Iflg <= '1';
            when others => null;
          end case;
-------------------------------------------------------------------------------
-- load or store
-- 010011 ld
-- 011011 st
-- 100011 ldi
-- 101011 sti
-- 110011 ldlr
-- 111011 stlr
-- op(5)=0 -> R, op(5)=1 -> I.
-- op(3)=0 -> ld系, op(3)=1 -> st系
-- op(5 downto 4)=11 -> LR, else -> grobal
-------------------------------------------------------------------------------
        when "0010" =>
          RamAddr <= '0';
          case substate is
            when "00" =>
              PCChange <= '0';
              if op(3) = '0' or op = "100000" then     -- load 2
                RorW <= '0'; Mem <= '1';
              end if;
              if op(3) = '1' then     -- store 2
                RorW <= '1';
                if op(5 downto 4)="11" then
                  RamData <= "10";
                else
                  RamData <= "00";
                end if;
              end if;
              substate <= "01";
            when "01" =>
              if op(3) = '0' or op = "100000" then  -- load 3
                RegDst <= "01";
                MemtoReg <= "01";
                if op(5 downto 4) = "11" then
                  LRWrite <= '1';
                else
                  RegWrite <= '1';
                end if;
              end if;
              RamAddr <= '1';
              RorW <= '0';
              cstate <= "0000"; substate <= "11";
            when "11" =>                -- load/store 1
              if op = "100000" then     -- ROMから読み込む場合(init?
                OPflg <= '1';
              else
                OPflg <= '0';
              end if;
              PCChange <= '1';  PCWrite <= '0'; branch <= '1';
              MACtrl <= '1';
              if op(5) = '1' then       -- I形式 op(0) -> op(5)に変更
                MBCtrl <= "10"; ALUControl <= "0001";
              else                      -- R形式
                MBCtrl <= "00"; ALUControl <= "0000";
              end if;
              substate <= "00";
            when others => cstate <= "0000";
          end case;
-------------------------------------------------------------------------------
-- Calculate (R/I)
-------------------------------------------------------------------------------
        when "0011" =>  
          PCWrite <= '0';
          MACtrl <= '1';
          case substate is
            when "00" =>
              if Iflg = '0' and (funct = "010000" or op = "001011" ) then  -- b命令
                PCWrite <= '1'; PCSource <= "01";
                substate <= "11"; CState <= "0000"; PCChange <= '1';
              else                        -- Calculate 2
                substate <= "11"; CState <= "0000";
                MemtoReg <= "00"; PCChange <= '1';LRWrite <= '0';
                 if op /= "111101" then  -- link?
                  RegWrite <= '1';
                end if;
              end if;
            when "01" => 
              substate <= "00";  -- btmplrで1clk待つ
             when "10" =>                -- movlrで1clk待つ.
              substate <= "11"; movlr <= '0'; CState <= "0000"; PCChange <= '1';
            when "11" =>  
              case op is
                when "000000" =>           -- SPECIAL
                  MBCtrl <= "00";        
                  case funct is
                    when "000000" => ALUControl <= "0100";  -- S_L
                                     branch <= '1'; substate <= "00";RegDst <= "10"; 
                    when "110011" => movlr <= '1'; substate <= "10";
                    when "000010" => ALUControl <= "0101";  -- S_R
                                     branch <= '1'; substate <= "00";RegDst <= "10"; 
                    when "011000" => ALUControl <= "0010";  -- MUL
                                     branch <= '1';RegDst <= "10";
                                     case wait_clk is
                                       when "0000" => wait_clk <= "1011";
                                       when "1000" => substate <= "00"; wait_clk <= "0000";
                                       when others => null;
                                     end case;
                    when "011011" => ALUControl <= "1000";  -- NOR
                                     branch <= '1'; substate <= "00";RegDst <= "10"; 
                    when "100000" => ALUControl <= "0000";  -- ADD
                                     branch <= '1'; substate <= "00";RegDst <= "10"; 
                    when "100010" => ALUControl <= "0001";  -- SUB
                                     branch <= '1'; substate <= "00";RegDst <= "10"; 
                    when "100100" => ALUControl <= "0110";  -- AND
                                     branch <= '1'; substate <= "00";RegDst <= "10"; 
                    when "100101" => ALUControl <= "0111";  -- OR
                                     branch <= '1'; substate <= "00";RegDst <= "10"; 
-- 特別 ------
                    when "001000" =>        -- branch(PCの値をrs(in1)の値に
                      ALUControl <= "1111";
                      branch <= '1'; substate <= "00";
                    when "010000" =>    -- btmplr
                      ALUControl <= "1111";
                      LR <= '1'; substate <= "01";
                    when "111111" => null;
                    when others => null;
                  end case;
-------------------------------------------------------------------------------
-- I形式
-------------------------------------------------------------------------------
                when "000011" =>          -- padd
                  ALUControl <= "0000"; MACtrl <= '0'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; RegDst <= "01";
                when "001000" =>            -- ADD Immediate
                  ALUControl <= "0000"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; RegDst <= "01";
                when "001011" =>            -- branch reg and immediate
                  ALUControl <= "0000"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00";
                when "010000" =>            -- SUB Immediate
                  ALUControl <= "0001"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; RegDst <= "01";
                when "011000" =>            -- MUL Immediate
                  ALUControl <= "0010"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; RegDst <= "01";
                  case wait_clk is
                    when "0000" => wait_clk <= "1011";
                    when "1000" => substate <= "00"; wait_clk <= "0000";
                    when others => null;
                  end case;
                when "101000" =>            -- SLL Immediate
                  ALUControl <= "0100"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; RegDst <= "01";
                when "101010" =>            -- SRL Immediate
                  ALUControl <= "0101"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; RegDst <= "01";
                when "000111" =>            -- mvlo
                  ALUControl <= "1010"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; RegDst <= "00";
                when "001111" =>            -- mvhi
                  ALUControl <= "1001"; MACtrl <= '1'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; RegDst <= "00";
                when "111101" =>            -- link 
                  ALUControl <= "0000"; MACtrl <= '0'; MBCtrl <= "10";
                  branch <= '1'; substate <= "00"; LRWrite <= '1';
                when "111111" => CState <= "1111";
                when others => null;
              end case;
            when others => null;
          end case;
-------------------------------------------------------------------------------
-- Jump 命令
-------------------------------------------------------------------------------          
        when "0100" =>
          PCWrite <= '0';
          case substate is
            when "00" => 
              substate <= substate+1;
            when "01" =>
              if (JumpCond and condreg) /= "000" then
                PCWrite <= '1'; substate <= "11";
              end if;
              PCChange <= '1';
              substate <= "11"; CState <= "0000";
            when "11" => 
              ALUControl <= "0001"; branch <= '0';MACtrl <= '1';
              substate <= "00"; MBCtrl <= "00";
              if op = "000010" then
                PCSource <= "10";
              else
                PCSource <= "01";
              end if;
            when others => substate <= "11";
          end case;
-------------------------------------------------------------------------------
-- I/O 命令
-------------------------------------------------------------------------------          
        when "0101" => 
          PCWrite <= '0'; PCChange <= '1';
          if funct = "000000" then     -- input
            case substate is
              when "00" => 
                substate <= substate+1;
              when "01" => 
                get <= '0';
                if recv_busy = '0' then
                  RegDst <= "10"; MemtoReg <= "10";
                  RegWrite <= '1'; substate <= "11";
                  CState <= "0000";
                end if;
              when "11" => 
                get <= '1';
                substate <= substate+1;
              when others => null;
            end case;
          end if;
          if funct = "000001" then      -- output
            case substate is
              when "00" =>
                substate <= "01";
              when "01" =>
                send <= '0';
                if send_busy='0' then
                  substate <= "11";
                  CState <= "0000";
                end if;
              when "11" => 
                substate <= substate+1;
                send <= '1';
              when others => null;
            end case;
          end if;
-------------------------------------------------------------------------------
-- その他
-------------------------------------------------------------------------------
        when "1111" =>
          RegWrite <= '0'; CState <= "0000";
          PCWrite <= '0'; PCChange <= '1';
        when others => null;
      end case;
    end if;
    end if;
  end process statemachine;


end cctrl;
