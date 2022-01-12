%% smu class
classdef smuClass < handle
    properties (SetAccess = private)
        smucom %COM1
    end
    
    methods 
        function this = smuClass()
            this.smucom = serial('COM1','BaudRate', 9600, 'Terminator', 'CR');
            set(this.smucom, 'Timeout', 10);
            fopen(this.smucom)
            serialCMD = sprintf('*RST\r');
            serialCMD = sprintf('%s:SOUR:FUNC VOLT\r', serialCMD);
            serialCMD = sprintf('%s:SOUR:VOLT:MODE FIXED\r', serialCMD);
            serialCMD = sprintf('%s:SENS:FUNC "CURR"\r', serialCMD);
            serialCMD = sprintf('%s:SENS:CURR:PROT 1E-3\r', serialCMD);
            %serialCMD = sprintf('%s:SENS:CURR:RANG 10E-2\r', serialCMD);
            serialCMD = sprintf('%s:SENS:CURR:RANG:AUTO ON\r', serialCMD);
            serialCMD = sprintf('%s:OUTP ON\r', serialCMD);
            fwrite(this.smucom, serialCMD);

            %set voltage
            serialCMD = sprintf(':ABOR\r');
            
     end
        
     function setVoltage(this,v)
            serialCMD = "";
            serialCMD = sprintf('%s:SOUR:VOLT:LEV %2.3f\r', serialCMD,v);
            serialCMD = sprintf('%s:INIT\r', serialCMD);
            fprintf(this.smucom, serialCMD);
     end
     
     function setCurrentLimit(this,Ilim)
          serialCMD = "";
          serialCMD = sprintf('%s:SENS:CURR:PROT %2.3f\r', serialCMD,Ilim);
          fwrite(this.smucom, serialCMD);
     end
        
     function r = readCurrent(this)
            fprintf(this.smucom,'READ?');
            curr=fscanf(this.smucom);
            currarr=regexp(curr,',','split');
            r = str2double(currarr(2));
      end
        
      function delete(this)
            fclose(this.smucom);
            delete(this.smucom);
      end
    end
end