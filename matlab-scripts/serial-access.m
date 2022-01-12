%%% Script creates video input object, previews, and analysis of data from
%%% VX-827 camera.
%%% A.Lee - 12/01/17
%%% B.Ryu - August 3, 2018: modified for Vx827.
%%% B.Ryu - August 13, 2018: changed basic structures and procedures.
%%% B.Ryu - August 14, 2018: adding a histogram graph.
%%% B.Ryu - August 15, 2018: working with Source-Meter(Keithley 2400)
%%%
%%% Module Name: FrameDCR_v1_4_Keithley.m;
%%%ndi
%%%%%% Notes %%%%%%
%%%
%%% VX827 generating Dark Count Characterization
%%% 


%% DCR FSI SENSORS WHILE COLLECTING CURRENT

% this is for BSI detector; the bias is POSITIVE


%%% initialize, clear frame grabbers
delete(imaqfind);
delete(instrfindall);
clear all;
close all;
clc;
%%%================== Setup parameteres ===========================
sensorNum = 40;
runNum = 1;
chipNum = 1; %100 - Al203  for chip-18

integTime = 0.100;%0.330; % ms
SMUportNum = 'COM1';
numAvgFrames = 20;
SMUdelay = 2;
sensorGain = 2.9;
filtSigma = 6; %filter for statistics (drop and report pixels outside this range); +/- X standard deviations

biasVoltMax = -19.0;%18.5;
biasVoltMin = -22.0;%-19.0;
biasVoltStep = 0.2; 
displayPoint = -21.0;

%%%================== Configure Source Meter COM port =============
clear comportSMU;
comportSMU = serial(SMUportNum); % assign serial port object for Source Meter (Keithley 2400)
set(comportSMU, 'BaudRate', 9600); % set BaudRate to 115200
set(comportSMU, 'Parity', 'none'); % set Parity Bit to None
set(comportSMU, 'DataBits', 8); % set DataBits to 8
set(comportSMU, 'StopBit', 1); % set StopBit to 1
set(comportSMU, 'Terminator', 'CR'); % set CR instead of LF
set(comportSMU, 'Timeout', 10); % Default is 10, changed to 1 seconds
set(comportSMU, 'InputBufferSize', 2048); % InputBufferSize Default: 512
set(comportSMU, 'OutputBufferSize', 2048); % OutputBufferSize Default: 512
%disp(get(tep,{'Type','Name','Port','BaudRate','Parity','DataBits','StopBits','Terminator','Timeout'})); % Runtime status

fopen(comportSMU); % Open Source Meter COM port Object
%%%================================================================

%%%=========== set up camera video output =========================
%vid = videoinput('fleximaq', 1,'VX827.cxf');
vid = videoinput('matrox', 1, 'Vx827_NormalMode_258x258.dcf');
set(vid, 'Timeout', 10); %10 is default
set(vid, 'FramesPerTrigger', numAvgFrames);

%%%=========== sensor related variables ===========================
%%% image crop for roi - remove clamp/garbage data
cropLt = 0;
cropRt = 2; % 2 clamp pixels on right side of image
cropTp = 0;
cropBt = 2; % 2 profile data on bottom side of image

%%% =========== get vertical and horizantal size of ROI ===========
vidSize = vid.VideoResolution; %[Width Height]
hSize = (vidSize(1) - (cropTp + cropBt));
vSize = (vidSize(2) - (cropLt + cropRt));
maxPixNum = vSize * hSize;
%%% ===============================================================
pause on;

%% Settings

%%% ===============================================================
%%% =========== define sweeping points ============================
rowNum = 256;
colNum = 256;
biasSweepPoints = int32((biasVoltMax - biasVoltMin) / biasVoltStep) + 1;

biasArr = zeros(1, (biasSweepPoints - 1));
currentArr = zeros(1, (biasSweepPoints - 1));

DCR_bfFilter = zeros(1, (biasSweepPoints - 1));
DCR_afFilter = zeros(1, (biasSweepPoints - 1));

Screamer = zeros(1, (biasSweepPoints - 1));
Mean_BadPix2Mean = zeros(1, (biasSweepPoints - 1));   % for debugging
STD_BadPix2Mean = zeros(1, (biasSweepPoints - 1));    % for debugging
Mean_RemoveBadPix = zeros(1, (biasSweepPoints - 1));  % for debugging
STD_RemoveBadPix = zeros(1, (biasSweepPoints - 1));   % for debugging

