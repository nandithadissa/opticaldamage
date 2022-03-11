% class to test apd sensor temp
classdef apdTempTestClass < handle
    properties (SetAccess = private)
        smu
        tempsensor
    end
    
     methods
        function this  = apdTempTestClass()
            clc;
            this.smu = smuClass();
            this.tempsensor = tempSensorClass();
        end
        
         function delete(this)
            this.smu.delete();
            this.tempsensor.delete();
         end
        
         function darkcurrentwithHeat(this,testName,runNum)
            startTime = 0;
            endTime = 3600;
            stepTime = 0.5;
            
            
            timeSweepPts = int32(abs((endTime-startTime)/stepTime));
            timeArr = zeros(1,timeSweepPts);
            currArr = zeros(1,timeSweepPts);
            voltArr = zeros(1,timeSweepPts); %Termistor voltage
            tempArr = zeros(1,timeSweepPts);
            
            this.smu.setCurrentLimit(0.05); %%CHANGE this laterd
          
            apdVoltage = 40.1;
            this.smu.setVoltage(apdVoltage); %%%CHANGE TO M=10;
            
            
            this.tempsensor.setVoltageLimit(1); %1V
            this.tempsensor.setCurrent(10E-6);  %source 10uA for temp measurements
            
     
            figure;
            ylabel('APD Current (A)');
            grid on;
            xlabel('Temp (C)');
            hold on;
            grid on;
            for i = 1:timeSweepPts
                currArr(i)=this.smu.readCurrent();
                timeArr(i)= single(startTime + stepTime*i);
                voltArr(i) = this.tempsensor.readVoltage();
                tempArr(i)= this.tempsensor.getTemp(voltArr(i));
                pause(stepTime); %%%seconds
                plot(tempArr(1:i),currArr(1:i),'-');
                scatter(tempArr(1:i),currArr(1:i));
            end
            
            this.smu.setVoltage(0);
            this.tempsensor.setCurrent(0);
            
              %plot figure and save data
            save(sprintf('%s_%i_tempsensorvoltageArr.mat',testName,runNum), 'voltArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_tempArr.mat',testName,runNum), 'tempArr');
            save(sprintf('%s_%i_timeArr.mat',testName,runNum), 'timeArr');
            save(sprintf('%s_%i_apdVoltage.mat',testName,runNum), 'apdVoltage');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
            
             %write to a 2D CSV file
            tempcurrdata = [tempArr(:) currArr(:)];
            timecurrdata = [timeArr(:) currArr(:)];
            termistervoltagecurrdata = [voltArr(:) currArr(:)];
            
            csvwrite(sprintf('%s_%i_temp_darkcurrent_data.txt',testName,runNum),tempcurrdata);
            csvwrite(sprintf('%s_%i_time_darkcurrent_data.txt',testName,runNum),timecurrdata);
            csvwrite(sprintf('%s_%i_termistervoltage_darkcurrent_data.txt',testName,runNum),termistervoltagecurrdata);
            
         end
         
     end
end
