counter_data = middledatatest(:,3);
counter_data_number = char(counter_data);
counter_data_number(counter_data_number == 'X') = '0';
counter_data_number_out = hex2dec(counter_data_number(:,5:size(counter_data_number,2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_data = middledatatest(:,4);
input = char(input_data);
input(input == 'X') = '0';
input_test_data = hex2dec(input(:,5:size(input,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
abs_subtract_out=middledatatest(:,6);
abs_subtract = char(abs_subtract_out);
abs_subtract(abs_subtract == 'X') = '0';
o_abs_subtract = hex2dec(abs_subtract(:,5:size(abs_subtract,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filter_out=middledatatest(:,7);
filterout = char(filter_out);
filterout(filterout == 'X') = '0';
o_filter_out = hex2dec(filterout(:,5:size(filterout,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

middledata=middledatatest(:,5);
middledata_out = char(middledata);
middledata_out(middledata_out== 'X') = '0';
middledata_o = hex2dec(middledata_out(:,5:size(middledata_out,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



figure(1)
hold on
plot(counter_data_number_out,input_test_data)
plot(counter_data_number_out,middledata_o);
plot(counter_data_number_out,o_abs_subtract);
plot(counter_data_number_out,o_filter_out)
xlabel("data sampling(counter)")
ylabel("number of bits for filter output")
legend("input test data","middle data to calculate abs subtract","abs subtract after 4 data","filter output after 1 data")
hold off


figure(2)
semilogy(counter_data_number_out,input_test_data,counter_data_number_out,middledata_o,counter_data_number_out,o_abs_subtract,counter_data_number_out,o_filter_out)
legend("input test data","middle data to calculate abs subtract","abs subtract after 4 data","filter output after 1 data")


