function [] = setwl_2( lambda )
%Set the Position of the wavelength filter wheels on Optic Bench 1
%   This combines the two filter wheels that contain bandpass filters.
%   The options include:
%       'white', 410, 440, 480, 500, 520, 600, 640, 660, 560, '570LP'
global wl1_2 wl2_2 fromgui wavelengths_2
if fromgui == 1
    probe_2()
end
if lambda == wavelengths_2{1}
    fprintf(wl1_2,'pos=1');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=1');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{2}
    fprintf(wl1_2,'pos=2');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=1');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{3}
    fprintf(wl1_2,'pos=3');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=1');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{4}
    fprintf(wl1_2,'pos=4');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=1');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{5}
    fprintf(wl1_2,'pos=5');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=1');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{6}
    fprintf(wl1_2,'pos=6');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=1');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{7}
    fprintf(wl1_2,'pos=1');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=2');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{8}
    fprintf(wl1_2,'pos=1');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=3');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{9}
    fprintf(wl1_2,'pos=1');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=4');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{10}
    fprintf(wl1_2,'pos=1');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=5');
    fscanf(wl2_2);
elseif lambda == wavelengths_2{11}
    fprintf(wl1_2,'pos=1');
    fscanf(wl1_2);
    fprintf(wl2_2,'pos=6');
    fscanf(wl2_2);
else
    error('Entered invalid wavelength for bench 2.')
end  
if fromgui == 1
    probe_2()
end
end

