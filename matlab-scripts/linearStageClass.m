% activeX control of linear stage to measure the beam width
% selecting the activex controller: actxcontrolselect

classdef linearStageClass < handle
 
    properties (SetAccess = private)
        position %angle of rotation
        hw %handle for the activex controller
        timeout = 10
        f %figure handle
    end
    
    methods
        function this = linearStageClass()
            this.position = 0; %constructor
            
            fpos    = get(0,'DefaultFigurePosition'); % figure default position
            fpos(3) = 650; % figure window size;Width
            fpos(4) = 450; % Height
 
            this.f = figure('Position', fpos,...
                        'Menu','None',...
                         'Name','APT GUI');
            %% Create ActiveX Controller
            this.hw = actxcontrol('MGMOTOR.MGMOTORCtrl.1',[20 20 600 400 ], this.f);
            
            %%start the controller
            this.hw.StartCtrl;
 
            % Set the Serial Number
            SN = 27260917; % put in the serial number of the hardware
            set(this.hw,'HWSerialNum', SN);
 
            % Indentify the device
            this.hw.Identify;           
            pause(5);
            
            %set default position
            %this.setPosition(0);
            %see where the current position is and move to zero
            currentPos = this.getPosition();
            fprintf('Starting position is %f\n',currentPos);
            
            if currentPos ~= 0
                this.moveHome();
            end
            
                
        end
        
        function setPosition(this, pos)
                     
            this.hw.SetAbsMovePos(0,pos);
            this.hw.MoveAbsolute(0,1==0);
            
            %block until done
            t1 = clock; % current time
            while(etime(clock,t1)<this.timeout) 
            % wait while the motor is active; timeout to avoid dead loop
                s = this.hw.GetStatusBits_Bits(0);
                if (this.IshwMoving(s) == 0)
                  this.position = pos;
                  fprintf('Move to position %f\n',this.position);
                  break;
                end
            end

        end
        
        function result = getPosition(this)
            
            %get the postion from the controller
            [a,b] = this.hw.GetPosition(0,0);
            
            this.position = b;
            
            result = this.position;
        end
        
        function moveHome(this)
            this.hw.MoveHome(0,1==0);
        end
        
        
    
        %checking if the hw is moving
        function r = IshwMoving(this,StatusBits)
            r = bitget(abs(StatusBits),5)||bitget(abs(StatusBits),6);
        end
        
        %distructor
        function delete(this)
            close(this.f)
        end
       
    end
    
    
    
end