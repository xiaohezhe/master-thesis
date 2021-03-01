library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;

entity test_pre_next_avg is
end test_pre_next_avg;

architecture behavior of test_pre_next_avg is


component previous_average_and_next_average is
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
end component previous_average_and_next_average;

constant data_bits: integer := 16;
constant group_length: integer:=2;
signal  i_clk_tb:  std_logic:='0';
signal  i_data_tb: std_logic_vector(data_bits-1 downto 0):=(others=>'0');
signal  o_data_subtract_tb: std_logic_vector(data_bits+group_length+1-1 downto 0):=(others=>'0');
signal  o_data_abs_subtract_tb: std_logic_vector(data_bits+group_length+1-1 downto 0):=(others=>'0');
signal  o_filter_data_tb: std_logic_vector(data_bits+group_length+1-1 downto 0):=(others=>'0');
signal  o_number_bits_tb: std_logic_vector(7 downto 0):=(others=>'0');
signal runsim : boolean := true;
signal counter_data_tb: std_logic_vector(15 downto 0):=(others=>'0');

begin
previous_average_and_next_average_component:

	component previous_average_and_next_average 

	port map(
			i_clk =>i_clk_tb,
			i_data=>i_data_tb,
			o_data_subtract => o_data_subtract_tb,
			o_data_abs_subtract => o_data_abs_subtract_tb,
			o_filter_data=> o_filter_data_tb,
			o_number_bits=>o_number_bits_tb,
			o_counter_data=>counter_data_tb
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


--    counter_data:process
--    begin
--	if (rising_edge(i_clk_tb)) then
--		if(counter_data_tb=x"FFFF") then
--			counter_data_tb <= x"0000";
--	else
--		counter_data_tb <= counter_data_tb+x"0001";
--		end if;
--	end if;
--	end process counter_data;





    test_filedata : process
        constant filename:      string := "test_data\data.csv"; 
        file file_pointer:      text;
        variable line_content:  integer;
        variable line_num:      line; 
        variable filestatus:    file_open_status;

begin
        file_open(filestatus, file_pointer,"test_data\data.csv",read_mode);

        while not ENDFILE (file_pointer) loop
            wait until rising_edge(i_clk_tb);  -- once per clock
            readline (file_pointer, line_num); 
            read (line_num, line_content);
            i_data_tb <= std_logic_vector(to_unsigned(line_content,i_data_tb'length));
	 
        end loop;

        wait until rising_edge(i_clk_tb); -- the last data
        file_close (file_pointer);

        report "test_data\data.csv" & " closed.";
        wait;
end process test_filedata;

--test_process: process is
--begin
----let test data keep a bit more than one clock to examine the rising edge output result
--wait for 12 ns;
--i_data_tb <=x"00F0";
--wait for 10 ns;
--i_data_tb <=x"02";
--wait for 10 ns;
--i_data_tb <=x"03";
--wait for 10 ns;
--i_data_tb <=x"04";
--wait for 10 ns;
--i_data_tb <=x"05";
--wait for 10 ns;
--i_data_tb <=x"06";
--wait for 10 ns;
--i_data_tb <=x"07";
--wait for 10 ns;
--i_data_tb <=x"08";
--wait for 10 ns;
--i_data_tb <=x"09";
--wait for 10 ns;
--i_data_tb <=x"0A";
--
--end process test_process;
end  behavior;
