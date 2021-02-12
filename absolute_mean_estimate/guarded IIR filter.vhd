--**********************************************************************************************************************
--this code is to feed the abs_substract value into a filter(it is composed of 7/8 previous data and 1/8 new data)
--to lowpassed the abs_substract(make it change slowly)
--**********************************************************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity guarded_filter is
generic (
  filter_coefficient         : integer :=3;--rigth shift bits for
  data_bits                  : integer := 19);--same as the abs_subtract data length
port (
  -- input
  i_clk                      : in  std_logic;
  i_data		     : in  std_logic_vector(data_bits-1 downto 0);--abs_subtract data
 
  -- output
  filter_data                : out std_logic_vector(data_bits-1 downto 0));
end guarded_filter;

architecture behavior of guarded_filter is

--extra bits to keep the data length after right shift
signal zero_pad		     : std_logic_vector(filter_coefficient-1 downto 0):=(others => '0');
--to save the filter output data
signal filterdata_reg	     :std_logic_vector(data_bits-1 downto 0):=(others => '0');
--to save the previous data's filter output and use it to compare with the new data
signal prev_filterdata_reg   :std_logic_vector(data_bits-1 downto 0):=(others => '0');

begin



filter_process : process(i_clk)
begin 
--a protection to see if abs_subtract data is larger than 8 time of the previous filter output data
--do not feed the very large abs_subtract data feeded into filter
 if(rising_edge(i_clk)) then
	if (unsigned(i_data(i_data'left downto filter_coefficient))>=unsigned(prev_filterdata_reg) and (unsigned(prev_filterdata_reg)>0)) then
		filterdata_reg <= prev_filterdata_reg;
--after feeding into filter, get the output data: pre_data-1/8*pre_data+1/8*i_data
	elsif (unsigned(prev_filterdata_reg)>0) then
		filterdata_reg <= std_logic_vector(unsigned(prev_filterdata_reg) - unsigned(zero_pad&prev_filterdata_reg(prev_filterdata_reg'left downto filter_coefficient)) + unsigned(zero_pad&i_data(i_data'left downto filter_coefficient))); 
	else
--when the prev_filterdata_reg is 0, the first data directly output
		filterdata_reg <= i_data;
	end if;
 end if;

end process filter_process;
--previous data's filter output is used for the input of the new data, at the same time, ouput it
filter_data <= filterdata_reg;
prev_filterdata_reg <=filterdata_reg;
end behavior;
