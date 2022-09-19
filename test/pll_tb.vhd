library ieee;
use ieee.std_logic_1164.all;

entity pll_tb is
end;

architecture sim of pll_tb is
  constant c_N : natural := 100;
  constant c_period : time := 40 ns; -- 25 MHz
  constant c_out_period : time := 16 ns; -- 62.5 MHz
  signal w_inclk : std_logic;
  signal w_outclk : std_logic;
begin
  dut: entity work.pll
    port map(
      inclk0 => w_inclk,
      c0 => w_outclk);

  process
  begin
    for i in 0 to c_N loop
      w_inclk <= '0';
      wait for c_period/2;
      w_inclk <= '1';
      wait for c_period/2;
    end loop;
    wait;
  end process;

  process
  begin
    wait until w_outclk = '1';
    wait for c_out_period/4;
    for i in 0 to 2*c_N loop
      assert w_outclk = '1';
      wait for c_out_period/2;
      assert w_outclk = '0';
      wait for c_out_period/2;
    end loop;
    wait;
  end process;
end;
