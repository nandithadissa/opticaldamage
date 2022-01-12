%% TTL class to control shutter
classdef ttlClass < handle
    properties (SetAccess = private)
        ttlcom %COM7
    end
    
    methods 
        function this = ttlClass()
            this.ttlcom = serial('COM7','BaudRate', 9600, 'Terminator', 'CR');
            set(this.ttlcom, 'Timeout', 10);
            fopen(this.ttlcom)
            serialCMD = sprintf('*RST\r');
            serialCMD = sprintf('%s:SOUR:FUNC VOLT\r', serialCMD);
            serialCMD = sprintf('%s:SOUR:VOLT:MODE FIXED\r', serialCMD);
            serialCMD = sprintf('%s:SENS:FUNC "CURR"\r', serialCMD);
            serialCMD = sprintf('%s:SENS:CURR:PROT 1E-4\r', serialCMD);
            serialCMD = sprintf('%s:SENS:CURR:RANG:AUTO ON\r', serialCMD);
            serialCMD = sprintf('%s:OUTP ON\r', serialCMD);
            fwrite(this.ttlcom, serialCMD);
            serialCMD = sprintf(':ABOR\r');
            
     end
        
     function ON(this)
            v = 5.0;
            serialCMD = "";
            serialCMD = sprintf('%s:SOUR:VOLT:LEV %2.3f\r', serialCMD,v);
            serialCMD = sprintf('%s:INIT\r', serialCMD);
            fprintf(this.ttlcom, serialCMD);
            pause(1);
     end
        
      function OFF(this)
            v = 0;
            serialCMD = "";
            serialCMD = sprintf('%s:SOUR:VOLT:LEV %2.3f\r', serialCMD,v);
            serialCMD = sprintf('%s:INIT\r', serialCMD);
            fprintf(this.ttlcom, serialCMD);
            pause(1);
      end
             
      function delete(this)
            fclose(this.ttlcom);
            delete(this.ttlcom);
      end
    end
end