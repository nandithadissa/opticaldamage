function [  ] = initiatebench3()
%Open Serial Connections to Filter Wheels on Optic Bench 2
%   If you change a filter in the filter wheels change the global variables
%   defined in this function. If you change a bandpass filter, you must
%   also change the code in setwl and code.
global nd1_3 
nd1_3 = serial('COM32','BaudRate', 115200, 'Terminator', 'CR');
fopen(nd1_3);
global nd1s_3
nd1s_3 = {'open' 0.3 0.6 1.0 1.3 2.0};
end