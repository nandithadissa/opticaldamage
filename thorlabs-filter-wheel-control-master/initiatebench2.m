function [  ] = initiatebench2()
%Open Serial Connections to Filter Wheels on Optic Bench 2
%   If you change a filter in the filter wheels change the global variables
%   defined in this function. If you change a bandpass filter, you must
%   also change the code in setwl and code.
global nd1_2 nd2_2 wl1_2 wl2_2
nd1_2 = serial('COM17','BaudRate', 115200, 'Terminator', 'CR');
nd2_2 = serial('COM18','BaudRate', 115200, 'Terminator', 'CR');
wl1_2 = serial('COM8','BaudRate', 115200, 'Terminator', 'CR');
wl2_2 = serial('COM19', 'BaudRate', 115200, 'Terminator', 'CR');
fopen(nd1_2);
fopen(nd2_2);
fopen(wl1_2);
fopen(wl2_2);
global nd1s_2 nd2s_2 wavelengths_2
wavelengths_2 = {'white' 410 440 480 500 520 600 640 660 560 '570LP'};
nd1s_2 = {'open' 1.0 2.0 3.0 4.0 'stop'};
nd2s_2 = {'open' 0.3 0.6 0.9 1.3 2.0};
end