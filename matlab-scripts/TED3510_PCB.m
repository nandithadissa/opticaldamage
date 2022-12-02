classdef TED3510_PCB < handle
    %Matlab driver for the TED3510 PCB
    %TED3510B evaluates APD51250 1x4
    %TED3510C evaluates surface mount single APDs
    %TED3510C evaluate TO-18 single APDs

    %DEPENDENCIES
    % Matlab Arduino Add-on
    % serialCommon.m must be in the matlab path
    
    properties (Access = public)
        
        tempC; % result of reading the temp sensor
        serialNumber; % serial number of this board
        partNumber; % board variant, ie: "TED3510B"
        id; % full text contained in the eeprom
        
        %serialCommon Properties
        instr;        % Matlab Arduino Object
        instrumentName="TED3510 PCB"; %Instrument Name displayed by matlab
        portType=serialCommon.portArduino;% One of: {serialCommon.}portSerial, portGPIB, portVISA, portArduino

        portAddress="12"; %either GPIB address or COMxx, no meaning for VISA intstruments %%% HACK - i don't wont this to connect to Lenado at PORT 8"
        
        serialEcho=0;  % 1 = debug mode, display writes to screen
        serialStatus=0 % 0= unconnected, 1 = connected 2 =error
        serialIdentify=  "TED3510" % string that is returned by the instrument in response to IdentifyCmd
                
    end
    
    properties  (Access=private)
    

        eepromI2cObj; % an I2C object within the arduino Class
        eepromI2cAddr = 0x50;  % I2C address of the EEPROM
        
        TMP117obj; % an I2C object within the arduino Class
        TMP117addr = 0x48;  % I2C address of the temp sensor
    end
    
    methods
        %Constructor
        function obj = TED3510_PCB
            % Instrument Driver for TED3510 B,C & D evaluation boards with Arduino
        end
        function result=connect(obj) 
        
            %Initate arduino serial connection
            result=serialCommon.connect(obj);
    
            if result==1
                 %create an I2C device and configure the temp sensor
                obj.TMP117obj = obj.configTMP117();
            end
         end %TED3510_PCB.connect
     
        function disconnect(obj)
            %disconnect the arduino serial port connection

            %clear any child objects that were created
            %then clear obj.Instr
            % %empty brackets recommended by Mathsoft
         try 
             obj.eepromI2cObj=[]; % clear EEPROM i2C object
             obj.TMP117obj=[]; %clear the temp sensor i2c object
             obj.instr=[]; 
         catch
         end %catch
                 
     end

        function reset(obj)
          %do nothing
      end

%      function Result=Write(obj,text)
%         %do nothing
%      end
%      function Result = Read(obj,MinLength)
%         % do nothing
%      end
  
        function result = identify(obj)
              % Return instrument identification string
              %for arduino,this is the contents of the EEPROM  
    
              %determine if the I2C object for EEPROM exisits
              try
                  %if interface is created, return "I2C"  
                  interface=obj.eepromI2cObj.Interface;
              catch
                  %if interface type is not assigned, return null  
                  interface="";
              end % catch

              %create I2C object for EEPROM if needed
              interfaceCreated=strcmp("I2C",interface);
              if ~interfaceCreated 
                  obj.eepromI2cObj = openEeprom(obj);
              end %if
              

              result = obj.readEeprom;
              obj.id=result;
              
    end
        function status(obj)
        %Display status
     end
%       function result=query(obj,cmd)
%          %do nothing
%      end  


      
        
  

        function [val]=get.tempC(obj)
            write(obj.TMP117obj, 0);  %write the address to read
            TMP117ReturnedArray = (read(obj.TMP117obj, 2, 'uint8')); %read two Bytes out of 16b
            %The array above is HiByte, LoByte. Below convert to int16
            TMP117TemperatureInt16 = ((int16(TMP117ReturnedArray(1)))*256)+int16(TMP117ReturnedArray(2));
            val = round((double(TMP117TemperatureInt16))/128.0, 1); %convert to double, /128, round to 0.1C
            %disp("DUT Temp "+obj.tempC+"C");             
            
        end


   



        function writeEeprom(obj, strInput)
            %Write up to 256 bytes of strInput to EEProm 
            
            %create character array of size 256
                charData = convertStringsToChars(strInput);
                sizeData = size(charData,2);
                if sizeData > 256; charData=charData(1:256);end
                if sizeData < 256; charData=append(charData,blanks(256-sizeData));end

     
            %Parse 256-Byte array into 8-Byte Page Wrtites
            for PageNum = 1:32
                %point to a place in the character array
                pointer=(PageNum-1)*8+1;
                
                %get a byte of text
                byteOfText=charData(pointer:pointer+7);

                %EEPromAddr = int8([0, (PageNum-1)*8]);                 %use with 24M02 EEProm
                EEPromAddr =  int8(((PageNum-1)*8));                  %use with 24FC02 EEProm
                
             
                TextToWrite = [EEPromAddr, byteOfText];

                %not sure why this works with int8, but credit Archie for Figuring it out
                write(obj.eepromI2cObj, TextToWrite, 'int8');
            end
        end
        


       

    end %end of public Methods
    methods(Access=private)
        function val = openEeprom(obj)
            % Create an Arduino I2C object for the EEPROM
            
            val = device(obj.instr, 'I2CAddress', obj.eepromI2cAddr);
        end %openEeprom
         function result=readEeprom(obj)
            %Return 256 bytes of data from EEProm 
            
                
                %define the result as type character
                result = char.empty;

                %loop over 32 pages of EEPROM memory
                for PageNum = 1:32
                    %obj.EEPromAddr = int8([0, (PageNum-1)*8]);             %use with 24M02 EEProm
                    readAddr =  int8(((PageNum-1)*8));              %use with 24FC02 EEProm

                    %write the address to access
                    write(obj.eepromI2cObj, readAddr, 'int8');

                    %read 8 bytes
                    pageOut = char(read(obj.eepromI2cObj, 8, 'int8'));

                    %concatenate new characters with output string
                    result = append(result, pageOut);

                end %for
                
        end %readEeprom
         function TMP117obj = configTMP117(obj)
            %Open and Configure TMP117 temp sensor

            %create an I2C object within the arduino class
            TMP117obj = device(obj.instr, 'I2CAddress', obj.TMP117addr);
            ConversionCycle = 4*2^7; %512
            AverageBy = 1*2^5;       %32
			
            %Swap Matlab little endian for i2c bigEndian 
            ConfigurationValue = swapbytes(uint16(ConversionCycle + AverageBy));
            
            %select address 1, configuration byte
            write(TMP117obj, 1, 'uint8');  

            %write the 16-bit configuration value
            write(TMP117obj, ConfigurationValue, 'uint16');
         end %configTMP117
    end %private methods
end %end of class

