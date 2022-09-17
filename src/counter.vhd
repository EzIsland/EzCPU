library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity counter is
  port(
    i_clk : in std_logic;
    o_counter : out std_logic_vector(8 downto 0));
end;

architecture rtl of counter is
  signal r_counter : std_logic_vector(8 downto 0) := (others => '0');
begin
  process (i_clk)
  begin
    if rising_edge(i_clk) then
      r_counter(0) <= not r_counter(0);
      for idx in 1 to 8 loop
        r_counter(idx) <= and_reduce(r_counter(idx-1 downto 0)) xor r_counter(idx);
      end loop;
    end if;
  end process;
  o_counter <= r_counter;
end;
