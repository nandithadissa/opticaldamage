function [] = closeob1()
%Closes serial connections and clears serial variables for filter wheels.
%
global nd1 nd2 wl1 %wl2
fclose(nd1);
fclose(nd2);
fclose(wl1);
%fclose(wl2);
delete(nd1);
delete(nd2);
delete(wl1);
%delete(wl2);
clear global nd1 nd2 wl1 wavelengths nd1s nd2s;%wl2
global nd1pos nd2pos wavelength time
if isempty(time) == 0
   savestring = ['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(1),'yyyymmdd') 'nd1pos.txt'];
    if exist(savestring,'file') == 2 % if position files have already been saved that day, save using hours and minutes along with date
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(length(time)),'yyyymmdd HHMM') 'nd1pos.txt'],'nd1pos','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(length(time)),'yyyymmdd HHMM') 'nd2pos.txt'],'nd2pos','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(length(time)),'yyyymmdd HHMM') 'wavelength.txt'],'wavelength','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(length(time)),'yyyymmdd HHMM') 'time.txt'],'time','-ascii')
    else
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(1),'yyyymmdd') 'nd1pos.txt'],'nd1pos','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(1),'yyyymmdd') 'nd2pos.txt'],'nd2pos','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(1),'yyyymmdd') 'wavelength.txt'],'wavelength','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(1),'yyyymmdd') 'time.txt'],'time','-ascii')
    end
end
end

