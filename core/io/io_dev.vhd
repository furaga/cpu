-------------------------------------------------------------------------------
-- get : 立った時点で、データを受け取り始めます。
-- send: そのときにoutdataに入っているデータを送ります。ばっふぁは無し
-- sbusy: データを送っている間に立つ。
-- rbusy: データをUSBから受け取っている間に立つ。
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;

entity io_device is
  port (
    clk    : in  std_logic;
    RAMOut : in  std_logic_vector(31 downto 0);
    RegA   : in  std_logic_vector(31 downto 0);
    get    : in  std_logic;             -- これが立った時から受け取る
    send   : in  std_logic;             -- これが立った時のoutdataを送る
    RX     : in  std_logic;
    sbusy  : out std_logic;
    rbusy  : out std_logic;
    TX     : out std_logic;
    OutData: out std_logic_vector(7 downto 0);  -- 出力中のデータ（確認用
    InData : out std_logic_vector(31 downto 0));
end io_device;

architecture io of io_device is
  component u232c
    generic (wtime : std_logic_vector(15 downto 0) := x"1ADB");
    port ( clk  : in  std_logic;
           data : in  std_logic_vector(7 downto 0);
           go   : in  std_logic;
           busy : out std_logic;
           tx   : out std_logic);
  end component;
  component v232c
    generic (wtime : std_logic_vector(15 downto 0) := x"1ADB");
    port (
      clk  : in  std_logic;
      rx   : in  std_logic;
      data : out std_logic_vector(7 downto 0));
  end component;

  signal send_data : std_logic_vector(7 downto 0) := x"00";
  signal recv_data : std_logic_vector(7 downto 0) := x"00";
  signal rbusy0,sbusy0 : std_logic := '0';
  signal go : std_logic := '0';
  signal p,p1 : std_logic := '0';

begin
  send_rs232c : u232c generic map (wtime => x"1ADB")
    port map (
    clk  => clk,
    data => send_data,
    go   => go,
    busy => sbusy0,
    tx   => TX);
  recv_rs232c : v232c generic map (wtime => x"1ADB")
    port map (
    clk  => clk,
    rx   => rx,
    data => recv_data);

  rbusy <= rbusy0;
  sbusy <= sbusy0;


  send_msg: process (clk)
  begin  -- process snd
    if rising_edge(clk) then
      if send = '1' and sbusy0='0' and go='0' then
        go <= '1';
        OutData <= send_data;
      else
        go <= '0';
      end if;
    end if;
  end process send_msg;

  recv_msg: process (clk)
  begin  -- process recv_msg
    if rbusy0='0' and get= '1'then
      rbusy0 <= '1';
      p1<=p;                            -- そのときのpの値を記録
    else
      if p1/=p then                     -- pが変われば、新しくデータを受け取ったことになる
        rbusy0 <= '0';
      end if;
    end if;
  end process recv_msg;

  change_rd: process (recv_data)
  begin  -- process change_rd
      InData <= x"000000"&recv_data;
      if p = '0' then
        p <= '1';
      else
        p <= '0';
      end if;
  end process change_rd;

  send_data <= RegA(7 downto 0);

end io;
