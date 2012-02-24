library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity u232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
  Port ( clk  : in  std_logic;
		 send_data : in  std_logic_vector (7 downto 0);
		 send_go   : in  std_logic;
		 send_busy : out std_logic;
		 tx   : out std_logic;
		 recv_data : out std_logic_vector (7 downto 0);
		 recv_ready : out std_logic;
		 rx   : in std_logic
		);


end u232c;

architecture blackbox of u232c is
  signal send_timer : std_logic_vector(15 downto 0) := (others=>'0');
  signal sendbuf: std_logic_vector(8 downto 0) := (others=>'1');
  signal send_state: std_logic_vector(3 downto 0) := "1011";

  signal recv_timer : std_logic_vector(15 downto 0) := (others=>'0');
  signal recvbuf: std_logic_vector(8 downto 0) := (others=>'0');
  signal recv_state: std_logic_vector(3 downto 0) := x"9";
  signal rxsample : std_logic_vector(4 downto 0) := (others=>'1');
  signal rx_in : std_logic;
begin

  send : process(clk)
  begin
    if rising_edge(clk) then
      case send_state is
        when "1011"=> -- 11: wait
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
		rxsample <= rx&rxsample(4 downto 1);
      case recv_state is
        when x"f"=> -- recv_data set
			recv_data<= recvbuf(7 downto 0);
			recv_state <= recv_state-1;
			--if rx_in='1' then -- rx should be '1' (stop bit)
			--else
				--recv_data<= x"ff";
			--end if;
		when x"e"=>
			if rx_in='0' then 
				recv_state<="1001";
			end if;
        when x"9"=> -- 9 wait start bit
			if rx_in='0' then -- start bit
				recv_state<=recv_state-1;
				recv_timer <= wtime + 0;
			end if;
        when others=> -- 8 - 0
			if recv_timer=0 then
				recvbuf <= rx_in&recvbuf(8 downto 1);
				recv_timer<=wtime;
				recv_state<=recv_state-1;
			else
				recv_timer<=recv_timer -1;
			end if;
      end case;
    end if;
  end process;
  rx_in <= rxsample(4) when rxsample(4)=rxsample(3) else
  		   '1' when rxsample(2 downto 0)="111" or 
		   			rxsample(2 downto 0)="110" or 
		   			rxsample(2 downto 0)="101" or 
		   			rxsample(2 downto 0)="011" else
			'0';
  		


	assert_ready : process(clk)
	begin
		if rising_edge(clk) then
			case recv_state is
				when x"f" =>
					recv_ready <= '1';
				when others =>
					recv_ready <= '0';
			end case;
		end if;
	end process;


end blackbox;


