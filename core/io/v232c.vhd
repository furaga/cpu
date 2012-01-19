library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity V232c is
  generic (wtime : std_logic_vector(15 downto 0) := x"1ADB");
  port (
    clk  : in  std_logic;
    rx   : in  std_logic;
    data : out std_logic_vector(7 downto 0));
end V232c;

architecture whitebox of v232c is
  signal countdown : std_logic_vector(15 downto 0) := (others=>'0');
  signal state : std_logic_vector(3 downto 0) := "1111";
  signal data0 : std_logic_vector(7 downto 0) := x"FF";
begin  -- whitebox
  
  recv: process (clk)
  begin  -- process recv
    if rising_edge(clk) then
      case state is
        when "1111" => 
          if rx='0' then
            state <= state-2;
            countdown <= wtime + "0"&wtime(15 downto 0);
          end if;
        when "0101" =>
          state <= "1111";
          data <= data0;
        when others =>
          if countdown = 0 then
            data0 <= rx&data0(7 downto 1);
            countdown <= wtime;
            state <= state-1;
          else
            countdown <= countdown-1;
          end if;
      end case;
    end if;
  end process recv;

end whitebox;
