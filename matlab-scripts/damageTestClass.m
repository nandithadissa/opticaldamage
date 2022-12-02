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
        
        %%%%
        function beamWidthMeasure(this,testName,runNum)
            %%%get the beam width of the beam
            
            %%% zero the beam
            this.linear.setPosition(13.25);
            pause(1);
            
            %turn on laser
            %this.laser.setPRF(1000);
            %this.laser.setCurrent(2);
            %this.smu.setVoltage(0);
            %this.hwplate.setAngle(42);
            this.shutter.ON();
            
            pos_start = 13.5; %mm
            pos_end = 14.5;
            pos_step = 0.05;
            
            posSweepPts = int32((pos_end-pos_start)/pos_step);
            powerArr = zeros(1,posSweepPts);
            posArr = zeros(1,posSweepPts);
            
            for i = 1:posSweepPts
               posArr(i) = pos_start + (pos_step * single(i-1));
            end

            figure;
            ylabel('PD power (W)');
            grid on;
            xlabel('Linear Stage Position [mm]')
            hold on;
            grid on;
            
            for i = 1:posSweepPts
                this.linear.setPosition(posArr(i));
                powerArr(i)=this.powermeter.readPower();
                %update the posArr with the actual encorder position
                posArr(i) = this.linear.getPosition();
                plot(posArr(1:i), powerArr(1:i), 'r.-');
                scatter(posArr(1:i), powerArr(1:i));
                pause(0.3);

            end
            
            %plot figure and save data
            save(sprintf('%s_%i_posArr.mat',testName,runNum), 'posArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %%yyaxis right;
            %plot(posArr, powerArr, 'r.-', 'DisplayName', 'Power');
            %ylabel('Power (W)');
            %grid on;
            %xlabel('Linear Stage Position [mm]');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            %this.laser.setCurrent(0);
            %this.hwplate.setAngle(0);
            this.shutter.OFF();
            
            %write to a 2D CSV file
            beamdata = [posArr(:) powerArr(:)];
            csvwrite(sprintf('%s_%i_beamwidth.txt',testName,runNum),beamdata);
                        
        end
        %%%%

        %%% get the beamwidth 
        function cwBeamWidthMeasure(this,testName,runNum)
            %%%get the beam width of the beam
            
            %%% zero the beam
            this.linear.setPosition(13.0);
            pause(1);
            

            %turn on laser
            %this.laser.setCW;
            %this.laser.setCurrent(1.8);
            
                       
            pos_start = 14.8; %mm
            pos_end = 16.0;
            pos_step = 0.05;
            
            posSweepPts = int32((pos_end-pos_start)/pos_step) + 1;
            powerArr = zeros(1,posSweepPts);
            posArr = zeros(1,posSweepPts);
            
            for i = 1:posSweepPts
               posArr(i) = pos_start + (pos_step * single(i-1));
            end

            figure;
            ylabel('PD power (W)');
            grid on;
            xlabel('Linear Stage Position [mm]')
            hold on;
            grid on;
            
            this.shutter.ON();

            for i = 1:posSweepPts
                this.linear.setPosition(posArr(i));
                powerArr(i)=this.powermeter.readPower();
                %update the posArr with the actual encorder position
                posArr(i) = this.linear.getPosition();
                plot(posArr(1:i), powerArr(1:i), 'r.-');
                scatter(posArr(1:i), powerArr(1:i));
                pause(0.3);

            end
            
            %%% turn the shutter off
            this.shutter.OFF();
            
            %plot figure and save data
            save(sprintf('%s_%i_posArr.mat',testName,runNum), 'posArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %%yyaxis right;
            %plot(posArr, powerArr, 'r.-', 'DisplayName', 'Power');
            %ylabel('Power (W)');
            %grid on;
            %xlabel('Linear Stage Position [mm]');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            %this.laser.setCurrent(0);
            %this.laser.setPulse;
            %this.laser.setPRF(10);
            
            
            %write to a 2D CSV file
            beamdata = [posArr(:) powerArr(:)];
            csvwrite(sprintf('%s_%i_beamwidth.txt',testName,runNum),beamdata);
                        
        end
        %%%%
        
        %%%beamwidth measure using the 1x4 APD as the source
        function beamWidthMeasureUsing1by4APD(this,testName,runNum)
            %%%get the beam width of the beam
            
            %%% zero the beam
            this.linear.setPosition(4);
            pause(1);

            
            %turn on laser
            this.laser.setPRF(1000);
            this.laser.setCurrent(1.8);
            this.smu.setVoltage(44.2); %%change this if needed
            this.smu.setCurrentLimit(0.001);
            this.hwplate.setAngle(0);
            this.shutter.ON();
            
            pos_start = 5.2; %mm
            pos_end = 5.4;
            pos_step = 0.005;
            
            posSweepPts = int32((pos_end-pos_start)/pos_step);
            powerArr = zeros(1,posSweepPts);
            posArr = zeros(1,posSweepPts);
            
            for i = 1:posSweepPts
               posArr(i) = pos_start + (pos_step * single(i-1));
            end
            
            figure;
            grid on;
            ylabel('1x4 APD photocurrent (A)');
            grid on;
            xlabel('Linear Stage Position [mm]');
            hold on;
            grid on;
            
            
            for i = 1:posSweepPts
                this.linear.setPosition(posArr(i));
                powerArr(i)=this.smu.readCurrent();
                %update the posArr with the actual encorder position
                posArr(i) = this.linear.getPosition();
                plot(posArr(1:i), powerArr(1:i));
                scatter(posArr(1:i), powerArr(1:i));
                pause(0.3);
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_posArr.mat',testName,runNum), 'posArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %yyaxis right;
            %plot(posArr, powerArr, 'r.-', 'DisplayName', 'Power');
            %ylabel('1x4 APD photocurrent (A)');
            %grid on;
            %xlabel('Linear Stage Position [mm]');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            this.laser.setCurrent(0);
            this.smu.setVoltage(0);
            %this.shutter.OFF();
            
            %write to a 2D CSV file
            beamdata = [posArr(:) powerArr(:)];
            csvwrite(sprintf('%s_%i_beamwidth.txt',testName,runNum),beamdata);
                        
        end
            
        function hwPowerCalibration(this,testName,runNum)
            %%%rotate the hwplate and calibrate the power at each angle
            
            %this.laser.setCW; %% CW Operation

            %set the PRF on laser
            this.laser.setPulse;
            this.laser.setPRF(1000); % for pulse operation
            this.shutter.OFF();
            
            %turn on laser
            this.laser.setCurrent(3);
            this.smu.setVoltage(0);
            %pause(60) %% let the laser stabilize

            %turn on the ND filter to operate below saturation
            this.ndfilters.moveND1(3); %%% CHANAGE THIS
            ndFactor = 62.4; %%% for ND1=3 CHECK!! if ND1 and ND2 are not at 1 change these accordingly
                            %%% ND3 - 595
           
            ang_start=45;
            ang_end=0;
            ang_step=-1; %%% -0.5

            this.hwplate.setAngle(ang_start);
            
            
            %save data
            angleSweepPts = int32(abs((ang_end-ang_start)/ang_step))+1;
            
            powerArr = zeros(1,angleSweepPts);
            angleArr = zeros(1,angleSweepPts);
            
            for i = 1:angleSweepPts
               angleArr(i) = ang_start + (ang_step * single(i-1));
            end
            
            %create figure
            figure;
            ylabel('Average power (W)');
            grid on;
            xlabel('HW plate angle (Degree)');
            hold on;
            grid on;

            this.shutter.ON();
                        
            % orient the hw plate
            for i = 1:angleSweepPts
                this.hwplate.setAngle(angleArr(i));
                powerArr(i)=ndFactor*this.powermeter.readPower(); %%% nd filter factor is included %%%
                pause(1);
                plot(angleArr(1:i),powerArr(1:i),'--');
                scatter(angleArr(1:i),powerArr(1:i));
            end
            
            this.shutter.OFF();

            %plot figure and save data
            save(sprintf('%s_%i_angleArr.mat',testName,runNum), 'angleArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %%yyaxis right;
            %semilogy(angleArr, powerArr, 'r.-', 'DisplayName', 'Power');
            %ylabel('Power (W)');
            %grid on;
            %xlabel('HW angle [deg]');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            this.laser.setCurrent(3);
            this.hwplate.setAngle(0);
            this.ndfilters.moveND1(1); %%% CHANAGE THIS
            this.laser.setPulse;    %% pulse mode should be kept default
            
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
            
            this.smu.setCurrentLimit(0.0001);

            startBias =20;
            endBias = 60;
            stepBias = 5;
            
           biasSweepPts = int32(abs((endBias-startBias)/stepBias)) + 1;
            
            voltageArr = zeros(1,biasSweepPts);
            currArr = zeros(1,biasSweepPts);
                        
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end
            
             %set power
            %laserCurrent = 0;
            %this.laser.setCurrent(laserCurrent);
            %this.smu.setCurrentLimit(0.00001);
            this.shutter.OFF(); %%% CHANGE
            
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

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% find gain of a sensor with low optical bias
          %%%IV sweep of the device
          function findResponsivityandGain(this,testName,runNum)
            
            this.smu.setCurrentLimit(0.0001);

            startBias =20;
            endBias = 60;
            stepBias = 5;

           %%%%%%%%%%%%%%%%%%%%%%%
           irradiance = zeros(1,1);
           irradiance(1) = 1; % THIS HAS TO BE MEASURED FIRST [W/cm2]
           %%% KEEP THE OPTICAL INTENSITY THE SAME AND DO NOT CHANGE IT
           deviceArea = 6160E-8; %[cm2]
           %%%%%%%%%%%%%%%%%%%%%%%

           biasSweepPts = int32(abs((endBias-startBias)/stepBias)) + 1;
            
            voltageArr = zeros(1,biasSweepPts);
            darkcurrArr = zeros(1,biasSweepPts);
            lightcurrArr = zeros(1,biasSweepPts);
            netcurrArr = zeros(1,biasSweepPts);
            gainArr = zeros(1,biasSweepPts);
            responsivityArr = zeros(1,biasSweepPts);
                        
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end

            this.shutter.OFF(); %%% CHANGE

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            yyaxis right;
            ylabel('Responsivity [A/W]');
            yyaxis left;
            ylabel('M');
            grid on;
            grid minor;
            xlabel('Voltage (V)');
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            
            for i = 1:biasSweepPts
                this.smu.setVoltage(voltageArr(i));
                pause(0.1); %% SETTLING TIME
                this.shutter.OFF(); %%% TAKE DARK MEASUREMENT
                pause(0.2);
                darkcurrArr(i)=this.smu.readCurrent();
                this.shutter.ON(); %%% TAKE LIGHT MEASUREMENT
                pause(0.2);
                lightcurrArr(i)=this.smu.readCurrent();
                netcurrArr(i) = lightcurrArr(i)-darkcurrArr(i);
                gainArr(i) = netcurrArr(i)/netcurrArr(1); %% ASSUME M=1 is i=1;
                responsivityArr(i) = netcurrArr(i)/(deviceArea*irradiance);
                yyaxis left;
                plot(voltageArr(1:i),gainArr(1:i));
                scatter(voltageArr(1:i),gainArr(1:i));
                yyaxis right;
                plot(voltageArr(1:i),responsivityArr(1:i));
                scatter(voltageArr(1:i),responsivityArr(1:i));
                pause(0.5);
                this.shutter.OFF();
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_darkcurrArr.mat',testName,runNum), 'darkcurrArr');
            save(sprintf('%s_%i_lightcurrArr.mat',testName,runNum), 'lightcurrArr');
            save(sprintf('%s_%i_netcurrArr.mat',testName,runNum), 'netcurrArr');
            save(sprintf('%s_%i_gainArr.mat',testName,runNum), 'gainArr');
            save(sprintf('%s_%i_responsivityArr.mat',testName,runNum), 'responsivityArr');
            save(sprintf('%s_%i_irradiance.mat',testName,runNum), 'irradiance');

            yyaxis right;
            ylabel('Responsivity [A/W]');
            yyaxis left;
            ylabel('M');
            grid on;
            grid minor;
            xlabel('Voltage (V)')
           
            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %%yyaxis right;
            %semilogy(voltageArr, currArr, 'r.-', 'DisplayName', 'Power');
            %ylabel('Current (A)');
            %grid on;
            %xlabel('Voltage (V)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            %this.laser.setCurrent(0);
            this.shutter.OFF();
            this.smu.setVoltage(0);
            
            %calculate gain M=(1-V/Vbr)^-n, n = 0.73
                        
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% iv recoding the temp
        %%%IV sweep of the device
        function roughIVwithTemp(this,testName,runNum)
            
            this.smu.setCurrentLimit(0.0001);

            %%% temp sensor
            ted3510=TED3510_PCB;
            ted3510.connect;

            startBias =10;
            endBias = 60;
            stepBias = 5;
            
           biasSweepPts = int32(abs((endBias-startBias)/stepBias)) + 1;
            
            voltageArr = zeros(1,biasSweepPts);
            currArr = zeros(1,biasSweepPts);
            tempArr = zeros(1,biasSweepPts);

                        
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end
            
             %set power
            %laserCurrent = 0;
            %this.laser.setCurrent(laserCurrent);
            %this.smu.setCurrentLimit(0.00001);
            this.shutter.OFF(); %%% CHANGE
       
             set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            %figure;
            %ylabel('Current (A)');
            %grid on;
            %xlabel('Voltage (V)');
            %grid(gca,'minor');
            %hx = axes;


            for i = 1:biasSweepPts
                this.smu.setVoltage(voltageArr(i));
                currArr(i)=this.smu.readCurrent();
                tempArr(i)=ted3510.tempC;
                pause(1);
                %%%plot
                %semilogy(voltageArr(1:i), currArr(1:i));
                %scatter(voltageArr(1:i), currArr(1:i));
                %hx.YScale = 'log';
            end
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_tempArr.mat',testName,runNum), 'tempArr');
                       

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            %%yyaxis right;
            semilogy(voltageArr, currArr, 'r.-', 'DisplayName', 'Power');
            ylabel('Current (A)');
            grid on;
            xlabel('Voltage (V)');
            title(sprintf('IV at temp %2.1f [C]',mean(tempArr)));
            grid(gca,'minor');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                        
            %turn the laser off
            %this.laser.setCurrent(0);
            this.shutter.OFF();
            this.smu.setVoltage(0);
            
            %calculate gain M=(1-V/Vbr)^-n, n = 0.73
                        
        end
        
        %%%fine IV sweep of the device
        function fineIV(this,testName,runNum)
            
            this.smu.setCurrentLimit(0.0001);

            startBias = 52;
            endBias = 54;
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
            this.smu.setCurrentLimit(0.0001);
            this.shutter.OFF();
            
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
       
         %%%very fine IV sweep of the device
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
        
        %%%%
        %%% plot temp ramp
        %%%get current from the apd in realtime for alignment
        function plotTemp(this)
            startTime = 0;
            endTime = 100;
            stepTime = 0.1;
            
            timeSweepPts = int32(abs((endTime-startTime)/stepTime));
            timeArr = zeros(1,timeSweepPts);
            tempArr = zeros(1,timeSweepPts);

            ted3510=TED3510_PCB;
            ted3510.connect;
            
           
            figure;
            ylabel('Temp (C)');
            grid on;
            xlabel('Time (s)');
            hold on;
            grid on;
            for i = 1:timeSweepPts
                tempArr(i)=ted3510.tempC;;
                timeArr(i)= (startTime + stepTime*i);
                pause(stepTime); %%%seconds
                plot(timeArr(1:i),tempArr(1:i),'--');
                scatter(timeArr(1:i),tempArr(1:i));
            end
            
        end
        %%%
                
        %%%get current from the apd in realtime for alignment
        function apdAlign(this)
            startTime = 0;
            endTime = 500;
            stepTime = 0.1;
            
            timeSweepPts = int32(abs((endTime-startTime)/stepTime));
            timeArr = zeros(1,timeSweepPts);
            currArr = zeros(1,timeSweepPts);
            
            %this.smu.setVoltage(30.0);  %%%% CHANGE %%% %44.6 
            %this.smu.setCurrentLimit(0.00001); %for strong signal quench measurements

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
                plot(timeArr(1:i),currArr(1:i),'--');
                scatter(timeArr(1:i),currArr(1:i));
            end
            this.smu.setVoltage(0);
        end
        %%%
              
        %%%get photocurrent from the apd in realtime for alignment
        function detectorAlign(this)
            startTime = 0;
            endTime = 100;
            stepTime = 0.1;%0.25;
            
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
                powerArr(i)=this.powermeter.readPower();
                timeArr(i)= (startTime + stepTime*i);
                pause(stepTime); %%%seconds
                plot(timeArr(1:i),powerArr(1:i),'-');
                scatter(timeArr(1:i),powerArr(1:i));
            end
            
        end
        %%%
        
        %%%
        function sweepPRF(this,testName,runNum)
            %prfArr = [10,20,30,40,50,100,150,200,250,300,500,1000];
            prfArr = [10,100,1000];
            %prfArr = [100];
                            
            %current sweep
            startCurr = 1.0;
            endCurr = 5.2;
            stepCurr =0.1;
            
           currSweepPts = int32(abs((endCurr-startCurr)/stepCurr));
           currArr = zeros(1,currSweepPts);
           
            for i = 1:currSweepPts
               currArr(i) = startCurr + (stepCurr * single(i-1));
            end
            
            powerArr = zeros(length(prfArr),length(currArr));
           
            this.ndfilters.moveND1(1);  %%CHECK!! ONLY for higher powers
            
            this.ndfilters.moveND2(1);
            this.hwplate.setAngle(0); %deg 0 is max
            this.shutter.ON();
                        
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
            this.laser.setPRF(250);
                       
        end
        %%%

       %%%
       %%%
       % measured the optical power in CW at different pump current
       function cwCalibration(this,testName,runNum)
           %calibrate the power in CW mode for APD linearty tests 091622
            this.laser.setCW;
                                     
            %current sweep
            startCurr = 2.0;
            endCurr = 5.0;
            stepCurr =0.2;
            ndFactor = 74; %%% for ND1=3 CHECK!! if ND1 and ND2 are not at 1 change these accordingly
            
           currSweepPts = int32(abs((endCurr-startCurr)/stepCurr)) + 1;
           currArr = zeros(1,currSweepPts);
           
            for i = 1:currSweepPts
               currArr(i) = startCurr + (stepCurr * single(i-1));
            end
            
            powerArr = zeros(1,currSweepPts);
           
            this.ndfilters.moveND1(3);  %%CHECK!! ONLY for higher powers
            
            this.ndfilters.moveND2(1);
            this.hwplate.setAngle(0); %deg 0 is max
            this.shutter.ON();
                       
            %%% set the current the first value and stabilize
            this.laser.setCurrent(currArr(1));
            pause(60);


           for j= 1:currSweepPts
                this.laser.setCurrent(currArr(j));
                powerArr(j)=ndFactor*this.powermeter.readPower();
                
           end
            
         %plot figure and save data
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_powerArr.mat',testName,runNum), 'powerArr');
                      
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);

            f1 = figure;
            sub_f1 = subplot(1,1,1);
            hold;
            %yyaxis right;
            plot(currArr, powerArr);
            ylabel('Average Power (W)');
            grid on;
            xlabel('Laser Current (A)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
          
            this.ndfilters.moveND1(1); %% RESTORE the NDFilters
            this.laser.setCurrent(0);
            %this.laser.setPulse;
            %this.laser.setPRF(10);
                     
        end
        %%%
       %%%
        
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
            prfArr = [400];%,10];%,50,100,1000];
                  
            %laser current sweep
            startCurr = 1.0;
            endCurr = 3.2;
            stepCurr =0.1;
            
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
            
            %%%%%%%%%%%%%%%%%%%
            this.ndfilters.moveND1(1); %%%%%%Check this
            %%%%%%%%%%%%%%%%%%%%%
            
            %%%
            this.smu.setCurrentLimit(0.05); %0.05 A #SPECIAL CASE#
            %%%
            
            % voltage at GAIN=10, V = 42.2
            %increase bias to setpoint
            fprintf("increasing APD bias to M=10 setpoint..\n");
            %for i = 1:0.2:40.4
             %   this.smu.setVoltage(i);
            %end
            
            this.smu.setVoltage(44.6); %%%CHANGE THIS
            
            fprintf("APD bias at to M=10 setpoint..\n");
            
            %create figure
            figure;
            ylabel('APD Current (A)');
            grid on;
            xlabel('Laser Current (A)');
            hold on;
            grid on;
            
           
                 
            
            for i = 1:length(prfArr)
                fprintf("set laser PRF = %i\n",prfArr(i));
               this.laser.setPRF(prfArr(i));
               cmd = sprintf("PRF=%i KHz",prfArr(i));
               for j = 1:lasercurrSweepPts
                    fprintf("set laser Current = %f\n",lasercurrArr(j));
                   this.laser.setCurrent(lasercurrArr(j));
                   this.shutter.ON()
                   pause(5);
                   currArr(i,j)=this.smu.readCurrent();
                   pause(2);
                   
                   %plot
                   semilogy(lasercurrArr(1:j), currArr(i,1:j), 'DisplayName', cmd);
                   scatter(lasercurrArr(1:j), currArr(i,1:j));
                   %plot
                   
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
            
            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %hold;
            %yyaxis right;
             %for i = 1:length(prfArr)
              %   cmd = sprintf("PRF=%i KHz",prfArr(i));
              %   semilogy(lasercurrArr, currArr(i,:), 'DisplayName', cmd);
             %end
             
            %legend;
            
            %ylabel('APD Current (A)');
            %grid on;
            %xlabel('Laser Current (A)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
        end

        %%% get the damage threshold smoothly moving the hwplate
        %%% fix a current and them move from 45 to 90 progressively
         %%%sweep prf and laser current keeping APD at fixed bias
         function sweepPRFandPoweratFixedBiasUsingHWplate(this,testName,runNum)
            prfArr = [1000];%,10];%,50,100,1000];
                  
            this.laser.setPulse;

            %laser current sweep is fixed
            startCurr = 3.0;
           
            ang_start=45;
            ang_end=0;
            ang_step=-5;
            
            %save data
            
            angleSweepPts = int32(abs((ang_end-ang_start)/ang_step)) + 1;
            
            powerArr = zeros(1,angleSweepPts);
            angleArr = zeros(1,angleSweepPts);
            
            for i = 1:angleSweepPts
               angleArr(i) = ang_start + (ang_step * single(i-1));
            end
            
                      
            % orient the hw plate
            this.hwplate.setAngle(ang_start);
                    
            hwangleArr = zeros(length(prfArr),length(angleArr));
            
            %set power
            this.ndfilters.moveND1(1); %%% CHECK THIS
            this.ndfilters.moveND2(1);
            this.shutter.OFF();
            
                  
            %%%
            this.smu.setCurrentLimit(0.05); %0.05 A #SPECIAL CASE#
            %%%
            
            % voltage at GAIN=10, V = 42.2
            %increase bias to setpoint
            fprintf("increasing APD bias to M=10 setpoint..\n");
            %for i = 1:0.2:40.4
             %   this.smu.setVoltage(i);
            %end
            
            %%%%%%%%%%%%%%%%%%%%%%%%
            this.smu.setVoltage(50.0); %%% LASER COMPONENTS APD. CHANGE THIS %%% EXCELITAS = 53 V
            %%%%%%%%%%%%%%%%%%%%%%%%%%

            fprintf("APD bias at to M=10 setpoint..\n");
            
            %create figure
            figure;
            ylabel('APD Current (A)');
            grid on;
            xlabel('HW plate angle (Degree)');
            hold on;
            grid on;
                     
             
            for i = 1:length(prfArr)
                fprintf("set laser PRF = %i\n",prfArr(i));
               this.laser.setPRF(prfArr(i));
               cmd = sprintf("PRF=%i KHz",prfArr(i));
               this.laser.setCurrent(startCurr);
               fprintf("set laser Current = %f\n",startCurr);
               pause(5);
               for j = 1:angleSweepPts
                   fprintf("set hw angle = %f\n",angleArr(j));
                   this.hwplate.setAngle(angleArr(j));
                   
                   this.shutter.ON();
                   pause(1);
                   hwangleArr(i,j)=this.smu.readCurrent();
                   pause(1);
                   
                   %plot
                   semilogy(angleArr(1:j), hwangleArr(i,1:j), 'DisplayName', cmd);
                   scatter(angleArr(1:j), hwangleArr(i,1:j));
                   %plot
                   
                    %%% let the device cool down under zero laser current
                    %this.laser.setCurrent(0.0);
                   this.shutter.OFF();
                   pause(5);
                    %%% added 01/12/22 to cool down 

                    %%%% added 04/26/22 check if device is dead at 10-V
                    this.smu.setVoltage(40.0);
                    this.smu.readCurrent()
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    this.smu.setVoltage(50); %%%%%%%% CHANGE THIS
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    pause(1);
                    %%%%


                end
            end
            
            this.laser.setCurrent(0);
            this.hwplate.setAngle(0);
            this.laser.setPRF(1000);
            this.smu.setVoltage(0);
            this.smu.setCurrentLimit(0.001); 
            
            %plot figure and save data
            save(sprintf('%s_%i_angleArr.mat',testName,runNum), 'angleArr');
            save(sprintf('%s_%i_hwangleArr.mat',testName,runNum), 'hwangleArr');
            save(sprintf('%s_%i_prfArr.mat',testName,runNum), 'prfArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);
            
            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %hold;
            %yyaxis right;
             %for i = 1:length(prfArr)
              %   cmd = sprintf("PRF=%i KHz",prfArr(i));
              %   semilogy(lasercurrArr, currArr(i,:), 'DisplayName', cmd);
             %end
             
            %legend;
            
            %ylabel('APD Current (A)');
            %grid on;
            %xlabel('Laser Current (A)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
         end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% damage threshold at TEMP
         %%% get the damage threshold smoothly moving the hwplate
        %%% fix a current and them move from 45 to 90 progressively
         %%%sweep prf and laser current keeping APD at fixed bias
         function sweepPRFandPoweratFixedBiasUsingHWplateWithTemp(this,testName,runNum)
            
            ted3510=TED3510_PCB;
            ted3510.connect; 
             
            prfArr = [1000];%,10];%,50,100,1000];
                  
            this.laser.setPulse;

            %laser current sweep is fixed
            startCurr = 3.0;
           
            ang_start=45;
            ang_end=0;
            ang_step=-1;
            
            %save data
            
            angleSweepPts = int32(abs((ang_end-ang_start)/ang_step)) + 1;
            
            powerArr = zeros(1,angleSweepPts);
            angleArr = zeros(1,angleSweepPts);
            
            
            for i = 1:angleSweepPts
               angleArr(i) = ang_start + (ang_step * single(i-1));
            end
            
                      
            % orient the hw plate
            this.hwplate.setAngle(ang_start);
                    
            hwangleArr = zeros(length(prfArr),length(angleArr));
            tempArr = zeros(length(prfArr),length(angleArr));
            
            
            %set power
            this.ndfilters.moveND1(1); %%% CHECK THIS
            this.ndfilters.moveND2(1);
            this.shutter.OFF();
            
                  
            %%%
            this.smu.setCurrentLimit(1); %0.05 A #SPECIAL CASE#
            %%%
            
            % voltage at GAIN=10, V = 42.2
            %increase bias to setpoint
            fprintf("increasing APD bias to M=10 setpoint..\n");
            %for i = 1:0.2:40.4
             %   this.smu.setVoltage(i);
            %end
            
            %%%%%%%%%%%%%%%%%%%%%%%%
            this.smu.setVoltage(53.3); %%% LASER COMPONENTS APD. CHANGE THIS %%% EXCELITAS = 53 V 44.6 1x4
            %%%%%%%%%%%%%%%%%%%%%%%%%%

            fprintf("APD bias at to M=10 setpoint..\n");
            
            %create figure
            figure;
            ylabel('APD Current (A)');
            grid on;
            xlabel('HW plate angle (Degree)');
            hold on;
            grid on;
                     
             
            for i = 1:length(prfArr)
                fprintf("set laser PRF = %i\n",prfArr(i));
               this.laser.setPRF(prfArr(i));
               cmd = sprintf("PRF=%i KHz",prfArr(i));
               this.laser.setCurrent(startCurr);
               fprintf("set laser Current = %f\n",startCurr);
               pause(5);
               for j = 1:angleSweepPts
                   fprintf("set hw angle = %f\n",angleArr(j));
                   this.hwplate.setAngle(angleArr(j));
                   
                   this.shutter.ON();
                   pause(1);
                   hwangleArr(i,j)=this.smu.readCurrent();
                   pause(1);

                   %%% read temp
                   tempArr(i,j)=ted3510.tempC;
                   fprintf("Temp = %f\n",tempArr(i,j));

                   %plot
                   semilogy(angleArr(1:j), hwangleArr(i,1:j), 'DisplayName', cmd);
                   scatter(angleArr(1:j), hwangleArr(i,1:j));
                   %plot
                   
                    %%% let the device cool down under zero laser current
                    %this.laser.setCurrent(0.0);
                   this.shutter.OFF();
                   pause(5);
                    %%% added 01/12/22 to cool down 

                    %%%% added 04/26/22 check if device is dead at 10-V
                    this.smu.setVoltage(10.0);
                    this.smu.readCurrent()
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    this.smu.setVoltage(53.3); %%%%%%%% CHANGE THIS
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    pause(1);
                    %%%%


                end
            end

           
            
            this.laser.setCurrent(0);
            this.hwplate.setAngle(0);
            this.laser.setPRF(1000);
            this.smu.setVoltage(0);
            this.smu.setCurrentLimit(0.0001); 
            
            %plot figure and save data
            save(sprintf('%s_%i_angleArr.mat',testName,runNum), 'angleArr');
            save(sprintf('%s_%i_hwangleArr.mat',testName,runNum), 'hwangleArr');
            save(sprintf('%s_%i_tempArr.mat',testName,runNum), 'tempArr');
            save(sprintf('%s_%i_prfArr.mat',testName,runNum), 'prfArr');
            
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 22);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 22);
            
            %f1 = figure;
            %sub_f1 = subplot(1,1,1);
            %hold;
            %yyaxis right;
             %for i = 1:length(prfArr)
              %   cmd = sprintf("PRF=%i KHz",prfArr(i));
              %   semilogy(lasercurrArr, currArr(i,:), 'DisplayName', cmd);
             %end
             
            %legend;
            
            %ylabel('APD Current (A)');
            %grid on;
            %xlabel('Laser Current (A)');

             mean(mean(tempArr))

            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
        end

    
        %%%%%
        % sweep iv to find photocurrent 
        function sweepIVunderCW(this,testName,runNum)
            
           %%% HW angle array
           hwAngleArr = [45,45,35,35,25];%,35,0];       % all the angles - power for hw array is found from calibration data - 2A

             
           cwPowerArr = [8.53E-03,7.73E-02,3.34E-01,3.03E+00,1.26E+01]%,8.72E-01,1.01E+01]; % W/cm2 at 2A with ND1 = POS 1

                      
           deviceArea = 5.02655E-05;% EXCELITAS  %6160E-8;  % 140 x 44 um2 1x4 device area. The optical power is overfilling the sensor



            %%% change the ND filteras along with the HW angle for higher
            %%% dynamic range
            nd1posArr = [2,1,2,1,1]; %2A

            %%%%

            this.shutter.OFF;

            %%% set CW
            %this.laser.setCW;
            
            %%% set optical conditions
            %this.laser.setCurrent(2);             %%%% CHECK THIS VALUE

            this.hwplate.setAngle(hwAngleArr(1)); %%%% Change this
            this.ndfilters.moveND1(nd1posArr(1)); %%% First test ndFactor = 55.39
            this.ndfilters.moveND2(1);

            %pause(60); %% warm up the laser

                
            startBias = 50.0;%50;%43.0;%50; %50.0;
            endBias =  52.4;%52.2;%47.0;%54.0; %52.0;
            stepBias = 0.2;;%0.25; %0.2; %0.1;
            
            biasSweepPts = int32(abs((endBias-startBias)/stepBias)) + 1;
            
            voltageArr = zeros(1,biasSweepPts);
            currArr = zeros(1,biasSweepPts);

            %%%vector for averaging current
            avgNum = 10;
            avgcurrArr = zeros(1,5);          
            
            for i = 1:biasSweepPts
               voltageArr(i) = startBias + (stepBias * single(i-1));
            end
            
            currArr = zeros(length(hwAngleArr),length(currArr));
            darkcurrArr = zeros(length(hwAngleArr),length(currArr));
            netcurrArr = zeros(length(hwAngleArr),length(currArr));
            responsivityArr = zeros(length(hwAngleArr),length(currArr));
            
           %set power
           this.shutter.OFF();
                        
           this.smu.setVoltage(0);
           this.smu.setCurrentLimit(0.1); %%%% CHECK THIS needs to be 0.001 or less

           for i = 1:length(hwAngleArr)
               this.hwplate.setAngle(hwAngleArr(i))
               this.ndfilters.moveND1(nd1posArr(i))
               pause(1)
               for j = 1:biasSweepPts
                   %%% dark current
                   this.smu.setVoltage(voltageArr(j));
                    this.shutter.OFF();
                    pause(1);
                    %%% average dark current
                    for k = 1:length(avgcurrArr)
                        avgcurrArr(k)=this.smu.readCurrent();
                        pause(0.2);
                    end
                    %%% get average dark current
                    darkcurrArr(i,j)=mean(avgcurrArr);
                    %%% light current
                    this.shutter.ON();
                    pause(1);
                    %%% average light current
                    for k = 1:length(avgcurrArr)
                        avgcurrArr(k)=this.smu.readCurrent();
                        pause(0.2);
                    end
                    currArr(i,j)=mean(avgcurrArr);
                    netcurrArr(i,j) = currArr(i,j) - darkcurrArr(i,j);
                    pause(0.5);
                    %%% calculate responsivity
                    %responsivityArr(i,j) = (netcurrArr(i,j)/deviceArea/cwPowerArr(i));
                    responsivityArr(i,j) = (netcurrArr(i,j)/deviceArea)/cwPowerArr(i);
               end
           end

            this.shutter.OFF();
           
            %this.laser.setCurrent(0);
            this.hwplate.setAngle(45);
            %this.laser.setPulse;
            this.smu.setVoltage(0);
            this.smu.setCurrentLimit(0.0001);
            this.ndfilters.moveND1(1); %%% First test
            this.ndfilters.moveND2(1);
            
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_darkcurrArr.mat',testName,runNum), 'darkcurrArr');
            save(sprintf('%s_%i_netcurrArr.mat',testName,runNum), 'netcurrArr');
            save(sprintf('%s_%i_hwAngleArr.mat',testName,runNum), 'hwAngleArr');
            save(sprintf('%s_%i_responsivityArr.mat',testName,runNum), 'responsivityArr');
            save(sprintf('%s_%i_cwPowerArr.mat',testName,runNum), 'cwPowerArr'); %%% W/cm2 at hw angle, 2A, ND=0
                        
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 18);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 18);
            
            f1 = figure;
            sub_f1 = subplot(1,1,1);
            hold;
            %yyaxis right;
             for i = 1:length(hwAngleArr)
                 %cmd = sprintf("hwAngle=%i",hwAngleArr(i));
                 cmd = sprintf("cw=%.3g W/cm^2",cwPowerArr(i));
                 %semilogy(voltageArr, currArr(i,:), 'DisplayName', cmd);
                 %semilogy(voltageArr, netcurrArr(i,:), 'DisplayName', cmd);
                 semilogy(voltageArr, responsivityArr(i,:), 'DisplayName', cmd);
             end
             
            legend;
            legend('location', 'best');
            ylabel('Responsivity (A/W)');
            grid on;
            xlabel('Voltage (V)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
        end


        %%%% Power vs. responsivity at a fixed bias
         % sweep power and calcluate responsivity at fixed bias
         function responsivityunderCWatFixedBias(this,testName,runNum)
            
           %%% HW angle array
           hwAngleArr = [45,45,45,35,35,25,0];%,35,0];       % all the angles - power for hw array is found from calibration data - 2A

             
           cwPowerArr = [1.18E-04,8.53E-03,7.73E-02,3.34E-01,3.03E+00,1.26E+01,3.56E+01]%,8.72E-01,1.01E+01]; % W/cm2 at 2A with ND1 = POS 1

                      
           deviceArea = 5.02655E-05;% EXCELITAS  %6160E-8;  % 140 x 44 um2 1x4 device area. The optical power is overfilling the sensor


            %%% change the ND filteras along with the HW angle for higher
            %%% dynamic range
            nd1posArr = [4,2,1,2,1,1,1]; %2A

            %%%%

            this.shutter.OFF;

            %%% set CW
            %this.laser.setCW;
            
            %%% set optical conditions
            %this.laser.setCurrent(2);             %%%% CHECK THIS VALUE

            this.hwplate.setAngle(hwAngleArr(1)); %%%% Change this
            this.ndfilters.moveND1(nd1posArr(1)); %%% First test ndFactor = 55.39
            this.ndfilters.moveND2(1);

            %pause(60); %% warm up the laser

                
            fixedBias = 52.4; %%%%% checkthis
            
            %%%vector for averaging current
            avgNum = 10;
            avgcurrArr = zeros(1,avgNum);          
            
                    
            currArr = zeros(1,length(hwAngleArr));
            darkcurrArr = zeros(1,length(hwAngleArr));
            netcurrArr = zeros(1,length(hwAngleArr));
            responsivityArr = zeros(1,length(hwAngleArr));
            
           %set power
           this.shutter.OFF();
                        
           this.smu.setVoltage(fixedBias);
           this.smu.setCurrentLimit(0.1); %%%% CHECK THIS needs to be 0.001 or less

           for i = 1:length(hwAngleArr)
               this.hwplate.setAngle(hwAngleArr(i))
               this.ndfilters.moveND1(nd1posArr(i))
               pause(1)
              
                   %%% dark current
                    
                    this.shutter.OFF();
                    pause(1);
                    %%% average dark current
                    for k = 1:length(avgcurrArr)
                        avgcurrArr(k)=this.smu.readCurrent();
                        pause(0.2);
                    end
                    %%% get average dark current
                    darkcurrArr(i)=mean(avgcurrArr);
                    %%% light current
                    this.shutter.ON();
                    pause(1);
                    %%% average light current
                    for k = 1:length(avgcurrArr)
                        avgcurrArr(k)=this.smu.readCurrent();
                        pause(0.2);
                    end
                    currArr(i)=mean(avgcurrArr);
                    netcurrArr(i) = currArr(i) - darkcurrArr(i);
                    pause(0.5);
                    %%% calculate responsivity
                    %responsivityArr(i,j) = (netcurrArr(i,j)/deviceArea/cwPowerArr(i));
                    responsivityArr(i) = (netcurrArr(i)/deviceArea)/cwPowerArr(i);
               
           end

            this.shutter.OFF();
           
            %this.laser.setCurrent(0);
            this.hwplate.setAngle(45);
            %this.laser.setPulse;
            this.smu.setVoltage(0);
            this.smu.setCurrentLimit(0.0001);
            this.ndfilters.moveND1(1); %%% First test
            this.ndfilters.moveND2(1);
            
            
            %plot figure and save data
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_darkcurrArr.mat',testName,runNum), 'darkcurrArr');
            save(sprintf('%s_%i_netcurrArr.mat',testName,runNum), 'netcurrArr');
            save(sprintf('%s_%i_hwAngleArr.mat',testName,runNum), 'hwAngleArr');
            save(sprintf('%s_%i_responsivityArr.mat',testName,runNum), 'responsivityArr');
            save(sprintf('%s_%i_cwPowerArr.mat',testName,runNum), 'cwPowerArr'); %%% W/cm2 at hw angle, 2A, ND=0
                        
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 18);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 18);
            
            f1 = figure;
            sub_f1 = subplot(1,1,1);
         
            %yyaxis right;
                 %cmd = sprintf("hwAngle=%i",hwAngleArr(i));
                 cmd = sprintf("bias=%.2f V", fixedBias);
                 %semilogy(voltageArr, currArr(i,:), 'DisplayName', cmd);
                 %semilogy(voltageArr, netcurrArr(i,:), 'DisplayName', cmd);
                 %semilogx(cwPowerArr, responsivityArr, 'DisplayName', cmd);
                 loglog(cwPowerArr, responsivityArr, 'DisplayName', cmd);
            
             
            legend;
            legend('location', 'best');
            ylabel('Responsivity (A/W)');
            grid on;
            xlabel('Irradiance (W/cm^2)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
        end
    

        %%%%%%%%%%%%%
         % sweep power and calcluate responsivity at different bias points
         function responsivityunderCWsweepingIV(this,testName,runNum)
            
           %%% HW angle array
           hwAngleArr = [45,45,45,35,35,25,0];%,35,0];       % all the angles - power for hw array is found from calibration data - 2A

             
           cwPowerArr = [1.18E-04,8.53E-03,7.73E-02,3.34E-01,3.03E+00,1.26E+01,3.56E+01]%,8.72E-01,1.01E+01]; % W/cm2 at 2A with ND1 = POS 1

                      
           deviceArea = 5.02655E-05;% EXCELITAS  %6160E-8;  % 140 x 44 um2 1x4 device area. The optical power is overfilling the sensor


            %%% change the ND filteras along with the HW angle for higher
            %%% dynamic range
            nd1posArr = [4,2,1,2,1,1,1]; %2A


            %%%%

            this.shutter.OFF;

            %%% set CW
            %this.laser.setCW;
            
            %%% set optical conditions
            %this.laser.setCurrent(2);             %%%% CHECK THIS VALUE

            this.hwplate.setAngle(hwAngleArr(1)); %%%% Change this
            this.ndfilters.moveND1(nd1posArr(1)); %%% First test ndFactor = 55.39
            this.ndfilters.moveND2(1);

            %pause(60); %% warm up the laser
             
          
            voltageArr = [50,51,52];
            
            biasSweepPts = length(voltageArr);

            %%%vector for averaging current
            avgNum = 10;
            avgcurrArr = zeros(1,avgNum);          
           
            
            currArr = zeros(biasSweepPts,length(hwAngleArr));
            darkcurrArr = zeros(biasSweepPts,length(hwAngleArr));
            netcurrArr = zeros(biasSweepPts,length(hwAngleArr));
            responsivityArr = zeros(biasSweepPts,length(hwAngleArr));
            
           %set power
           this.shutter.OFF();
                        
           this.smu.setVoltage(0);
           this.smu.setCurrentLimit(0.1); %%%% CHECK THIS needs to be 0.001 or less

           for j = 1:biasSweepPts
                this.smu.setVoltage(voltageArr(j));
               for i = 1:length(hwAngleArr)
                   this.hwplate.setAngle(hwAngleArr(i))
                   this.ndfilters.moveND1(nd1posArr(i))
                   pause(2)
                   
                       %%% dark current
                        this.shutter.OFF();
                        pause(1);
                        %%% average dark current
                        for k = 1:length(avgcurrArr)
                            avgcurrArr(k)=this.smu.readCurrent();
                            pause(0.2);
                        end
                        %%% get average dark current
                        darkcurrArr(i,j)=mean(avgcurrArr);
                        %%% light current
                        this.shutter.ON();
                        pause(1);
                        %%% average light current
                        for k = 1:length(avgcurrArr)
                            avgcurrArr(k)=this.smu.readCurrent();
                            pause(0.2);
                        end
                        currArr(j,i)=mean(avgcurrArr);
                        netcurrArr(j,i) = currArr(j,i) - darkcurrArr(j,i);
                        pause(0.5);
                        %%% calculate responsivity
                        %responsivityArr(i,j) = (netcurrArr(i,j)/deviceArea/cwPowerArr(i));
                        responsivityArr(j,i) = (netcurrArr(j,i)/deviceArea)/cwPowerArr(i);
                   end
           end

            this.shutter.OFF();
           
            %this.laser.setCurrent(0);
            this.hwplate.setAngle(45);
            %this.laser.setPulse;
            this.smu.setVoltage(0);
            this.smu.setCurrentLimit(0.0001);
            this.ndfilters.moveND1(1); %%% First test
            this.ndfilters.moveND2(1);
            
            
            %plot figure and save data
            save(sprintf('%s_%i_voltageArr.mat',testName,runNum), 'voltageArr');
            save(sprintf('%s_%i_currArr.mat',testName,runNum), 'currArr');
            save(sprintf('%s_%i_darkcurrArr.mat',testName,runNum), 'darkcurrArr');
            save(sprintf('%s_%i_netcurrArr.mat',testName,runNum), 'netcurrArr');
            save(sprintf('%s_%i_hwAngleArr.mat',testName,runNum), 'hwAngleArr');
            save(sprintf('%s_%i_responsivityArr.mat',testName,runNum), 'responsivityArr');
            save(sprintf('%s_%i_cwPowerArr.mat',testName,runNum), 'cwPowerArr'); %%% W/cm2 at hw angle, 2A, ND=0
                        
            set(0,'DefaultAxesFontName', 'Calibri'); % Change default axes fonts.
            set(0,'DefaultAxesFontSize', 18);
            set(0,'DefaultTextFontname', 'Calibri'); % Change default text fonts.
            set(0,'DefaultTextFontSize', 18);
            
            f1 = figure;
            sub_f1 = subplot(1,1,1);
            %yyaxis right;
             for i = 1:biasSweepPts
                 %cmd = sprintf("hwAngle=%i",hwAngleArr(i));
                 cmd = sprintf("bias=%.2f V",voltageArr(i));
                 %semilogy(voltageArr, currArr(i,:), 'DisplayName', cmd);
                 %semilogy(voltageArr, netcurrArr(i,:), 'DisplayName', cmd);
                 loglog(cwPowerArr, responsivityArr(i,:), 'DisplayName', cmd);
                 hold;
             end
             
            legend;
            legend('location', 'best');
            ylabel('Responsivity (A/W)');
            grid on;
            xlabel('Irradiance (W/cm^2)');
            print(sprintf('%s_%i_result',testName, runNum), '-djpeg');
                 
        end

    end
end