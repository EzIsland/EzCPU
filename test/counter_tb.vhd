library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.util.all;

entity Counter_tb is
end;

architecture sim of Counter_tb is
  constant c_period : time := 4 ns;
  constant c_N : natural := 9;
  signal w_clk : std_logic;
  signal w_counter : std_logic_vector(c_N-1 downto 0);
begin
  dut: entity work.counter
    port map(
      i_clk => w_clk,
      o_counter => w_counter);

  process
  begin
   for i in 0 to 2**(c_N+1) loop
      w_clk <= '0'; wait for c_period/2;
      w_clk <= '1'; wait for c_period/2;
   end loop;
   wait;
  end process;

  process
    variable v_expected : std_logic_vector(c_N-1 downto 0);
  begin
    wait for c_period/4;
    for i in 0 to 2**c_N-1 loop
      v_expected := std_logic_vector(to_unsigned(i, c_N));
      assert w_counter = v_expected
        report "Expected value " & to_string(v_expected)
        & ". Found value " & to_string(w_counter) & ".";
      wait for c_period;
    end loop;
    wait;
  end process;
end;