%%% ===============================================================
biasInput = zeros(1, biasSweepPoints, 'single'); % initializing sweepoing point vector
currentOutput = zeros(1, biasSweepPoints, 'single'); %collect current at each point

bufAvgFrame = zeros(rowNum, colNum, biasSweepPoints); % Define aveFrame buffer storing image frames on sweeping points
filterDetFrame = zeros(maxPixNum, biasSweepPoints-1);

for swPt = 1:biasSweepPoints
  biasInput(swPt) = biasVoltMin + (biasVoltStep * single(swPt - 1));
end

%% Data Collection

%%% ================= Initialize source meter =====================
serialCMD = sprintf('*RST\r');
serialCMD = sprintf('%s:SOUR:FUNC VOLT\r', serialCMD);
serialCMD = sprintf('%s:SOUR:VOLT:MODE FIXED\r', serialCMD);
%serialCMD = sprintf('%s:SENS:FUNC "VOLT"\r', serialCMD);
serialCMD = sprintf('%s:SENS:FUNC "CURR"\r', serialCMD);
serialCMD = sprintf('%s:SOUR:VOLT:LEV %2.3f\r', serialCMD, biasInput(1)); %defula(initial value)
serialCMD = sprintf('%s:SENS:CURR:PROT 75E-3\r', serialCMD);
%serialCMD = sprintf('%s:SENS:CURR:RANG 10E-2\r', serialCMD);
serialCMD = sprintf('%s:SENS:CURR:RANG:AUTO ON\r', serialCMD);

%serialCMD = sprintf('%s:ARM:COUN INF\r', serialCMD);  %:ARM:COUN 1
%serialCMD = sprintf('%s:ARM:SOUR TIM\r', serialCMD);
%serialCMD = sprintf('%s:ARM:TIM DEF\r', serialCMD);
serialCMD = sprintf('%s:OUTP ON\r', serialCMD);
%serialCMD = sprintf('%s:INIT\r', serialCMD);

fwrite(comportSMU, serialCMD);
%%% ===============================================================

fprintf('\n==== Sweep Start!!!!! ====\n');

%%% ====================== Get Frame ==============================
for swPt = 1:biasSweepPoints
    clear aveFrame;
    
    serialCMD = sprintf(':ABOR\r');
    serialCMD = sprintf('%s:SOUR:VOLT:LEV %2.3f\r', serialCMD, biasInput(swPt));
    serialCMD = sprintf('%s:INIT\r', serialCMD);
    fwrite(comportSMU, serialCMD);
    if (swPt == 1)
        pause(SMUdelay*10);   % Giving enough time to be stabilised after applying first Bias Voltage.
    else
        pause(SMUdelay);
    end
    fprintf('V_bias: %2.3f/%2.3f[V],    Sampling: [%d/%d]...\n', biasInput(swPt), biasVoltMin, swPt, biasSweepPoints);
    [avgFrame] = getAvgFrame(vid);
    bufAvgFrame(:, :, swPt) = avgFrame((cropTp + 1):(vidSize(2) - cropBt), (cropLt + 1):(vidSize(1) - cropRt));
    
    
    % Extract ROI from averaged frame
    
    %collect current
    currarrylight=query(comportSMU,'READ?');
    pause(SMUdelay);
    
    currarrylight=regexp(currarrylight,',','split');
    curr = str2double(currarrylight(2));

    fprintf('Bias %2.3f Curr: %e\n',biasInput(swPt) ,curr);
    currentOutput(swPt) = curr;
    
end

%%% ================= Set source meter Default ====================
serialCMD = sprintf(':ABOR\r');
serialCMD = sprintf('%s:SOUR:VOLT:LEV %2.3f\r', serialCMD, biasInput(1));
serialCMD = sprintf('%s:INIT\r', serialCMD);
fwrite(comportSMU, serialCMD);
pause(SMUdelay);
serialCMD = sprintf(':OUTP OFF\r');    % turn off source meter output
fwrite(comportSMU, serialCMD);


%% Processing

