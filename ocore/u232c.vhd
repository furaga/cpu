library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity u232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
  Port ( clk  : in  std_logic;
		 send_data : in  std_logic_vector (7 downto 0);
		 send_go   : in  std_logic;
		 send_busy : out std_logic;
		 tx   : out std_logic;
		 recv_data : out std_logic_vector (7 downto 0);
		 recv_busy : out std_logic;
		 rx   : in std_logic
		);


end u232c;

architecture blackbox of u232c is
  signal send_timer : std_logic_vector(15 downto 0) := (others=>'0');
  signal sendbuf: std_logic_vector(8 downto 0) := (others=>'1');
  signal send_state: std_logic_vector(3 downto 0) := "1011";

  signal recv_timer : std_logic_vector(15 downto 0) := (others=>'0');
  signal recvbuf: std_logic_vector(8 downto 0) := (others=>'0');
  signal recv_state: std_logic_vector(3 downto 0) := "1111";
begin

  send : process(clk)
  begin
    if rising_edge(clk) then
      case send_state is
        when "1011"=>
          if send_go='1' then
            sendbuf<=send_data&"0";
            send_state<=send_state-1;
            send_timer <=wtime;
          end if;
        when others=>
          if send_timer =0 then
            sendbuf<="1"&sendbuf(8 downto 1);
            send_timer <=wtime;
            send_state<=send_state-1;
          else
            send_timer <=send_timer -1;
          end if;
      end case;
    end if;
  end process;
  tx<=sendbuf(0);
  send_busy<= '0' when send_state="1011" else '1';

  recv : process(clk)
  begin
    if rising_edge(clk) then
      case recv_state is
        when "1111"=>
			recv_data<= recvbuf(7 downto 0); -- ignore stop bit
			recv_state<="1001";
        when "1001"=>
			if rx = '0' then -- start bit
				recv_state<=recv_state-1;
				recv_timer <=wtime;
			end if;
        when others=>
          if recv_timer=0 then
            recvbuf <= rx&recvbuf(8 downto 1);
            recv_timer<=wtime;
            recv_state<=recv_state-1;
          else
            recv_timer<=recv_timer -1;
          end if;
      end case;
    end if;
  end process;
  recv_busy<= '0' when recv_state = "1001" else '1';


end blackbox;





