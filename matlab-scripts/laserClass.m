%cybel laser class
classdef laserClass < handle
    properties (SetAccess = private)
        cycom;
        current;
    end
    
    methods
        function this = laserClass()
            this.cycom = serial('COM4','BaudRate', 9600, 'Terminator', 'CR');
            set(this.cycom, 'Timeout', 10);
            fopen(this.cycom);
            pause(5);
            fprintf(this.cycom,'setp 0');
            pause(1);
            fprintf(this.cycom,'sp 0');
            pause(1);
            fprintf("turn on laser\n");
            fprintf(this.cycom,'sp 1');
            pause(5);
        end
        
        function setCurrent(this,curr)
            if (curr>=0.0)&&(curr<=5.6)
                %check if seed laser is on
                this.current = curr;
                cmd=sprintf('setp %1.1f',curr);
                fprintf(">>setting command = %s\n",cmd);
                fprintf(this.cycom,cmd);
                pause(10);
            else
                fprintf(">>ERROR Current value is wrong<<\n");
            end
        end
            
        function set1Amp(this)
            %check if seed laser is
            this.current = 1.0;
            fprintf(this.cycom,'setp 1');
            pause(10);
        end
        
        function setPRF(this,PRF)
            if (PRF >= 10) && (PRF <= 1000)
                %set the laser PRF
                fprintf(this.cycom,'setp 0');
                pause(1);
                fprintf(this.cycom,'sp 0');
                pause(1);
                cmd=sprintf('spf %i',PRF);
                fprintf(">>setting command = %s\n",cmd);
                fprintf(this.cycom,cmd);
                pause(1);
                fprintf(this.cycom,'sp 1');
                pause(1);
            else
                fprintf(">>ERROR PRF value is wrong<<\n");
            end
        end
        
        function setPulseWidth(this,PulseWidth)
            %set the laser pulse width
            if (PulseWidth >= 6) && (PulseWidth <= 120)
                fprintf(">>Setting pulse width");
                 %set the laser PRF
                fprintf(this.cycom,'setp 0');
                pause(1);
                fprintf(this.cycom,'sp 0');
                pause(1);
                cmd=sprintf('spw %i',PulseWidth);
                fprintf(">>setting command = %s\n",cmd);
                fprintf(this.cycom,cmd);
                pause(1);
                fprintf(this.cycom,'sp 1');
                pause(1);
            else
                fprintf(">>ERROR Pulsewidth is wrong<<\n");
            end
        end
        
        function delete(this)
            fprintf(this.cycom,'setp 0');
            pause(1);
            fprintf(this.cycom,'sp 0');
            pause(1);
            fprintf("turn off laser power\n");
            fclose(this.cycom);
            delete(this.cycom);
        end
         
    end
end