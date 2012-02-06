library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity fetch is
port (
CLK_FT	:	in	std_logic;
P_COUNT	:	in	std_logic_vector (7 downto 0);
PROM_OUT	:	out	std_logic_vector (14 downto 0)
);
end fetch;
architecture BEHAVIOR of fetch is

subtype WORD is std_logic_vector (14 downto 0);
type MEMORY is array (0 to 15) of WORD;
constant MEM : MEMORY := (

"100000000000000",	-- 00: ldl	Reg0	0
"100000100000001",	-- 01: ldl	Reg1	1
"100001000000000",	-- 02: ldl	Reg2	0
"100001100001010",	-- 03: ldl	Reg3	10
"000101000100000",	-- 04: add	Reg2	Reg1
"000100001000000",	-- 05: add	Reg0	Reg2
"101001001100000",	-- 06: cmp	Reg2	Reg3
"101100000001001",	-- 07: je	9
"110000000000100",	-- 08: jmp	4
"111000001000000",	-- 09: st	Reg0	64
"111100000000000",	-- 10: hlt
"000000000000000",	-- 11: nop
"000000000000000",	-- 12: nop
"000000000000000",	-- 13: nop
"000000000000000",	-- 14: nop
"000000000000000"	-- 15: nop
 );
begin
READ_OP:
process(CLK_FT)
begin
if (CLK_FT'event and CLK_FT = '1') then
PROM_OUT <= MEM(conv_integer(P_COUNT(7 downto 0)));
end if;
end process;
end BEHAVIOR;
