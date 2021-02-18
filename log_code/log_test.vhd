library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.dptc_util_pkg.all;


entity log_test is
end log_test;


architecture behavior of log_test is

component log_top is
port (
  -- input 
  i_data		     : in std_logic_vector(19 downto 0);
 
  -- output
  number_bits		     : out std_logic_vector(7 downto 0));

end component log_top;

signal i_data_tb: std_logic_vector(19 downto 0):=(others=>'0');
signal number_bits_tb: std_logic_vector(7 downto 0):=(others=>'0');


begin
log_top_component:

	component log_top

	port map(

			i_data=>i_data_tb,
			number_bits=>number_bits_tb

);

test_process: process is
begin

wait for 13 ns;
i_data_tb <=x"0003F";
wait for 10 ns;
i_data_tb <=x"00000";
wait for 10 ns;
i_data_tb <=x"00001";
wait for 10 ns;
i_data_tb <=x"00002";
wait for 10 ns;
i_data_tb <=x"00003";
wait for 10 ns;
i_data_tb <=x"00040";
wait for 10 ns;
i_data_tb <=x"00041";
wait for 10 ns;
i_data_tb <=x"00042";
wait for 10 ns;
i_data_tb <=x"00043";
wait for 10 ns;
i_data_tb <=x"00045";
wait for 10 ns;
i_data_tb <=x"00046";
wait for 10 ns;
i_data_tb <=x"00047";
wait for 10 ns;
i_data_tb <=x"00048";
wait for 10 ns;
i_data_tb <=x"00049";
wait for 10 ns;
i_data_tb <=x"0004A";
wait for 10 ns;
i_data_tb <=x"00020";
wait for 10 ns;
i_data_tb <=x"0007F";
wait for 10 ns;
i_data_tb <=x"00080";
wait for 10 ns;
i_data_tb <=x"00081";
wait for 10 ns;
i_data_tb <=x"00082";
end process test_process;
end  behavior;


