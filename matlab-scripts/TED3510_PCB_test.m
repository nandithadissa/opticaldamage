%TED3510_PCB test script
%this script shows typical usage if the TED3510_PCB matlab driver

%Typical Usage Example ************************************
% note: The PCB requires 3.3V power (for the EEPROM) to achieve serial port Connection

clear

% create an instance of the TED3510_PCB object and connnect
ted3510=TED3510_PCB;
ted3510.connect;

%read the temperature
disp("Temperature "+ted3510.tempC+"C");

%display all information in the EERPOM
disp(ted3510.id);

answer = inputdlg("Seconds to monitor temperature","Temp");
time1 = str2double(answer);
result=zeros(time1,2);
if time1>1
    f=figure(1); %create a figure
    
    for idx=1:time1
        pause(1);
        result(idx,1)=idx;
        result(idx,2)=ted3510.tempC;
        plot(result(1:idx-1,1),result(1:idx-1,2));
        title('Temperature vs Time');
        xlabel('seconds');
        ylabel('degrees C');
        grid("on");
        
    end %idx time
end %if



%test the driver ********************************************
answer = questdlg("Test Driver?","Test");
if ~strcmp(answer,'Yes'); return;end  %exit if test not desired

disp("PCB identification string: "+ted3510.serialIdentify)



%verify the serialEcho property is present
ted3510.serialEcho=0;

%Connect emulated serial port 5 times
    for idx=1:5
        ted3510.connect;
    end  %for idx

%display help calls for properties
allprops=properties(TED3510_PCB);
for idx=1:size(allprops,1)
    propname="TED3510_PCB."+allprops(idx,1);
    help (propname);
end %for idx

%display help calls for methods
allMethods=["connect" "disconnect" "identify"];
for idx=1:size(allMethods,2)
    disp(allMethods(1,idx));
    help ("TED3510_PCB."+allMethods(1,idx));
end %for





