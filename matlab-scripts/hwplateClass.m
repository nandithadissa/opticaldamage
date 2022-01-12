% activeX control of 1/2 wave plate
% selecting the activex controller: actxcontrolselect

classdef hwplateClass < handle
 
    properties (SetAccess = private)
        angle %angle of rotation
        hw %handle for the activex controller
        timeout = 10
        f %figure handle
    end
    
    methods
        function this = hwplateClass()
            this.angle = 0; %constructor
            
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
            SN = 55203224; % put in the serial number of the hardware
            set(this.hw,'HWSerialNum', SN);
 
            % Indentify the device
            this.hw.Identify;           
            pause(5);
            
            %set default position
            this.setAngle(0);
        end
        
        function setAngle(this, ang)
                     
            this.hw.SetAbsMovePos(0,ang);
            this.hw.MoveAbsolute(0,1==0);
            
            %block until done
            t1 = clock; % current time
            while(etime(clock,t1)<this.timeout) 
            % wait while the motor is active; timeout to avoid dead loop
                s = this.hw.GetStatusBits_Bits(0);
                if (this.IshwMoving(s) == 0)
                  this.angle = ang;
                  fprintf('Move to position %f\n',this.angle);
                  break;
                end
            end

        end
        
        function result = getAngle(this)
            result = this.angle;
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