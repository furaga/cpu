LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 
  
  COMPONENT top
    PORT(
      MCLK1 : IN  std_logic;
      RS_RX : in  std_logic;
      RS_TX : OUT  std_logic
      );
  END COMPONENT;
  
  signal MCLK1 : std_logic := '0';
  signal RS_RX : std_logic := '1';
  signal RS_TX : std_logic;
BEGIN
  
  uut: top PORT MAP ( 
  MCLK1 => MCLK1, 
  RS_RX => RS_RX,
  RS_TX => RS_TX);
  
  clkgen: process
  begin
    mclk1<='0';
    wait for 1 ns;
    mclk1<='1';
    wait for 1 ns;
  end process;
END;
