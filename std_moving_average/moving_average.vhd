library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity moving_average is
generic (
  data_bits                  : integer := 8;
  group_length               : integer := 2 );
port (
  i_clk                      : in  std_logic;
  -- input
  i_data                     : in  std_logic_vector(data_bits-1 downto 0);
  -- output
  --output the sum of group value
  o_data                     : out std_logic_vector(data_bits+group_length downto 0);
  oldest_data		     : out std_logic_vector(data_bits-1 downto 0));
end moving_average;

architecture rtl of moving_average is

type t_moving_average is array (0 to 2**group_length-1) of signed(data_bits-1 downto 0);

signal p_moving_average                 : t_moving_average:= (others => (others => '0'));
--adding group length bits,average accumulator, later divided by (group_length*2) totally
--e.g. 4 value a group, at last divided by 8 to get average value(4 for previous group, 4 for next group)
signal r_acc                            : signed(data_bits+group_length downto 0):=(others => '0');  
signal output_oldest_data		: signed(data_bits-1 downto 0):=(others => '0');

begin

p_average : process(i_clk)
begin
 if(rising_edge(i_clk)) then
    p_moving_average   <= signed(i_data)&p_moving_average(0 to p_moving_average'length-2);
    r_acc              <= r_acc + signed(i_data)-p_moving_average(p_moving_average'length-1);--add new data and subtract the oldest data
    output_oldest_data <= p_moving_average(p_moving_average'length-1);
  end if;
end process p_average;

  --o_data             <= std_logic_vector(r_acc(data_bits+group_length-1 downto group_length));  -- divide by 2^group_length
  oldest_data	     <= std_logic_vector(output_oldest_data);
  o_data             <= std_logic_vector(r_acc);
end rtl;
