%test code to control the cybel laser

cy = serial('COM4','BaudRate', 9600, 'Terminator', 'CR')
set(cy, 'Timeout', 10);
fopen(cy)
fprintf(cy,'disp')
status = fscanf(cy)
status
fprintf(cy,'setp 0')
fclose(cy)
delete(cy)


%
%cy = serial('COM4'); % assign serial port object for Source Meter (Keithley 2400)
%set(cy, 'BaudRate', 9600); % set BaudRate to 115200
%set(cy, 'Parity', 'none'); % set Parity Bit to None
%set(cy, 'DataBits', 8); % set DataBits to 8
%set(cy, 'StopBit', 1); % set StopBit to 1
%set(cy, 'Terminator', 'CR'); % set CR instead of LF
%set(cy, 'Timeout', 10); % Default is 10, changed to 1 seconds
%set(cy, 'InputBufferSize', 2048); % InputBufferSize Default: 512
%set(cy, 'OutputBufferSize', 2048); % OutputBufferSize Default: 512
%%disp(get(tep,{'Type','Name','Port','BaudRate','Parity','DataBits','StopBits','Terminator','Timeout'})); % Runtime status
%fopen(cy); % Open Source Meter COM port Object
%disp=query(cy,'disp');
%pause(1);
%disp    
%fclose(cy);
%delete(cy);


