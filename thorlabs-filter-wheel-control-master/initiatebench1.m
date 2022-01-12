function [  ] = initiatebench1()
%Open Serial Connections to Filter Wheels on Optic Bench 1
global nd1 nd2 wl1 %wl2
nd1 = serial('COM31','BaudRate', 115200, 'Terminator', 'CR');
nd2 = serial('COM9','BaudRate', 115200, 'Terminator', 'CR');
wl1 = serial('COM11','BaudRate', 115200, 'Terminator', 'CR');
%wl2 = serial('COM9', 'BaudRate', 115200, 'Terminator', 'CR');
fopen(nd1);
fopen(nd2);
fopen(wl1);
%fopen(wl2);
global nd1s nd2s wavelengths
wavelengths = {'white' 620 440 480 500 560}; %wavelengths = {'white' 620 440 480 500 520 560 600 640 460 510};
nd1s = {'open' 'stop' 1.0 2.0 3.0 4.0};
nd2s = {'open' 0.3 0.6 1.0 1.3 2.0};
end