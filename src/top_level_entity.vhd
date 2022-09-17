library ieee;
use ieee.std_logic_1164.all;

entity top_level_entity is
  port(
    LEDG : out std_logic_vector(8 downto 0);
    KEY : in std_logic_vector(0 downto 0));
  
end;

architecture rtl of top_level_entity is
begin
  my_counter: entity work.counter
    port map(
      i_clk => KEY(0),
      o_counter => LEDG);
end;
