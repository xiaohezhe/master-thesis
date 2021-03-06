library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity guarded_filter is
generic (
  filter_coefficient         : integer :=3;
  data_bits                  : integer := 19);
port (
  -- input
  i_data		     : in  std_logic_vector(data_bits-1 downto 0);--from abs_subtract data
  prev_data		     : in  std_logic_vector(data_bits-1 downto 0);--from the last filter output data
  -- output
  filter_data                : out std_logic_vector(data_bits-1 downto 0));
end guarded_filter;

architecture behavior of guarded_filter is

signal zero_pad		     : std_logic_vector(filter_coefficient-1 downto 0):=(others => '0');

begin



filter_process : process(i_data)
begin 
--abs_subtract data is larger than 8 time of the last filter output data
--do not feed the very large abs_subtract data feeded into filter
	if (unsigned(i_data(i_data'left downto filter_coefficient))>=unsigned(prev_data) and (unsigned(prev_data)>0)) then
		filter_data <= prev_data;
--after feeding into filter, get the output data: pre_data-1/8*pre_data+1/8*i_data
	elsif (unsigned(prev_data)>0) then
		filter_data <= std_logic_vector(unsigned(prev_data) - unsigned(zero_pad&prev_data(prev_data'left downto filter_coefficient)) + unsigned(zero_pad&i_data(i_data'left downto filter_coefficient))); 
	else
		filter_data <= i_data;
	end if;
 
end process filter_process;
end behavior;
