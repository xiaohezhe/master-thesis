--**********************************************************************************************************************
--this code is to feed the abs_substract value into a filter(it is composed of 7/8 previous data and 1/8 new data)
--to lowpassed the abs_substract(make it change slowly)
--**********************************************************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.dptc_util_pkg.all;

entity guarded_filter is
generic (
  data_bits                  : integer := 16;
  filter_coefficient         : integer :=3;
  data_bits_add 	     : integer :=19);--rigth shift bits for
port (
  -- input
  enable		     : in std_logic;
  i_clk                      : in  std_logic;
  i_data		     : in  std_logic_vector(data_bits_add-1 downto 0);--abs_subtract data
 
  -- output
  filter_data                : out std_logic_vector(data_bits_add-1 downto 0);
  number_bits		     : out std_logic_vector(7 downto 0));
end guarded_filter;

architecture behavior of guarded_filter is

--extra bits to keep the data length after right shift
signal zero_pad		     : std_logic_vector(filter_coefficient-1 downto 0):=(others => '0');
--to save the filter output data
signal filterdata_reg	     :std_logic_vector(data_bits_add-1 downto 0):=(others => '0');
--to save the previous data's filter output and use it to compare with the new data
signal prev_filterdata_reg   :std_logic_vector(data_bits_add-1 downto 0):=(others => '0');
signal counter: std_logic_vector(1 downto 0):=(others => '0');
signal number_bits_reg: integer:=0;

begin



filter_process : process(i_clk)
begin 
	if(rising_edge(i_clk)) then
	  if (enable='1') then
		if (unsigned(i_data(i_data'left downto filter_coefficient))>=unsigned(prev_filterdata_reg) and (unsigned(prev_filterdata_reg)>0)) then
			counter <= counter + "01";
			if((counter<"11")) then
				filterdata_reg <= prev_filterdata_reg;
			else
				--2*pre_data
				filterdata_reg <= std_logic_vector(unsigned(prev_filterdata_reg(prev_filterdata_reg'length-1-1 downto 0)&"0"));
				counter <= "00";
			end if;
		
		elsif (unsigned(prev_filterdata_reg)>0) then
			filterdata_reg <= std_logic_vector(unsigned(prev_filterdata_reg) - unsigned(zero_pad&prev_filterdata_reg(prev_filterdata_reg'left downto filter_coefficient)) + unsigned(zero_pad&i_data(i_data'left downto filter_coefficient)));
			if(counter > 0) then
			counter <= counter-"01";
			end if;
		else	
		filterdata_reg <=i_data;
		end if;
	  else
		filterdata_reg <=prev_filterdata_reg;
	end if;
	end if;
end process filter_process;
--previous data's filter output is used for the input of the new data, at the same time, ouput it

filter_data <= filterdata_reg;
prev_filterdata_reg <=filterdata_reg;

number_bits_reg <= dptc_log2(to_integer(signed(filterdata_reg))) when filterdata_reg >0 else
		0;

number_bits <= std_logic_vector(to_unsigned(number_bits_reg,number_bits'length));

end behavior;
