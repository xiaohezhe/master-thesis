
clock_out = dived8lessnoise(:,1);%%1/8new data
clock_out = str2double(clock_out);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_data = dived8lessnoise(:,4);
input = char(input_data);
input(input == 'X') = '0';
input_test_data = hex2dec(input(:,5:size(input,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
abs_subtract_out=dived8lessnoise(:,5);
abs_subtract = char(abs_subtract_out);
abs_subtract(abs_subtract == 'X') = '0';
o_abs_subtract = hex2dec(abs_subtract(:,5:size(abs_subtract,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filter_out=dived8lessnoise(:,3);
filterout = char(filter_out);
filterout(filterout == 'X') = '0';
o_filter_out = hex2dec(filterout(:,5:size(filterout,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

number_bits=dived8lessnoise(:,6);
number_bits_out = char(number_bits);
number_bits_out(number_bits_out == 'X') = '0';
o_number_bits_out = hex2dec(number_bits_out(:,5:size(number_bits_out,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--1/16
clock_out_16 = dived16lessnoise(:,1);%%1/16new data
clock_out_16 = str2double(clock_out_16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filter_out_16=dived16lessnoise(:,3);
filterout_16 = char(filter_out_16);
filterout_16(filterout_16 == 'X') = '0';
o_filter_out_16 = hex2dec(filterout_16(:,5:size(filterout_16,2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number_bits_16=dived16lessnoise(:,4);
number_bits_out_16 = char(number_bits_16);
number_bits_out_16(number_bits_out_16 == 'X') = '0';
o_number_bits_out_16 = hex2dec(number_bits_out_16(:,5:size(number_bits_out_16,2)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--1/32
clock_out_32 = dived32lessnoise(:,1);%%1/32new data
clock_out_32 = str2double(clock_out_32);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filter_out_32=dived32lessnoise(:,4);
filterout_32 = char(filter_out_32);
filterout_32(filterout_32 == 'X') = '0';
o_filter_out_32 = hex2dec(filterout_32(:,5:size(filterout_32,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number_bits_32=dived32lessnoise(:,3);
number_bits_out_32 = char(number_bits_32);
number_bits_out_32(number_bits_out_32 == 'X') = '0';
o_number_bits_out_32 = hex2dec(number_bits_out_32(:,5:size(number_bits_out_32,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--1/64
clock_out_64 = dived64lessnoise(:,1);%%1/64new data
clock_out_64 = str2double(clock_out_64);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filter_out_64=dived64lessnoise(:,3);
filterout_64 = char(filter_out_64);
filterout_64(filterout_64 == 'X') = '0';
o_filter_out_64 = hex2dec(filterout_64(:,5:size(filterout_64,2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

number_bits_64=dived64lessnoise(:,4);
number_bits_out_64 = char(number_bits_64);
number_bits_out_64(number_bits_out_64 == 'X') = '0';
o_number_bits_out_64 = hex2dec(number_bits_out_64(:,5:size(number_bits_out_64,2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(1)
hold on
plot(clock_out,input_test_data+max(o_abs_subtract(:))+max(o_filter_out(:)));
plot(clock_out,o_abs_subtract+max(o_filter_out(:)));

plot(clock_out,o_filter_out);
plot(clock_out_16,o_filter_out_16);
plot(clock_out_32,o_filter_out_32);
plot(clock_out_64,o_filter_out_64);
xlabel("clock time/ns")
ylabel("data intput,abs subtract,filter output")

legend("test data","abs subtract(feed to filter)","filter output speed 3","filter output speed 4","filter output speed 5","filter output speed 6")
hold off

figure(2)
hold on
plot(clock_out,o_number_bits_out)
plot(clock_out_16,o_number_bits_out_16);
plot(clock_out_32,o_number_bits_out_32);
plot(clock_out_64,o_number_bits_out_64)
xlabel("clock time/ns")
ylabel("number of bits for filter output")
legend("speed 3","speed 4","speed 5","speed 6")
hold off

figure(3)
semilogy(clock_out,o_filter_out,clock_out_16,o_filter_out_16,clock_out_32,o_filter_out_32,clock_out_64,o_filter_out_64)
legend("speed 3","speed 4","speed 5","speed 6")
xlabel("clock time/ns")
ylabel("log2")

figure(4)
plot(clock_out,o_filter_out,clock_out_16,o_filter_out_16,clock_out_32,o_filter_out_32,clock_out_64,o_filter_out_64)
legend("speed 3","speed 4","speed 5","speed 6")
xlabel("clock time/ns")
ylabel("filter output")


figure(5)
semilogy(clock_out,o_abs_subtract)
legend("abs subtract(abs mean estimate)")
xlabel("clock time/ns")
ylabel("abs subtract")

figure(6)
semilogy(clock_out,o_abs_subtract,clock_out,o_filter_out,clock_out_16,o_filter_out_16,clock_out_32,o_filter_out_32,clock_out_64,o_filter_out_64)
legend("abs subtract","speed 3","speed 4","speed 5","speed 6")
xlabel("clock time/ns")
ylabel("filter output compare to abs subtract")