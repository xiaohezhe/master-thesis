library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.dptc_util_pkg.all;


entity log_top is
                
port (
  -- input 
  i_data		     : in std_logic_vector(19 downto 0);
 
  -- output
  number_bits		     : out std_logic_vector(7 downto 0));

end log_top;

architecture behavior of log_top is

signal number_bits_reg: integer:=0;

begin

number_bits_reg <= dptc_log2(to_integer(signed(i_data))) when i_data >0 else
		0;
number_bits <= std_logic_vector(to_unsigned(number_bits_reg,number_bits'length));


end behavior;