%%% Damage test class

classdef damageTestClass < handle
    properties (SetAccess = private)
        smu
        hwplate
        ndfilters
        powermeter
        laser
        shutter
        linear %comment out when the linear stage is not in use
    end
    
    methods
        function this  = damageTestClass()
            clc;
            this.smu = smuClass();
            this.laser = laserClass();
            this.hwplate = hwplateClass();
            this.powermeter = powermeterClass();
            this.ndfilters = filterwheelClass();
            this.shutter = ttlClass();
            this.linear = linearStageClass();
        end
        
        function delete(this)
            this.smu.delete();
            this.laser.delete();
            this.hwplate.delete();
            this.powermeter.delete();
            this.ndfilters.delete();
            this.shutter.delete();
            this.linear.delete();
        end
        
        function beamWidthMeasure(this,testName,runNum)
            %%%get the beam width of the beam
            
            %%% zero the beam
            this.linear.setPosition(9);
            pause(1);
            
            %turn on laser
            this.laser.setCurrent(2.0);
            this.smu.setVoltage(0);
            this.hwplate.setAngle(0);
            this.shutter.ON();
            
            pos_start = 8.5; %mm
            pos_end = 9.5;
            pos_step = 0.01;
            
            posSweepPts = int32((pos_end-pos_start)/pos_step);
            powerArr = zeros(1,posSweepPts);
            posArr = zeros(1,posSweepPts);
            
            for i = 1:posSweepPts
               posArr(i) = pos_start + (pos_step * single(i-1));
            end
            
            for i = 1:posSweepPts
                this.linear.setPosition(posArr(i));
                powerArr(i)=this.powermeter.readPower();
                %update the posArr with the actual encorder position
                posArr(i) = this.linear.getPosition();
                pause(0.3);
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_posArr.mat',testName,runNum), 'posArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            %yyaxis right;
            plot(posArr, powerArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Power (W)');
            grid on;
            xlabel('Linear Stage Position [mm]');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            this.laser.setCurrent(0);
            this.shutter.OFF();
            
            %write to a 2D CSV file
            beamdata = [posArr(:) powerArr(:)];
            csvwrite(sprintf('%s_%i_beamwidth.txt',testName,runNum),beamdata);
                        
        end
        
        function HWTest(this,testName,runNum)
            %%%rotate the hwplate and orient the P polarization from laser
            
            %turn on laser
            this.laser.setCurrent(1.0);
            this.smu.setVoltage(0);
            
            ang_start=0;
            ang_end=90;
            ang_step=1;
            
            %save data
            angleSweepPts = int32((ang_end-ang_start)/ang_step);
            
            powerArr = zeros(1,angleSweepPts);
            angleArr = zeros(1,angleSweepPts);
            
            for i = 1:angleSweepPts
               angleArr(i) = ang_start + (ang_step * single(i-1));
            end
            
                        
            % orient the hw plate
            for i = 1:angleSweepPts
                this.hwplate.setAngle(angleArr(i));
                powerArr(i)=this.powermeter.readPower();
                pause(1);
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_angleArr.mat',testName,runNum), 'angleArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            %yyaxis right;
            semilogy(angleArr, powerArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Power (W)');
            grid on;
            xlabel('HW angle [deg]');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            this.laser.setCurrent(0);
        end
        
        function ND1Test(this,testName,runNum)
            %%% move the ND 1 filters and record the power
            nd1Arr = [0,-0.97,-1.91,-2.88,-3.98,-4.69];
            nd2Arr = [0,-0.17,-0.42,-0.68,-0.99,-1.92];
            nd1posArr = 1:length(nd1Arr);
            nd2posArr = 1:length(nd2Arr);
            powerArr = zeros(1,length(nd1Arr));
            
            %turn on laser
            this.laser.setCurrent(2.0);
            this.smu.setVoltage(0);
            
            %get NW plate to 45 degrees
            this.hwplate.setAngle(45);
            
            for i = 1:length(nd1Arr)
                this.ndfilters.moveND1(i);
                pause(5)
                powerArr(i)=this.powermeter.readPower();
            end
            
            %turn the laser off
            this.laser.setCurrent(0);
            
            %return hw plate to 0 degree
            this.hwplate.setAngle(0);
            
            save(sprintf('%s_%i_nd1posArr.mat',testName,runNum), 'nd1posArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            ndArr=log10(powerArr/powerArr(1));
            save('ND1.mat', 'ndArr');
            
            f1 = figure;
            sub_f1 = subplot(1,1,1);
            semilogy(nd1posArr, powerArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Power (W)');
            grid on;
            xlabel('ND1 Pos');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
            
        end
        
        function ND2Test(this,testName,runNum)
            %%% move the ND 2 filters and record the power
            nd1Arr = [0,1,2,3,4,5];
            nd2Arr = [0,0,0,0,0,0];
            nd1posArr = 1:length(nd1Arr);
            nd2posArr = 1:length(nd2Arr);
            powerArr = zeros(1,length(nd2Arr));
            
            %turn on laser
            this.laser.setCurrent(2.0);
            this.smu.setVoltage(0);

            %set angle to 45
            this.ndfilters.moveND1(1);
            this.hwplate.setAngle(45);
            
            for i = 1:length(nd2Arr)
                this.ndfilters.moveND2(i);
                pause(5)
                powerArr(i)=this.powermeter.readPower();
            end
            
            %turn the laser off
            this.laser.setCurrent(0);
            
            %turn hw to 0 degrees
            this.hwplate.setAngle(0);
            
            save(sprintf('%s_%i_nd2posArr.mat',testName,runNum), 'nd2posArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            ndArr=log10(powerArr/powerArr(1));
            save('ND2.mat', 'ndArr');
            
            f1 = figure;
            sub_f1 = subplot(1,1,1);
            semilogy(nd1posArr, powerArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Power (W)');
            grid on;
            xlabel('ND2 Pos');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
            
        end
        
        %%%IV sweep of the device
        function roughIV(this,testName,runNum)
            
            startBias = 10;
            endBias = 50;
            stepBias = 2;
            
           biasSweepPts = int32(abs((endBias-startBias)/stepBias));
            
            voltageArr = zeros(1,biasSweepPts);
            currArr = zeros(1,biasSweepPts);
                        
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end
            
             %set power
            %laserCurrent = 0;
            %this.laser.setCurrent(laserCurrent);
            this.smu.setCurrentLimit(0.01);
            this.shutter.ON();
            
            for i = 1:biasSweepPts
                this.smu.setVoltage(voltageArr(i));
                currArr(i)=this.smu.readCurrent();
                pause(1);
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            %yyaxis right;
            semilogy(voltageArr, currArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Current (A)');
            grid on;
            xlabel('Voltage (V)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            %this.laser.setCurrent(0);
            this.shutter.OFF();
            this.smu.setVoltage(0);
            
            %calculate gain M=(1-V/Vbr)^-n, n = 0.73
                        
        end
        
        %%IV fine
         %%%IV sweep of the device
        function fineIV(this,testName,runNum)
            
            startBias = 35;
            endBias = 45;
            stepBias = 0.1;
            
           biasSweepPts = int32(abs((endBias-startBias)/stepBias));
            
            voltageArr = zeros(1,biasSweepPts);
            currArr = zeros(1,biasSweepPts);
                        
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end
            
             %set power
            %laserCurrent = 0;
            %this.laser.setCurrent(laserCurrent);
            this.smu.setCurrentLimit(0.01);
            this.shutter.ON();
            
            for i = 1:biasSweepPts
                this.smu.setVoltage(voltageArr(i));
                currArr(i)=this.smu.readCurrent();
                pause(1);
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            %yyaxis right;
            semilogy(voltageArr, currArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Current (A)');
            grid on;
            xlabel('Voltage (V)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            %this.laser.setCurrent(0);
            this.shutter.OFF();
            this.smu.setVoltage(0);
            
            %calculate gain M=(1-V/Vbr)^-n, n = 0.73
                        
        end
        %%%%
        
         %%IV fine
         %%%IV sweep of the device
        function veryfineIV(this,testName,runNum)
            
            startBias = 40;
            endBias = 43;
            stepBias = 0.05;
            
           biasSweepPts = int32(abs((endBias-startBias)/stepBias));
            
            voltageArr = zeros(1,biasSweepPts);
            currArr = zeros(1,biasSweepPts);
                        
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end
            
             %set power
            %laserCurrent = 0;
            %this.laser.setCurrent(laserCurrent);
            this.smu.setCurrentLimit(0.001);
            this.shutter.ON();
            
            for i = 1:biasSweepPts
                this.smu.setVoltage(voltageArr(i));
                currArr(i)=this.smu.readCurrent();
                pause(1);
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            %yyaxis right;
            semilogy(voltageArr, currArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Current (A)');
            grid on;
            xlabel('Voltage (V)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            %this.laser.setCurrent(0);
            this.shutter.OFF();
            this.smu.setVoltage(0);
            
            %calculate gain M=(1-V/Vbr)^-n, n = 0.73
                        
        end
        
        
        
        %%%get current from the apd in realtime for alignment
        function apdAlign(this)
            startTime = 0;
            endTime = 100;
            stepTime = 0.25;
            
            timeSweepPts = int32(abs((endTime-startTime)/stepTime));
            timeArr = zeros(1,timeSweepPts);
            currArr = zeros(1,timeSweepPts);
            
            this.smu.setVoltage(41.2);
            figure;
            ylabel('APD Current (A)');
            grid on;
            xlabel('Time (s)');
            hold on;
            grid on;
            for i = 1:timeSweepPts
                currArr(i)=this.smu.readCurrent();
                timeArr(i)= (startTime + stepTime*i);
                pause(stepTime); %%%seconds
                plot(timeArr(1:i),currArr(1:i),'-');
                scatter(timeArr(1:i),currArr(1:i));
            end
            this.smu.setVoltage(41.2);
        end
        %%%
        
        %%%
        
        %%%get photocurrent from the apd in realtime for alignment
        function detectorAlign(this)
            startTime = 0;
            endTime = 100;
            stepTime = 0.25;
            
            timeSweepPts = int32(abs((endTime-startTime)/stepTime));
            timeArr = zeros(1,timeSweepPts);
            powerArr = zeros(1,timeSweepPts);
            
            figure;
            ylabel('PD Power (W)');
            grid on;
            xlabel('Time (s)');
            hold on;
            grid on;
            for i = 1:timeSweepPts
                powerArr(i)=this.powermeter.readPower();;
                timeArr(i)= (startTime + stepTime*i);
                pause(stepTime); %%%seconds
                plot(timeArr(1:i),powerArr(1:i),'-');
                scatter(timeArr(1:i),powerArr(1:i));
            end
            
        end
        %%%
        
        
        %%%%
        %%%
        function sweepPRF(this,testName,runNum)
            %prfArr = [10,20,30,40,50,100,150,200,250,300,500,1000];
            %prfArr = [10,100,1000];
            prfArr = [10,100,1000];
                            
            %current sweep
            startCurr = 2.0;
            endCurr = 3.2;
            stepCurr =0.2;
            
           currSweepPts = int32(abs((endCurr-startCurr)/stepCurr));
           currArr = zeros(1,currSweepPts);
           
            for i = 1:currSweepPts
               currArr(i) = startCurr + (stepCurr * single(i-1));
            end
            
            powerArr = zeros(length(prfArr),length(currArr));
           
            this.ndfilters.moveND1(1); 
            this.ndfilters.moveND2(1);
            this.hwplate.setAngle(0); %deg 0 is max
            this.shutter.ON();
            %%%%%%
            this.ndfilters.moveND1(1); %%CHECK!! ONLY for higher powers
            %%%%%%
            
            for i = 1:length(prfArr)
                this.laser.setPRF(prfArr(i));
                for j= 1:currSweepPts
                    this.laser.setCurrent(currArr(j));
                    powerArr(i,j)=this.powermeter.readPower();
                end
            end
            
         %plot figure and save data
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            save(sprintf('%s_%i_prfArr.mat',testName,runNum), 'prfArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            hold;
            %yyaxis right;
             for i = 1:length(prfArr)
                 cmd = sprintf("PRF=%i",prfArr(i));
                 plot(currArr, powerArr(i,:), 'DisplayName', cmd);
                 
             end
            legend
            ylabel('Average Power (W)');
            grid on;
            xlabel('Laser Current (A)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
          
            this.ndfilters.moveND1(1);
            this.laser.setCurrent(0);
            this.laser.setPRF(10);
                       
        end
        %%%
        
        
        
        
        %%%%%%%%
        %%Tune the system to deliver a known average power and peak power
        %%given the PRF and target power level
        function power = setAveragePowerDensity(this, targetPower, targetPRF)
            %%% shutter close
            %%% laser current settings are between 1 to 4 A
            this.laser.setCurrent(2.0);
            pdpower = this.powermeter.readPower();
            if (pdpower < targetPower*1.1) && (pdpower > targetpower*0.9) %%% within 10%
            end
        end
        
        
        %%% sweep the PRF from 10 - 1000 KHz while sweeping IV 
        %%% keeping the average power nearly the same
        function sweepPRFandIV(this,testName,runNum)
            prfArr = [10,100,1000];%,200,500,1000];
                  
            startBias = 40.0;
            endBias = 40.4;
            stepBias =0.2;
            
            biasSweepPts = int32(abs((endBias-startBias)/stepBias));
            
            voltageArr = zeros(1,biasSweepPts);
            currArr = zeros(1,biasSweepPts);
            
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end
            
            currArr = zeros(length(prfArr),length(currArr));
            
            %set power
            this.ndfilters.moveND1(1);
            this.ndfilters.moveND2(1);
            this.hwplate.setAngle(0); %%check the excel sheet 4,
            this.shutter.ON();
                        
            for i = 1:length(prfArr)
               this.smu.setVoltage(0);
               this.laser.setPRF(prfArr(i));
               this.laser.setCurrent(2); %%% CHANGE THIS
               pause(10);
                for j = 1:biasSweepPts
                	this.smu.setVoltage(voltageArr(j));
                    currArr(i,j)=this.smu.readCurrent();
                    pause(1);
                end
            end
            
            this.laser.setCurrent(0);
            this.hwplate.setAngle(0);
            this.laser.setPRF(10);
            this.smu.setVoltage(0);
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_prfArr.mat',testName,runNum), 'prfArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);
            
            f1 = figure;
            sub_f1 = subplot(1,1,1);
            hold;
            %yyaxis right;
             for i = 1:length(prfArr)
                 cmd = sprintf("PRF=%i",prfArr(i));
                 semilogy(voltageArr, currArr(i,:), 'DisplayName', cmd);
             end
             
            legend;
            ylabel('Current (A)');
            grid on;
            xlabel('Voltage (V)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
        end
        
        
        %%%sweep prf and laser current keeping APD at fixed bias
        function sweepPRFandPoweratFixedBias(this,testName,runNum)
            prfArr = [1000];%,10];%,50,100,1000];
                  
            %laser current sweep
            startCurr = 5.0;
            endCurr = 6.2;
            stepCurr =0.2;
            
           lasercurrSweepPts = int32(abs((endCurr-startCurr)/stepCurr));
           lasercurrArr = zeros(1,lasercurrSweepPts);
           
            for i = 1:lasercurrSweepPts
               lasercurrArr(i) = startCurr + (stepCurr * single(i-1));
            end
            
            currArr = zeros(length(prfArr),length(lasercurrArr));
            
            %set power
            this.ndfilters.moveND1(1);
            this.ndfilters.moveND2(1);
            this.hwplate.setAngle(0); %%check the excel sheet 4, 
            this.shutter.ON();
            
            %%%
            this.smu.setCurrentLimit(0.05); %0.05 A
            %%%
            
            % voltage at GAIN=10, V = 42.2
            %increase bias to setpoint
            fprintf("increasing APD bias to M=10 setpoint..\n");
            %for i = 1:0.2:40.4
             %   this.smu.setVoltage(i);
            %end
            
            this.smu.setVoltage(41.2); %%%CHANGE THIS
            
            fprintf("APD bias at to M=10 setpoint..\n");
            
            for i = 1:length(prfArr)
                fprintf("set laser PRF = %i\n",prfArr(i));
               this.laser.setPRF(prfArr(i));
               for j = 1:lasercurrSweepPts
                    fprintf("set laser Current = %f\n",lasercurrArr(j));
                   this.laser.setCurrent(lasercurrArr(j));
                   this.shutter.ON()
                   pause(5);
                   currArr(i,j)=this.smu.readCurrent();
                   pause(2);
                    
                    %%% let the device cool down under zero laser current
                    %this.laser.setCurrent(0.0);
                   this.shutter.OFF()
                   pause(5);
                    %%% added 01/12/22 to cool down 
                end
            end
            
            this.laser.setCurrent(0);
            this.hwplate.setAngle(0);
            this.laser.setPRF(10);
            this.smu.setVoltage(0);
            this.smu.setCurrentLimit(0.001); 
            
            %plot figure and save data
            save(sprintf('%s_%i_lasercurrArr.mat',testName,runNum), 'lasercurrArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_prfArr.mat',testName,runNum), 'prfArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);
            
            f1 = figure;
            sub_f1 = subplot(1,1,1);
            hold;
            %yyaxis right;
             for i = 1:length(prfArr)
                 cmd = sprintf("PRF=%i KHz",prfArr(i));
                 semilogy(lasercurrArr, currArr(i,:), 'DisplayName', cmd);
             end
             
            legend;
            ylabel('APD Current (A)');
            grid on;
            xlabel('Laser Current (A)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
        end
    end
end