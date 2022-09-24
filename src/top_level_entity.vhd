library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_entity is
  port(
    -- LEDG : out std_logic_vector(8 downto 0);
    -- KEY : in std_logic_vector(0 downto 0);
    i_clk : in std_logic;
    i_gpio1 : in std_logic_vector(7 downto 0);
    i_gpio2 : in std_logic_vector(7 downto 0);
    o_gpio : out std_logic_vector(7 downto 0));
  
end;

architecture rtl of top_level_entity is
  signal sys_clk : std_logic;
  signal r_i_gpio1 : std_logic_vector(7 downto 0) := (others => '0');
  signal r_i_gpio2 : std_logic_vector(7 downto 0) := (others => '0');
  signal r_o_gpio : std_logic_vector(7 downto 0) := (others => '0');
begin
  -- my_counter: entity work.counter
  --   port map(
  --     i_clk => KEY(0),
  --     o_counter => LEDG);

  o_gpio <= r_o_gpio;
  
  my_pll: entity work.pll
    port map(
      inclk0 => i_clk,
      c0 => sys_clk);

  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      r_i_gpio1 <= i_gpio1;
      r_i_gpio2 <= i_gpio2;
      r_o_gpio <= std_logic_vector(unsigned(r_i_gpio1) + unsigned(r_i_gpio2));
    end if;
  end process;
end;
