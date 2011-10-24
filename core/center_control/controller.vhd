-- Tue Oct 18 16 16:54:26 2011

library IEEE;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_1164.all

entity output_controller is
    port (
      opcode      : in  std_logic_vector;  --命令の上位6bit
      RegDst      : out std_logic;      -- 1 : R形式、0 : I形式
      RegWrite    : out std_logic;      -- 1 : レジスタへの書き込みがある(J形式では、無い)
      ALUSrcA     : out std_logic;      -- ALU の 1st オペランドは
                                        -- 1 : Register A、 0 : PC
      ALUSrcB     : out std_logic_vector(1 downto 0);  -- ALU の 2nd オペランドは
                                                       -- 00 Register B,  01 x"00000004" (PC への加算に使う)
                                                       -- 10 I命令である, 11 immidiate を符号拡張して、2bit右シフトしたもの
      ALUop       : out std_logic_vector(1 downto 0);  -- 00 : add,  01 : sub, 10 : functを読む
      PCSource    : out std_logic_vector(1 downto 0);  -- 00 ALUの出力(PC+4)をPCへ送る
                                                       -- 01 分岐命令,ALUoutをPCへ送る
                                                       -- 10 意味不明、だれか教えて（パタヘネ
      IRWrite     : out std_logic;      -- メモリのデータを命令レジスタに書きこむ
      MemtoReg    : out std_logic;      -- 1 : メモリ・データ・レジスタの値がレジスタに書き込まれる（ld命令等で使う
                                        -- 0 : ALUOutがレジスタに書き込まれる
      MemWrite    : out std_logic;      -- 書きこみデータの値がアドレスの内容に書き込まれる
      IorD        : out std_logic;      -- 0 : メモリの読み込みアドレスがPCの値
                                        -- 1 : メモリの読み込みアドレスがALUOut
      PCWrite     : out std_logic;      -- 1 : PCにPCSourceで選ばれた値を書き込む
      PCWriteCond : out std_logic);
end output_controller;  
