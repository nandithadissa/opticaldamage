function [] = probe()
%Probe Filter Wheel Position
%   Use this function to determine current light intensity for optic bench
%   1. This function appends its outputs onto wavelength, nd1pos, nd2pos,
%   and time. Value 0 for any wheel is "open". Value 9 for nd1pos is
%   "stop".
[a,b,c,d] = probes();
global wavelength nd1pos nd2pos time
if isempty(time) == 0
    wavelength = [wavelength a];
    nd1pos = [nd1pos b];
    nd2pos = [nd2pos c];
    time = [time d];
else
    wavelength = a;
    nd1pos = b;
    nd2pos = c;
    time = d;
end
end

function [wlen, posnd1, posnd2, ti] = probes()
global nd1 nd2 wl1 wl2 wavelengths nd1s nd2s
fprintf(wl1,'pos?'); % sends command to wheel to probe position
fscanf(wl1); %
c = fscanf(wl1); % must scan twice for unknown reason
%fprintf(wl2,'pos?');
%fscanf(wl2);
d = '1';%d = fscanf(wl2);
if c(1) == '1' && d(1) == '1'
    wl = 0; %if both positions are 1, wl = 0, which signifies open
elseif c(1) == '2'
    wl = wavelengths{2};
elseif c(1) == '3'
    wl = wavelengths{3};
elseif c(1) == '4'
    wl = wavelengths{4};
elseif c(1) == '5'
    wl = wavelengths{5};
elseif c(1) == '6'
    wl = wavelengths{6};
elseif d(1) == '2'
    wl = wavelengths{7};
elseif d(1) == '3'
    wl = wavelengths{8};
elseif d(1) == '4'
    wl = wavelengths{9};
elseif d(1) == '5'
    wl = wavelengths{10};
elseif d(1) == '6'
    wl = wavelengths{11};
else wl = 1000;
end
wlen = wl;
fprintf(nd1,'pos?');
fscanf(nd1);
a = fscanf(nd1);
if a(1) == '1'          %fscanf appears to give a character matrix - it is unclear what a(2) is, but it does not equal the output.
    x = 0;              % corresponds to open
elseif a(1) == '2'
    x = 9;              % corresponds to stop
elseif a(1) == '3'
    x = nd1s{3};
elseif a(1) == '4'
    x = nd1s{4};
elseif a(1) == '5'
    x = nd1s{5};
elseif a(1) == '6'
    x = nd1s{6};
else
    x = 1000;
end
if isnumeric(x)
    posnd1 = x;
else
    error('Value for ND1 is not numeric.')
end
fprintf(nd2,'pos?');
fscanf(nd2);
b = fscanf(nd2);
if b(1) == '1'
    y = 0; % value for open
elseif b(1) == '2'
    y = nd2s{2};
elseif b(1) == '3'
    y = nd2s{3};
elseif b(1) == '4'
    y = nd2s{4};
elseif b(1) == '5'
    y = nd2s{5};
elseif b(1) == '6'
    y = nd2s{6};
else
    y = 1000;
end
if isnumeric(y)
    posnd2 = y;
else
    error('Value for ND2 is not numeric.')
end
ti = now;
end