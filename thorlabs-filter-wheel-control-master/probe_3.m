function [] = probe_3()
%Probe Filter Wheel Position
%   Use this function to determine current light intensity for optic bench
%   1. This function appends its outputs onto wavelength, nd1pos, nd2pos,
%   and time. Value 0 for any wheel is "open". Value 9 for nd1pos is
%   "stop".
[a, b] = probes_3();
global nd1pos_3 time_3
if isempty(time_3) == 0
    nd1pos_3 = [nd1pos_3 a];
    time_3 = [time_3 b];
else
    nd1pos_3 = a;
    time_3 = b;
end
end

function [posnd1, ti] = probes_3()
global nd1_3 nd1s_3
fprintf(nd1_3,'pos?');
fscanf(nd1_3);
a = fscanf(nd1_3);
if a(1) == '1'  %fscanf appears to give a character matrix - it is unclear what a(2) is, but it does not equal the output.
    x = 0;
elseif a(1) == '2'
    x = nd1s_3{2};
elseif a(1) == '3'
    x = nd1s_3{3};
elseif a(1) == '4'
    x = nd1s_3{4};
elseif a(1) == '5'
    x = nd1s_3{5};
elseif a(1) == '6'
    x = nd1s_3{6};
else
    x = 1000;
end
posnd1 = x;
ti = now;
end