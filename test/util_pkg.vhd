library ieee;
use ieee.std_logic_1164.all;

package util is
  function to_string(i_vec : std_logic_vector) return string;
  
  /* Returns the smallest number of bits needed to store the input as an
  unsigned integer in a std_logic_vector. */
  function min_bit_length(i_num : natural) return natural;

  function to_std_logic(i_val : boolean) return std_logic;

  function file_bit_size(i_file : string) return natural;
end package;

package body util is
  function to_string(i_vec : std_logic_vector) return string is
    variable acc : string(1024 downto 0);
    variable char : string(2 downto 0);
  begin
    for idx in i_vec'range loop
      char := std_logic'image(i_vec(idx));
      acc(idx) := char(1); 
    end loop;
    return acc(i_vec'range);
  end to_string;

  function min_bit_length(i_num : natural) return natural is
    variable max_int : natural := 1;
    variable bits : natural := 1;
  begin
    while i_num > max_int loop
      max_int := 2*(max_int+1)-1;
      bits := bits + 1;
    end loop;
    return bits;
  end;

  function to_std_logic(i_val : boolean) return std_logic is
    variable v_ret : std_logic;
  begin
    if i_val then
      v_ret := '1';
    else
      v_ret := '0';
    end if;
    return v_ret;
  end to_std_logic;

  function file_bit_size(i_file : string) return natural is
    type t_binary_file is file of character;
    file file_handle : t_binary_file;
    variable v_bit_size : natural;
    variable v_data : character;
  begin
    while not endfile(file_handle) loop
      read(file_handle, v_data);
      v_bit_size := v_bit_size + 1;
    end loop;
    return v_bit_size;
  end file_bit_size;
end util;
