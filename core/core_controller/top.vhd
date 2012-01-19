library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  Port ( MCLK1 : in  STD_LOGIC;
         RS_RX : in  STD_LOGIC;
         RS_TX : out  STD_LOGIC);
end top;

architecture cpu of top is
  signal clk,iclk: std_logic;
  component core_controller
    port (
      clk : in  std_logic; 
      rx  : in  std_logic;
      tx  : out std_logic);
  end component;
begin
  ib: IBUFG port map (
    i=>MCLK1,
    o=>iclk);
  bg: BUFG port map (
    i=>iclk,
    o=>clk);
  cctrl : core_controller port map (
    clk => clk,
    rx  => RS_RX,
    tx  => RS_TX);
end cpu;
