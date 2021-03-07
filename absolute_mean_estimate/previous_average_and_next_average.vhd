--******************************************************************************************
-- this code is to get the absolute mean estimate,
-- but it is 2*(2**group_length) time the difference of data and average value
-- to not throw away the low bits when right shift so that ensure accuracy
-- users should notice it
--*******************************************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.dptc_util_pkg.all;


--get the data's previous group average value and next group average value
entity previous_average_and_next_average is
generic (
  data_bits                 : integer := 16;
  group_length              : integer := 2 );
port (
	--input
	  i_clk                      : in  std_logic;
  	  i_data                     : in  std_logic_vector(data_bits-1 downto 0);
	--output
	  o_data_subtract	     : out std_logic_vector(data_bits+group_length+1-1 downto 0);--add group length bits because middle data left shifted
	  o_data_abs_subtract	     : out std_logic_vector(data_bits+group_length+1-1 downto 0);
	  o_filter_data		     : out std_logic_vector(data_bits+group_length+1-1 downto 0);
	  o_number_bits		     : out std_logic_vector(7 downto 0);
	  o_counter_data	     : out std_logic_vector(15 downto 0)
	);
end previous_average_and_next_average;

architecture arc_previous_average_and_next_average of previous_average_and_next_average is
signal oldest_data_reg_vector:std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal oldest_data_reg_signed: signed(data_bits-1 downto 0):=(others=>'0');
signal o_data_shiftedleft: signed(data_bits+group_length+1-1 downto 0):=(others=>'0');--

signal oldest_data_pre: std_logic_vector(data_bits-1 downto 0):=(others=>'0');

--sum value of previous group and next group
signal o_data_next_reg: std_logic_vector(data_bits+group_length downto 0):=(others=>'0');
signal o_data_previous_reg: std_logic_vector(data_bits+group_length downto 0):=(others=>'0');


signal sum_reg: signed(data_bits+group_length+1-1 downto 0):=(others => '0');
signal subtract_reg: signed(data_bits+group_length+1-1 downto 0):=(others => '0');
signal abs_subtract_reg: std_logic_vector(data_bits+group_length+1-1 downto 0):=(others => '0');
signal counter_data:std_logic_vector(15 downto 0):=(others => '0');
signal counter_data_flag: std_logic:='0';


component moving_average
generic (
  data_bits                  : integer := 16;
  group_length               : integer := 2 );
port (
  i_clk                      : in  std_logic;
  -- input
  i_data                     : in  std_logic_vector(data_bits-1 downto 0);
  -- output
  o_data                     : out std_logic_vector(data_bits+group_length downto 0);
  oldest_data		     : out std_logic_vector(data_bits-1 downto 0));
end component moving_average;


component guarded_filter
generic (
  filter_coefficient         : integer :=3;
  data_bits                  : integer := 19);
port (
  -- input
  i_clk                      : in  std_logic;
  i_data		     : in  std_logic_vector(data_bits-1 downto 0);--abs_subtract data
 
  -- output
  filter_data                : out std_logic_vector(data_bits-1 downto 0);
  number_bits		     : out std_logic_vector(7 downto 0));
end component guarded_filter;



begin 
moving_average_comp: moving_average
port map(
		i_clk =>i_clk,
		i_data => i_data,
		o_data => o_data_next_reg,
		oldest_data =>oldest_data_reg_vector
	);

moving_average_comp_pre: moving_average
port map(
		i_clk =>i_clk,
		i_data => oldest_data_reg_vector,
		o_data => o_data_previous_reg,
		oldest_data =>oldest_data_pre
	);


guarded_filter_comp_pre: guarded_filter
port map(
		i_clk => i_clk,
		i_data =>abs_subtract_reg,
	 	filter_data=>o_filter_data,
		number_bits=>o_number_bits
);


oldest_data_reg_signed <= signed(oldest_data_reg_vector);

--add two group sum together
sum_reg <= signed(o_data_previous_reg)+signed(o_data_next_reg);

--middle data left shifts group length to aviod when geting average without low bits
o_data_shiftedleft(group_length+1-1 downto 0)<=(others=>'0');

o_data_shiftedleft(o_data_shiftedleft'left downto group_length+1)<= oldest_data_reg_signed;

--to delete at begining not accurate 9 data sampling subtract 
--used middle data * group number*2 -  sum value
subtract_reg <=signed(o_data_shiftedleft)-signed(sum_reg) when counter_data_flag='1' else
	       (others => '0');
o_data_subtract <=std_logic_vector(subtract_reg) when counter_data_flag='1' else
	       (others => '0');

--get the abs value for subtract value and feed into IIR FILTER
abs_subtract_reg <=std_logic_vector(abs(subtract_reg)) when counter_data_flag='1' else
	       (others => '0');
o_data_abs_subtract<=abs_subtract_reg when counter_data_flag='1' else
	       (others => '0');

    counter_data_pro:process(i_clk)
    begin
	if (rising_edge(i_clk)) then
		if(counter_data = x"FFFF") then
			counter_data <=x"0000";
		else
			counter_data <= counter_data+x"0001";
		end if;
--from counter =10, the counter_data_flag will be always equal 1 and calculate the abs_subtract
		if (counter_data >x"0009") then
			counter_data_flag <='1';
		end if;
	end if;
	end process counter_data_pro;
o_counter_data <=counter_data;


end arc_previous_average_and_next_average;
