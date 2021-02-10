library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--get the data's previous group average value and next group average value
entity previous_average_and_next_average is
generic (
  data_bits                 : integer := 16;
  group_length              : integer := 2 );
port (
	  i_clk                      : in  std_logic;
  	  i_data                     : in  std_logic_vector(data_bits-1 downto 0);
	  o_data_average	     : out std_logic_vector(data_bits-1 downto 0);
	  o_data_subtract	     : out std_logic_vector(data_bits-1 downto 0);
	  o_data_fraction	     : out std_logic_vector(group_length downto 0)
	);
end previous_average_and_next_average;

architecture arc_previous_average_and_next_average of previous_average_and_next_average is
signal oldest_data_reg_vector:std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal oldest_data_reg_signed: signed(data_bits-1 downto 0):=(others=>'0');


signal oldest_data_pre: std_logic_vector(data_bits-1 downto 0):=(others=>'0');

--sum value of previous group and next group
signal o_data_next_reg: std_logic_vector(data_bits+group_length downto 0):=(others=>'0');
signal o_data_previous_reg: std_logic_vector(data_bits+group_length downto 0):=(others=>'0');


signal sum_reg: signed(data_bits+group_length downto 0):=(others => '0');
signal average_reg: signed(data_bits-1 downto 0):=(others=>'0');--9 bits
signal subtract_reg:signed(data_bits-1 downto 0):=(others => '0');
signal fraction_reg: signed(group_length downto 0):=(others => '0');

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


oldest_data_reg_signed <= signed(oldest_data_reg_vector);


sum_reg <= signed(o_data_previous_reg)+signed(o_data_next_reg);
o_data_average <= std_logic_vector(sum_reg(data_bits+group_length downto (group_length+1)));
o_data_subtract <=std_logic_vector(signed(oldest_data_reg_signed-signed(sum_reg(data_bits+group_length downto (group_length+1)))));
o_data_fraction<=std_logic_vector(sum_reg(group_length downto 0));

end arc_previous_average_and_next_average;
