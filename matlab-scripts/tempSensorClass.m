%% smu in current source mode to measure temp sensor
classdef tempSensorClass < handle
    properties (SetAccess = private)
        tempsensorcom %COM1
        tempcoefficient = 2.5 %mV/C %%% SET THIS VALUE
        A = -0.4028;
        B = 229; %222.9005;
    end
    
    methods 
        function this = tempSensorClass()
            this.tempsensorcom = serial('COM9','BaudRate', 9600, 'Terminator', 'CR'); %%CHANGE
            set(this.tempsensorcom, 'Timeout', 10);
            fopen(this.tempsensorcom)
            serialCMD = sprintf('*RST\r');
            serialCMD = sprintf('%s:SOUR:FUNC CURR\r', serialCMD);
            serialCMD = sprintf('%s:SOUR:CURR:MODE FIXED\r', serialCMD);
            serialCMD = sprintf('%s:SENS:FUNC "VOLT"\r', serialCMD);
            serialCMD = sprintf('%s:SENS:VOLT:PROT 5E0\r', serialCMD);
            %serialCMD = sprintf('%s:SENS:CURR:RANG 10E-2\r', serialCMD);
            serialCMD = sprintf('%s:SENS:VOLT:RANG:AUTO ON\r', serialCMD);
            serialCMD = sprintf('%s:OUTP ON\r', serialCMD);
            fwrite(this.tempsensorcom, serialCMD);

            %set Current
            serialCMD = sprintf(':ABOR\r');
            
     end
        
     function setCurrent(this,c)
            serialCMD = "";,
            serialCMD = sprintf('%s:SOUR:CURR:LEV %2.5f\r', serialCMD,c);
            serialCMD = sprintf('%s:INIT\r', serialCMD);
            fprintf(this.tempsensorcom, serialCMD);
     end
     
     function setVoltageLimit(this,Vlim)
          serialCMD = "";
          serialCMD = sprintf('%s:SENS:VOLT:PROT %2.3f\r', serialCMD,Vlim);
          fwrite(this.tempsensorcom, serialCMD);
     end
        
     function r = readVoltage(this)
            fprintf(this.tempsensorcom,'READ?');
            volt=fscanf(this.tempsensorcom);
            voltarr=regexp(volt,',','split');
            r = str2double(voltarr(1));
      end
        
      function delete(this)
            fclose(this.tempsensorcom);
            delete(this.tempsensorcom);
      end
      
      function findTempCoefficient(this)
              
         t= [10, 20.2, 40.7, 60.7, 80.7, 100.6,125.4,150.4,175.3,200.2];
         v = [525.57,507.92,454.6,401.62,353.7,301.9,239.01,178.2,114.8,63.02];
            
            scatter(v,t,25,'b','*') 
            P = polyfit(v,t,1);
            yfit = P(1)*v+P(2);
            this.A = P(1);
            this.B = P(2);
            this.A
            this.B
            hold on;
            plot(v,yfit,'r-.');
            set(0,'DefaultTextFontSize', 22);
             ylabel('Temp (C)');
             grid on;
            xlabel('Thermistor Voltage (mV)')
             
      end
     
      function r = getTemp(this,v)
          r = (this.A*v*1000 + this.B + 7.0); %convert V to mV
      end
      
     
    end
end