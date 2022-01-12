function [] = closeob3()
%Closes serial connections and clears serial variables
%for filter wheels on bench 2. Also saves text files with positions to
%Filter Wheel Positions folder on desktop.
global nd1_3
fclose(nd1_3);
delete(nd1_3);
clear global nd1_3 nd1s_3;
global nd1pos_3 time_3 
if isempty(time_3) == 0
    savestring = ['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_3(1),'yyyymmdd') 'nd1pos_3.txt'];
    if exist(savestring,'file') == 2 % if position files have already been saved that day, save using hours and minutes along with date
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_3(1),'yyyymmdd HHMM') ' nd1pos_3.txt'],'nd1pos_3','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_3(1),'yyyymmdd HHMM') ' time_3.txt'],'time_3','-ascii')
    else
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_3(1),'yyyymmdd') 'nd1pos_3.txt'],'nd1pos_3','-ascii')
        save(['C:\Users\Alan\Desktop\Filter Wheel Positions\' datestr(time_3(1),'yyyymmdd') 'time_3.txt'],'time_3','-ascii')
    end
end
end

