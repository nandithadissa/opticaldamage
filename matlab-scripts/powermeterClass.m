%power meter class

classdef powermeterClass < handle
    properties (SetAccess = private)
        npusb
        npdevinfo
    end
    
    methods
        function this = powermeterClass()
            [this.npusb,this.npdevinfo] = NP_USB_connect('C:\Newport',hex2dec('CEC7'),31);
        end
    
        function r = readPower(this)
            r = abs(NP_USB_readPD(this.npusb,31));
        end
    
        function r = readWavelength(this)
            r = NP_USB_readLambda(this.npusb, 31);
        end
    end
end
