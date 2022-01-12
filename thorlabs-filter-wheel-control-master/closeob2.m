function [] = closeob2()
%Closes serial connections and clears serial variables
%for filter wheels on bench 2. Also saves text files with positions to
%Filter Wheel Positions folder on desktop.
global nd1_2 nd2_2 wl1_2 wl2_2
fclose(nd1_2);
fclose(nd2_2);
fclose(wl1_2);
fclose(wl2_2);
delete(nd1_2);
delete(nd2_2);
delete(wl1_2);
delete(wl2_2);
clear global nd1_2 nd2_2 wl1_2 wl2_2 wavelengths_2 nd1s_2 nd2s_2;
global nd1pos_2 nd2pos_2 time_2 wavelength_2  
if isempty(time_2) == 0
    savestring = ['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time(1),'yyyymmdd') 'nd1pos_2.txt'];
    if exist(savestring,'file') == 2 % if position files have already been saved that day, save using hours and minutes along with date
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd HHMM') ' nd1pos_2.txt'],'nd1pos_2','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd HHMM') ' nd2pos_2.txt'],'nd2pos_2','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd HHMM') ' wavelength_2.txt'],'wavelength_2','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd HHMM') ' time_2.txt'],'time_2','-ascii')
    else
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd') 'nd1pos_2.txt'],'nd1pos_2','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd') 'nd2pos_2.txt'],'nd2pos_2','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd') 'wavelength_2.txt'],'wavelength_2','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_2(1),'yyyymmdd') 'time_2.txt'],'time_2','-ascii')
    end
end
end

