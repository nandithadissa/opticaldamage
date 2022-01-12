function [] = probe_2()
%Probe Filter Wheel Position
%   Use this function to determine current light intensity for optic bench
%   1. This function appends its outputs onto wavelength, nd1pos, nd2pos,
%   and time. Value 0 for any wheel is "open". Value 9 for nd1pos is
%   "stop".
[a,b,c,d] = probes_2();
global wavelength_2 nd1pos_2 nd2pos_2 time_2
if isempty(time_2) == 0
    wavelength_2 = [wavelength_2 a];
    nd1pos_2 = [nd1pos_2 b];
    nd2pos_2 = [nd2pos_2 c];
    time_2 = [time_2 d];
else
    wavelength_2 = a;
    nd1pos_2 = b;
    nd2pos_2 = c;
    time_2 = d;
end
end

function [ wlen, posnd1, posnd2, ti] = probes_2()
global nd1_2 nd2_2 wl1_2 wl2_2
fprintf(wl1_2,'pos?');
fscanf(wl1_2);
c = fscanf(wl1_2);
fprintf(wl2_2,'pos?');
fscanf(wl2_2);
d = fscanf(wl2_2);
if c(1) == '1' & d(1) == '1'
    wl = 0;
elseif c(1) == '2'
    wl = 410;
elseif c(1) == '3'
    wl = 440;
elseif c(1) == '4'
    wl = 480;
elseif c(1) == '5'
    wl = 500;
elseif c(1) == '6'
    wl = 520;
elseif d(1) == '2'
    wl = 600;
elseif d(1) == '3'
    wl = 640;
elseif d(1) == '4'
    wl = 660;
elseif d(1) == '5'
    wl = 560;
elseif d(1) == '6'
    wl = 570;
else wl = 1000;
end
wlen = wl;
fprintf(nd1_2,'pos?');
fscanf(nd1_2);
a = fscanf(nd1_2);
if a(1) == '1'  %fscanf appears to give a character matrix - it is unclear what a(2) is, but it does not equal the output.
    x = 0;
elseif a(1) == '6'
    x = 9;
elseif a(1) == '2'
    x = 1;
elseif a(1) == '3'
    x = 2;
elseif a(1) == '4'
    x = 3;
elseif a(1) == '5'
    x = 4;
else
    x = 1000;
end
posnd1 = x;
fprintf(nd2_2,'pos?');
fscanf(nd2_2);
b = fscanf(nd2_2);
if b(1) == '1'
    y = 0;
elseif b(1) == '2'
    y = 0.3;
elseif b(1) == '3'
    y = 0.6;
elseif b(1) == '4'
    y = 0.9;
elseif b(1) == '5'
    y = 1.3;
elseif b(1) == '6'
    y = 2.0;
else
    y = 1000;
end
posnd2 = y;
ti = now;
end