%%% ============= Get Delta-Frames -> Gen DCR =====================
for swPt = 2:biasSweepPoints
    %Delta Frame    % Next Dark Frame          - Dark Frame
    tmpDeltaFrame = bufAvgFrame(:, :, swPt) - bufAvgFrame(:, :, 1);
    VecDeltaframe = tmpDeltaFrame(:);    %convert into a (n x 1) vector from 2d matrix
    
    [tmpDCR_beforeFilter,tmpDCR_afterFilter,tmpScreamer,tmpMean_BadPix2Mean,tmpSTD_BadPix2Mean,tmpMean_RemoveBadPix,tmpSTD_RemoveBadPix,tmpFiltDetFrame] = genDCR(VecDeltaframe,filtSigma,sensorGain,integTime);
    
    biasArr((swPt - 1)) = biasInput(swPt);
    currentArr((swPt - 1)) = currentOutput(swPt);
    DCR_bfFilter((swPt - 1))  = tmpDCR_beforeFilter;
    DCR_afFilter((swPt - 1))  = tmpDCR_afterFilter;
    Screamer((swPt - 1)) = tmpScreamer;
    
    Mean_BadPix2Mean((swPt - 1))  = tmpMean_BadPix2Mean;   % for debugging
    STD_BadPix2Mean((swPt - 1))   = tmpSTD_BadPix2Mean;    % for debugging
    Mean_RemoveBadPix((swPt - 1)) = tmpMean_RemoveBadPix;  % for debugging
    STD_RemoveBadPix((swPt - 1))  = tmpSTD_RemoveBadPix;   % for debugging
    
    deltaVsize = size(tmpFiltDetFrame); %vSize(1,2);
    filterDetFrame(1:deltaVsize(1,1), (swPt - 1)) = tmpFiltDetFrame;
end

%%% ========================= Store data ==========================
save(sprintf('%02i_biasArr_sensor_%i_chip_%i.mat',runNum, sensorNum,chipNum), 'biasArr');             % store Bias Voltage
save(sprintf('%02i_currentArr_sensor_%i_chip_%i.mat',runNum, sensorNum,chipNum), 'currentArr'); 
save(sprintf('%02i_DCR_bfFilter_sensor_%i_chip_%i.mat',runNum, sensorNum,chipNum), 'DCR_bfFilter');   % store DCR data before filter
save(sprintf('%02i_DCR_afFilter_sensor_%i_chip_%i.mat',runNum, sensorNum,chipNum), 'DCR_afFilter');   % store DCR data after filter
save(sprintf('%02i_bufAvgFrame_sensor_%i_chip_%i.mat',runNum, sensorNum,chipNum),'bufAvgFrame');    % store frame data

%%% ===============================================================

%%

%%% ========================= Plot data ===========================
set(0,'DefaultAxesFontName', 'Calibri') % Change default axes fonts.
set(0,'DefaultAxesFontSize', 22)
set(0,'DefaultTextFontname', 'Calibri') % Change default text fonts.
set(0,'DefaultTextFontSize', 22)

f1 = figure;
    sub_f1 = subplot(2,1,1);
        title('Dark Count Characterization');
        yyaxis right;
        plot(biasArr, Screamer, 'r.-', 'DisplayName', 'Screamer');
        hold on;
        ylabel('Screamer [Pixels]')

        yyaxis left;
        plot(biasArr, DCR_bfFilter, '*b--', 'DisplayName', 'DCR(before Filter)');
        hold on;
        plot(biasArr, DCR_afFilter, 'g*-', 'DisplayName', 'DCR(after Filter)');
        grid on;
        ylabel('DCR [Hz]')

        %set(gca,'XDir','reverse');
        set(gca, 'YScale', 'log');
        xlabel('V_{bias}[V]');
        legend('Location','NorthWest');

    SelectPoint = biasSweepPoints;
    for swPt = 1:(biasSweepPoints - 1)
        if (SelectPoint == biasSweepPoints)
            if biasArr(swPt) >= displayPoint
                SelectPoint = swPt;
                break;
            end
        end
    end
    fprintf('\n\nSelectPoint: %d\n', SelectPoint);
    
    DispTitle2 = sprintf('Histogram of Filtered Delta Frame (V_{bias} = %2.2f[V])', biasArr(SelectPoint-1));
    sub_f2 = subplot(2,1,2);
        histogram(filterDetFrame(:, SelectPoint)./sensorGain./integTime); % Sample on -18.2V
        xlabel('DCR [Hz]');
        ylabel('Pixels');
        title(DispTitle2);
        grid on;
        %ylim([0 100]);

set(gcf, 'Position', [200 200 1200 1000])
%%% ===============================================================
print(sprintf('%02i_BaselineDCR_sensor_%i_chip_%i',runNum, sensorNum,chipNum), '-djpeg')
fprintf('\n^0^ Done ^0^\n');
%%
fclose(comportSMU);
delete(comportSMU);
delete(vid);
clear vid;
