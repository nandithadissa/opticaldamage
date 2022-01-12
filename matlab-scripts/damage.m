%%%
% Project: APD damage setup code: Optical power characterization
% Date: Nov, 11 2021, Author: Nanditha Dissanayake,
% ndissanayake@allegromicro.com
% 
% Use of the script:
% 1. Turn power on the Cybel laser and manually set the current
% 2. Turn on Kiethley, Newport power meter, ND filter wheels, halfwave
% plate rotational stage
% 3. Align the beam on the detector and run the diagnostics
%%%


%activate the serial ports
cy = serial('COM4','BaudRate', 9600, 'Terminator', 'CR');   %cybel
smu1 = serial('COM1','BaudRate', 9600, 'Terminator', 'CR'); %kiethley
nd1 = serial('COM5','BaudRate', 115200, 'Terminator', 'CR'); %filter-wheel1
nd2 = serial('COM6','BaudRate', 115200, 'Terminator', 'CR'); %filter-wheel2

%Turn on the laser and set to PRF, pulse-width and output power
% 1-A power
fprintf(cy,'setp 0');
pause(1);
fprintf(cy,'sp 0');
pause(1);
input = prompt("PLEASE TURN ON PUMP LASER BIAS AND PRESS ENTER");
fprintf(cy,'sp 1');
pause(1);
fprintf(cy,'setp 1');
fprintf("LASER ON: 1-A");


%plot power in the photodetector at 
