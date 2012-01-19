-- Tue Oct 18 15:05:0541 2011
-- ALU

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

package alu_pack is
  constant ADD   : std_logic_vector := "0000";
  constant SUB   : std_logic_vector := "0001";
  constant MUL   : std_logic_vector := "0010";
  constant DIV   : std_logic_vector := "0011";
  constant S_L   : std_logic_vector := "0100";
  constant S_R   : std_logic_vector := "0101";
  constant I_AND : std_logic_vector := "0110";
  constant I_OR  : std_logic_vector := "0111";  
  constant I_NOR : std_logic_vector := "1000";
  constant I_HI  : std_logic_vector := "1001";
  constant I_LO  : std_logic_vector := "1010";
  constant NOP_A : std_logic_vector := "1111";  -- in1をそのまま返す。
end alu_pack;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use work.alu_pack.all;

entity ALU is
  port (
    clk     : in std_logic;
    A, PC   : in  std_logic_vector(31 downto 0);  -- MuxA でどちらかを選択する。
    B       : in  std_logic_vector(31 downto 0);  -- BとImを符号拡張したもの、imを符号拡張して2bit左シフトしたもの、
    Im      : in  std_logic_vector(15 downto 0);  -- 定数の4をMuxBは選択する。
    control : in std_logic_vector(3 downto 0);  
    branch  : in std_logic;             -- branch命令であれば、計算結果はALUOutに書き込まない。
    MACtrl  : in STD_LOGIC;
    MBCtrl  : in std_logic_vector(1 downto 0);
    ANS,aluout : out std_logic_vector(31 downto 0);  
    condreg  : out std_logic_vector(2 downto 0) := "000");   -- 計算結果が"負零正"
end ALU;

architecture alu_core of ALU is
  signal in1, in2 : std_logic_vector(31 downto 0) := x"00000000";
  signal ExIm : std_logic_vector(31 downto 0);
  signal t : std_logic;
  signal ma : std_logic;
  signal tANS : std_logic_vector(31 downto 0);
  signal mANS : std_logic_vector(63 downto 0);
begin  -- alu_core

  -- purpose: Im の符号拡張
  Expand: process (Im)
  begin  -- process Expand
    if Im(15) = '0' then
      ExIm <= x"0000" & Im;
    else
      ExIm <= x"FFFF" & Im;
    end if;
  end process;

  MuxA: process (MACtrl, A, PC)
  begin  -- process
--    if rising_edge(clk) then
--      in1 <= A when MACtrl = '1' else PC;
      if MACtrl = '1' then
        in1 <= A;
      else
        in1 <= PC;
      end if;
--    end if;
  end process;

  MuxB: process (MBCtrl, B, ExIm)
  begin  -- process
--    if rising_edge(clk) then
      case MBCtrl is
        when "00" => in2 <= B;
        when "01" => in2 <= x"00000004";
        when "10" => in2 <= ExIm;
        when "11" => In2 <= ExIm(29 downto 0) & "00";
        when others => null;
      end case;
--    end if;
  end process;

  -- purpose: Out Bufferを操作
  -- branch命令でなければ、計算結果はALUoutに保存しない。(前のサイクルで計算しておいた値を使うため)
  OutControl: process (tANS, branch)
  begin  -- process OutCntrol
    ANS <= tANS;
    if branch = '1' then
      aluout <= tANS;
    end if;
    if tANS(31) ='0' then
      if tANS = x"00000000" then
        condreg <= "010";
      else
        condreg <= "001";
      end if;
    else
      condreg <= "100";
    end if;
  end process OutControl;
  
  calc: process (in1, in2, MACtrl, MBCtrl, clk)
  begin  -- process calc
--    if rising_edge(clk) then
      case control is
        when ADD   => tANS <= in1 + in2;
        when SUB   => tANS <= in1 - in2;
        when MUL   => mANS <= in1 * in2;
                              tANS <= mANS(31 downto 0);
        when S_L   => tANS <= to_stdLogicVector(to_bitVector(in1) sll CONV_INTEGER(in2));
        when S_R   => tANS <= to_stdLogicVector(to_bitVector(in1) srl CONV_INTEGER(in2));
        when I_AND => tANS <= in1 and in2;
        when I_OR  => tANS <= in1 or in2;
        when I_NOR => tANS <= in1 nor in2;
        when I_HI  => tANS <= in2(15 downto 0) & in1(15 downto 0);
        when I_LO  => tANS <= in1(31 downto 16)& in2(15 downto 0);
        when NOP_A => tANS <= in1;
        when others => tANS <= x"aaaaaaaa";
      end case;
--    end if;
  end process;
end alu_core;
