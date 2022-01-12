clear; close all; clc;
global h; % make h a global variable so it can be used outside the main
          % function. Useful when you do event handling and sequential           move
%% Create Matlab Figure Container
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(3) = 650; % figure window size;Width
fpos(4) = 450; % Height
 
f = figure('Position', fpos,...
           'Menu','None',...
           'Name','APT GUI');
%% Create ActiveX Controller
%h = actxcontrol('APTPZMOTOR.APTPZMOTORCtrl.1',[20 20 600 400 ], f);
h = actxcontrol('MGMOTOR.MGMOTORCtrl.1',[20 20 600 400 ], f);


h.StartCtrl;
 
% Set the Serial Number
SN = 55203224; % put in the serial number of the hardware
set(h,'HWSerialNum', SN);
 
% Indentify the device
h.Identify;
 
pause(5); % waiting for the GUI to load up;

%h.MoveHome(0,1==0)

pause(5)

h.registerevent({'MoveComplete' 'MoveCompleteHandler'});

%h.MoveJog(0,0)

% Move a absolute distance
h.SetAbsMovePos(0,50);
h.MoveAbsolute(0,1==0);

timeout = 10

%h.MoveAbsoluteRot(0,10,0,0,0)

t1 = clock; % current time
while(etime(clock,t1)<timeout) 
% wait while the motor is active; timeout to avoid dead loop
    s = h.GetStatusBits_Bits(0);
    if (IsMoving(s) == 0)
      pause(2); % pause 2 seconds;
      %h.MoveHome(0,0);
      disp('Home Started!');
      break;
    end
end
