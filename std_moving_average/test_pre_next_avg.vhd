library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_pre_next_avg is
end test_pre_next_avg;

architecture behavior of test_pre_next_avg is


component previous_average_and_next_average is
generic (
  data_bits                     : integer := 8;
  group_length              : integer := 2 );
port (
	  i_clk                      : in  std_logic;
  	  i_data                     : in  std_logic_vector(data_bits-1 downto 0);
          o_data_next                : out std_logic_vector(data_bits-1 downto 0);--average data for next group
          o_data_previous	     : out std_logic_vector(data_bits-1 downto 0);--average data for previous group
	  o_data_average	     : out std_logic_vector(data_bits-1 downto 0);--average of previous and next average
	  o_data_subtract	     : out std_logic_vector(data_bits-1 downto 0)-- middle data - average
	);
end component previous_average_and_next_average;

constant data_bits: integer := 8;
signal  i_clk_tb:  std_logic:='0';
signal  i_data_tb: std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal  o_data_next_tb: std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal  o_data_previous_tb: std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal  o_data_average_tb: std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal  o_data_subtract_tb: std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal runsim : boolean := true;


begin
previous_average_and_next_average_component:

	component previous_average_and_next_average 

	port map(
			i_clk =>i_clk_tb,
			i_data=>i_data_tb,
			o_data_next=>o_data_next_tb,
			o_data_previous=>o_data_previous_tb,
			o_data_average => o_data_average_tb,
			o_data_subtract => o_data_subtract_tb
);

    process
    begin
        if runsim then
            i_clk_tb <= '1';
            wait for 5 ns;
            i_clk_tb <= '0';
            wait for 5 ns;
        else
            wait;
        end if;
    end process;


test_process: process is
begin

wait for 12 ns;
i_data_tb <=x"01";
wait for 10 ns;
i_data_tb <=x"02";
wait for 10 ns;
i_data_tb <=x"03";
wait for 10 ns;
i_data_tb <=x"04";
wait for 10 ns;
i_data_tb <=x"05";
wait for 10 ns;
i_data_tb <=x"06";
wait for 10 ns;
i_data_tb <=x"07";
wait for 10 ns;
i_data_tb <=x"08";
wait for 10 ns;
i_data_tb <=x"09";
wait for 10 ns;
i_data_tb <=x"0A";

end process test_process;
end  behavior;
