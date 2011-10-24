library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;

entity io_device is
  generic (
    wtime : std_logic_vector(15 downto 0) := x"1ADB");
  port (
    clk    : in  std_logic;
    RAMOut : in  std_logic_vector(31 downto 0);
    RegB   : in  std_logic_vector(31 downto 0);
    OBCtrl : in  std_logic;             --  out buffer 付属のMultiplexer
    set,get: in  std_logic;
    send,recv: in  std_logic;
    RX     : in  std_logic;
    TX     : out std_logic;
    busy   : out std_logic;
    got    : out std_logic;             -- getが立った後にget終了した場合に1を返す
    InData : out std_logic_vector(31 downto 0));

end io_device;

architecture io of io_device is
  type buffer_set is array (0 to 7) of std_logic_vector(31 downto 0);  -- 1 valid bit
  signal OutBuffer : buffer_set := (x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000");
  signal OutData : std_logic_vector(31 downto 0) := x"00000000";
  signal ocond, icond : std_logic_vector(2 downto 0) := "000";
  signal ofull : std_logic := '0';
  signal sendbuf : std_logic_vector(8 downto 0) := (others=>'1');
  signal state : std_logic_vector(3 downto 0) := "1111";
  signal r_state : std_logic_vector(3 downto 0) := "1111";
  signal recvbuf : std_logic_vector(7 downto 0) := (others=>'1');
  signal r_countdown : std_logic_vector(15 downto 0) := (others=>'0');
  signal r_wtime : std_logic_vector(15 downto 0) := x"1ADB";
begin  -- io

  set_out_buffer: process (set, OutData)
  begin  -- process set_out_buffer
    if ofull = '0' then
      if set = '1' then
        case ocond is
          when "111" => OutBuffer(7) <= OutData;
                        ofull <= '1';
          when "110" => OutBuffer(6) <= OutData;
                           ocond <= "111";
          when "101" => OutBuffer(5) <= OutData;
                           ocond <= "110";
          when "100" => OutBuffer(4) <= OutData;
                           ocond <= "101";
          when "011" => OutBuffer(3) <= OutData;
                           ocond <= "100";
          when "010" => OutBuffer(2) <= OutData;
                           ocond <= "011";
          when "001" => OutBuffer(1) <= OutData;
                           ocond <= "010";
          when "000" => OutBuffer(0) <= OutData;
                           ocond <= "001";
        end case;
      end if;
    end if;
  end process control_out_buffer;
  
  send: process (clk)
  begin  -- process recieve
      if rising_edge(clk) then
        case state is
          when "1011"=>
            if send='1' then
              sendbuf<=OutBuffer(0)&"0";
              state<=state-1;
              countdown<=wtime;
              OutBuffer(0) <= OutBuffer(1);
              OutBuffer(1) <= OutBuffer(2);
              OutBuffer(2) <= OutBuffer(3);
              OutBuffer(3) <= OutBuffer(4);
              OutBuffer(4) <= OutBuffer(5);
              OutBuffer(5) <= OutBuffer(6);
              OutBuffer(6) <= OutBuffer(7);
              OutBuffer(7) <= x"00000000";
              ofull <= '0';
              ocond <= ocond-1;
          when others=>
            if countdown=0 then
              sendbuf<="1"&sendbuf(8 downto 1);
              countdown<=wtime;
              state<=state-1;
            else
              countdown<=countdown-1;
            end if;
        end case;
      end if;
  end process recieve;
  tx <= sendbuf(0);
  busy <= '0' when state"1011" else '1';

  recieve: process (clk)
  begin  -- process recieve
    if rising_edge(clk) then
      case r_state is
        when "1111" =>                  --START BITを待つ
          got <= '0';       
          if RX = '0' then
            if get = '1' then
              r_state <= r_state-2;           --自分のノートに合わせた(
              r_countdown <= "0"&r_wtime(15 downto 1)+r_wtime;  --r_wtimeの1.5倍のclock待つ
            end if;
          end if;
        when "0101" =>
          r_state <= "1111";
          InData <= recvbuf(7 downto 1);
          get <= '0';
          got <= '1';                   --get完了線
        when others =>
          if r_countdown = 0 then
            recvbuf <= RX&recvbuf(7 downto 1);
            r_countdown <= r_wtime;
            r_state <= r_state-1;
          else
            r_countdown <= r_countdown-1;
          end if;
      end case;
    end if;
  end process recieve;

  Mux: process (RAMOut, RegB, OBCtrl)
  begin  -- process Mux
    if OBCtrl = '0' then
      OutData <= RAMOut;
    else
      OutData <= RegB;
    end if;
  end process Mux;

end io;
