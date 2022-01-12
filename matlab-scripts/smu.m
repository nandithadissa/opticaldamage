%test code to control the smu COM1 = 
smu1 = serial('COM1','BaudRate', 9600, 'Terminator', 'CR');
set(smu1, 'Timeout', 10);
fopen(smu1)
serialCMD = sprintf('*RST\r');
serialCMD = sprintf('%s:SOUR:FUNC VOLT\r', serialCMD);
serialCMD = sprintf('%s:SOUR:VOLT:MODE FIXED\r', serialCMD);
serialCMD = sprintf('%s:SENS:FUNC "CURR"\r', serialCMD);
serialCMD = sprintf('%s:SENS:CURR:PROT 75E-3\r', serialCMD);
%serialCMD = sprintf('%s:SENS:CURR:RANG 10E-2\r', serialCMD);
serialCMD = sprintf('%s:SENS:CURR:RANG:AUTO ON\r', serialCMD);
serialCMD = sprintf('%s:OUTP ON\r', serialCMD);
fwrite(smu1, serialCMD);

%set voltage
serialCMD = sprintf(':ABOR\r');
serialCMD = sprintf('%s:SOUR:VOLT:LEV %2.3f\r', serialCMD,0.0);
serialCMD = sprintf('%s:INIT\r', serialCMD);
fprintf(smu1, serialCMD);


%read current
fprintf(smu1,'READ?')
curr=fscanf(smu1)
currarr=regexp(curr,',','split');
curr = str2double(currarr(2))
curr
fclose(smu1)
delete(smu1)
