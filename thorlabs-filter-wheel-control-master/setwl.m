function [] = setwl( lambda )
%Set the Position of the wavelength filter wheels on Optic Bench 1
%   This combines the two filter wheels that contain bandpass filters.
global wl1 wl2 fromgui
if fromgui == 1
    probe()
end
global wavelengths
if strcmpi(lambda,wavelengths{1})
    fprintf(wl1,'pos=1');
    fscanf(wl1);
    %fprintf(wl2,'pos=1');
    %fscanf(wl2);
elseif lambda == wavelengths{2}
    fprintf(wl1,'pos=2');
    fscanf(wl1);
    %fprintf(wl2,'pos=1');
    %fscanf(wl2);
elseif lambda == wavelengths{3}
    fprintf(wl1,'pos=3');
    fscanf(wl1);
    %fprintf(wl2,'pos=1');
    %fscanf(wl2);
elseif lambda == wavelengths{4}
    fprintf(wl1,'pos=4');
    fscanf(wl1);
    %fprintf(wl2,'pos=1');
    %fscanf(wl2);
elseif lambda == wavelengths{5}
    fprintf(wl1,'pos=5');
    fscanf(wl1);
    %fprintf(wl2,'pos=1');
    %fscanf(wl2);
elseif lambda == wavelengths{6}
    fprintf(wl1,'pos=6');
    fscanf(wl1);
    %fprintf(wl2,'pos=1');
    %fscanf(wl2);
elseif lambda == wavelengths{7}
    fprintf(wl1,'pos=1');
    fscanf(wl1);
    %fprintf(wl2,'pos=2');
    %fscanf(wl2);
elseif lambda == wavelengths{8}
    fprintf(wl1,'pos=1');
    fscanf(wl1);
    %fprintf(wl2,'pos=3');
    %fscanf(wl2);
elseif lambda == wavelengths{9}
    fprintf(wl1,'pos=1');
    fscanf(wl1);
    %fprintf(wl2,'pos=4');
    %fscanf(wl2);
elseif lambda == wavelengths{10}
    fprintf(wl1,'pos=1');
    fscanf(wl1);
    %fprintf(wl2,'pos=5');
    %fscanf(wl2);
elseif lambda == wavelengths{11}
    fprintf(wl1,'pos=1');
    fscanf(wl1);
    %fprintf(wl2,'pos=6');
    %fscanf(wl2);
else
    error('Entered invalid wavelength.')
end  
if fromgui == 1
    probe()
end
end

