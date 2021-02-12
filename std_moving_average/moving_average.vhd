--*********************************************************************
--this code is to calculate group value' sum and get the oldest data
--e.g. 12345, output sum of 2345 and oldest value 1
--*********************************************************************


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity moving_average is
generic (
  data_bits                  : integer := 16;
  group_length               : integer := 2 );
port (
  i_clk                      : in  std_logic;
  -- input
  i_data                     : in  std_logic_vector(data_bits-1 downto 0);

  -- output
  --output o_data is the sum of group value, oldest_data
  o_data                     : out std_logic_vector(data_bits+group_length downto 0);
  oldest_data		     : out std_logic_vector(data_bits-1 downto 0));
end moving_average;

architecture rtl of moving_average is

type t_moving_average is array (0 to 2**group_length-1) of signed(data_bits-1 downto 0);

signal p_moving_average                 : t_moving_average:= (others => (others => '0'));


signal r_acc                            : signed(data_bits+group_length downto 0):=(others => '0');  
signal output_oldest_data		: signed(data_bits-1 downto 0):=(others => '0');

begin

p_average : process(i_clk)
begin
 if(rising_edge(i_clk)) then
--add new data and subtract the oldest data to get sum of new group value
    p_moving_average   <= signed(i_data)&p_moving_average(0 to p_moving_average'length-2);
    r_acc              <= r_acc + signed(i_data)-p_moving_average(p_moving_average'length-1);    
    output_oldest_data <= p_moving_average(p_moving_average'length-1);
  end if;
end process p_average;
  oldest_data	     <= std_logic_vector(output_oldest_data);
  o_data             <= std_logic_vector(r_acc);
end rtl;
