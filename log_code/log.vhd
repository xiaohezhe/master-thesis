library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dptc_util_pkg is  --Packages are most often used to group together all of 
                          --the code specific to a Library,like .h file in C

    function dptc_log2(x : positive) return integer;


end dptc_util_pkg;

--if x=2,output=1, if x=3, output=2
package body dptc_util_pkg is
    function dptc_log2 (   x : positive) return integer is
        variable temp, log: natural;
    begin
        if (x = 1) then -- avoid warning about zero number of iterations
            return 0;
        end if;
        temp := x / 2;
        log := 0;
        while (temp /= 0) loop --not equal
            temp := temp/2;
            log := log + 1;
        end loop;
	if(x > 2**log) then
		return(log+1);
	else
		return(log);
	end if;
        return log;
    end function;
end;

