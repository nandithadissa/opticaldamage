%read from the newport power meter
%power meter class

%connect
%[npusb, npdevinfo] = NP_USB_connect('C:\Newport',hex2dec('CEC7'),31)
[npusb, npdevinfo] = NP_USB_connect('C:\Program Files\Newport\Newport USB Driver\Bin',hex2dec('CEC7'),31)
%read power
NP_USB_readPD(npusb,31)
%read wavelength
NP_USB_readLambda(npusb, 31)


