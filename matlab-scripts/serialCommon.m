classdef serialCommon 
    %Provides connect, Read and write that are common to most drivers
  
    properties %Public
        
      %Instrument Drivers using SerialCommon must have these properties
          %instr         Matlab instrument object, or Arduino Object
          %instrumentName   
          %portType;  Port Type, one of PortSerial, PortGPIB, PortVISA
          %portAddress;  Serial (preferred COM), GPIB0 address, VISA address
          %serialBaud=9600; %Baud rate
          %serialTerminator=13; % typically LF (ascii 10) or CR (ascii 13)
          %serialTimeout = 3;  %port timeout in seconds
          %serialEcho=0;  % 1 = debug mode, display writes to screen
          %serialStatus, 0= unconnected, 1 = connected 2 =error
          %serialIdentifyCmd  = text string to write for identification 
          %serialIdentify=  string that is returned by the instrument in response to IdentifyCmd
          %serialDelay=0.2;%seconds to wait after requesting data before reading, 2ms seems minimum
        
        %Driver Methods
            %connect
            %disconnect
            %identify
            %reset
      end
  
      properties (Constant)
        portSerial = 'Serial';
        portGPIB = 'GPIB';
        portVISA = 'VISA';
        portArduino='Arduino';
    end
  
    properties (Constant,Hidden)
        msg_unsupported = "Unsupported option"
    end
  
    methods (Static)
        function SC = serialCommon()  %Constructor  
         end
        function result=connect(instObj)
             %Initate interface connection to an instrument object

             result=0;
             switch instObj.portType

                 case serialCommon.portSerial
                      result = serialCommon.connectSerial(instObj);
                      portString="COM" + instObj.PortAddress;

                 case serialCommon.portArduino
                     result = serialCommon.connectArduino(instObj);
                     portString="COM" + instObj.portAddress;

                 case serialCommon.portGPIB
                     result=serialCommon.connectGPIB(instObj);
                     portString="GPIB" + instObj.portAddress;

                 case serialCommon.portVISA
                     result=serialCommon.connectVISA(instObj);
                     portString="VISA";
                 
                 otherwise
                    msgbox("Unsupported call in SerialCommon.Connect","Error")
             end

             if instObj.serialStatus==1 && result==1
                 msg= instObj.instrumentName + " connected on " + portString;
                 disp(msg);
             end

         end
        function result=connectSerial(driver)
            %initiate serial port connection to instrument

            serialCommon.disconnect(driver);
            driver.serialStatus=0;  %set status = not connected
            
            % get array of available serial ports
           
            sList = 0 % serialCommon.serialList(driver); HACK to prevent it going to loop below 
            
           %%%% NO LOOP
           for i = 1:size(sList,2)  %attempt connection to each available port
                
                    idn="";
                    portName=S_list(1,i);
                    
                    try %try to create a serial connection
                        driver.Instr=serialport(portName,driver.serialBaud,'Timeout',driver.serialTimeout);
                        driver.serialStatus=1; %must be set to allow identification
                        
                        %set the terminator for serial port connections
                        try 
                            configureTerminator(driver.instr,driver.serialTerminator);
                        catch
                            disp("Failed to set termination for "+driver.instrumentName)
                        end
                        
                        %read identification string from instrument
                        idn = serialCommon.identify(driver);
                        
                    catch ME
                        if driver.serialEcho==1;disp(driver.instrumentName+" no connect on "+PortName + "  "+ME.message);end
                    end %end try

                    %disconnect if this is not the the correct instrument
                    if size(idn,2)==0 || not(contains(idn,driver.serialIdentify)==1)
                        driver.serialStatus=0;
                        serialCommon.disconnect(driver);
                    end
                
           end  %end for
            %%%% NO LOOP

           result = driver.serialStatus;
           if driver.serialStatus==1  %successfull connection

                driver.reset;  %set instrument to known state

                %save preferred COM port for fastest connect next time
                portstr="12";%%%%%%%%% strrep(driver.instr.Port,"COM",""); %remove 'COM' from port name %%%%% HACK
                driver.portAddress=str2double(portstr);
           end
    end

        function result=connectArduino(driver)
            %initiate serial port connection to arduino instrument

            serialCommon.disconnect(driver);
            
            driver.serialStatus=0;  %set status = not connected
            portName = "COM12";

            try 
                 driver.instr=arduino(portName);
                 driver.serialStatus=1; 
            catch ME
                 if driver.serialEcho==1
                     disp(driver.instrumentName+" no connect on "+portName + "  "+ME.message);
                 end
            end


            
            % get array of available serial ports
            
            %sList = serialCommon.serialList(driver); 
            %sListSize=size(sList,2);  %number of serial ports
            %portIdx=0; % index of port to attempt connection to
            
            %attempt connection to each available port
            %loop until a connection is made or all ports have been tried
            

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %while driver.serialStatus==0 && portIdx < sListSize
            %        
            %    portIdx=portIdx+1; %increment the port array index
            %    idn="";
            %    portName=sList(1,portIdx);
            %        
            %        try %try a port in the list
            %          
            %            driver.instr=arduino(portName);
            %            driver.serialStatus=1; 
            %
            %             %read identification string from instrument
            %                        idn = serialCommon.identify(driver);
            %                                                            
            %        catch ME
            %            if driver.serialEcho==1;disp(driver.instrumentName+" no connect on "+portName + "  "+ME.message);end
            %        end %end try
            %
            %       
            %
            %        %disconnect if this is not the the correct instrument
            %        %look for the 'serialIdentify' string within the returned identify string
            %        if size(idn,2)==0 || not(contains(idn,driver.serialIdentify)==1)
            %            driver.serialStatus=0;
            %            serialCommon.disconnect(driver);
            %        end
               
            %end %while 


           result = driver.serialStatus;
           
           if driver.serialStatus==1  %successfull connection
                
               %save preferred COM port for fastest connect next time
                portstr=strrep(driver.instr.Port,"COM",""); %remove 'COM' from port name
                driver.portAddress=str2double(portstr);
           end
         end
        function result=ConnectGPIB(driver)
                % Attempt GPIB connecton to instrument

            driver.serialStatus=0;result=0; 

            %Instrument control GPIB toolbox pukes if there are muliple instances
            %of the same instrument in the instrument array. 

            serialCommon.cleanInstrumentArray(driver);

             %create a GPIB interface
                 try
                    driver.instr = gpib('ni',0,driver.portAddress);
                    %buffer size is allocated at creation, sourcemeter sweep can be quite large
                    set(driver.instr,'InputBufferSize',4096);
                    driver.instr.Name=driver.instrumentName;
                    driver.serialStatus=1;
                 catch
                    result=0;
                    delete(driver.instr);
                    driver.serialStatus=0;
                    return;
                 end


             %try interacting with the instrument
             try
                 fopen(driver.instr);
                 driver.instr.Timeout=driver.serialTimeout;
             catch
                 driver.serialStatus=0;
                 disp(driver.instrumentName + " connection failed.");
                 delete(driver.instr);
                 return;
             end

             driver.reset;
             result=1;


         end
        function result=ConnectVISA(driver)

           serialCommon.cleanInstrumentArray(driver);

            result=0;
            driver.instr= visa('keysight', driver.portAddress);
            %Driver.Instr= visa('ni', Driver.PortAddress);
            driver.instr.Name=driver.instrumentName;

            %some instruments need large input buffer that can only be set
            %before open. 
            try
                driver.instr.InputBufferSize=driver.serBuffSize;
            catch
            end
            
            try
                fopen(driver.instr);
                driver.serialStatus=1;
                driver.reset;  %set instrument to known state
                result=1;

             catch
                 delete(driver.instr);
                 driver.serialStatus=0;
             end 
         end
        function disconnect(driver)
             %End serial port Connection

             switch driver.portType
                 case serialCommon.portSerial
                      %clear any data output of the port
                      try driver.instr.flush; catch;end 

                      try
                          delete(driver.instr);  %close the Matlab serialport connection
                      catch
                      end
                      driver.serialStatus=0; %set this class status to 'disconnected'

                 case {serialCommon.portGPIB, serialCommon.portVISA}    
                        try fclose(driver.instr); catch; end
                        try delete(driver.instr);catch; end
                        try clear(driver.instr); catch; end
                        driver.serialStatus=0;
                 case serialCommon.portArduino
                     % call the driver's disconnect mentod to clear any existing arduino object
                     % that routine MUST clear any objects that are
                     % children of the arduino object
                     driver.disconnect
                    
                     otherwise
                        disp (serialCommon.msg_unsupported); 
             end % switch
         end
        function result=write(driver,text)
             % send text to instrument
                result=0;

                % only write if port is connected
                if driver.serialStatus==0
                   % disp (Driver.InstrumentName+ " attempted write without connect.");
                    return; 
                end

                switch driver.portType
                   case serialCommon.PortSerial
                       %attempt write to serial port
                        try
                            driver.instr.flush;  % clear any unread data from the buffer
                            driver.instr.writeline(text);
                        catch
                            driver.serialStatus=2;   % report error
                        end %catch

                   case {serialCommon.portGPIB,serialCommon.portVISA}  %attempt write to GPIB
                     try 
                        %clrdevice(Driver.Instr);  % clear any unread data from the buffer
                        %JQ clrdevice was hanging the OA1 attenuator, so I commented out. 
                        %maybe not needed for VISA objects.
                        
                        fprintf(driver.instr,text); % write synchronous
                        driver.serialStatus=1; %write was successful
                    catch
                        driver.serialStatus=2;   % report error
                     end %try
               end % switch

               pause(driver.serialDelay);

               switch driver.serialStatus
                   case 1
                        if driver.serialEcho==1; disp(text);end   %for debug purpose
                         result=1;  %Success! 
                   case 2
                       if driver.serialEcho==1;disp("Failed to write "+text+ " to " +driver.instrumentName);end
               end %switch
             end
        function cleanInstrumentArray(Driver)
            %Instrument control toolbox pukes if there are many instances
            %of the same instrument in the instrument array.  

            instrArray=instrfind;    %get array of instruments
            for x=size(instrArray,2):-1:1
                %nuke any entries with this instruments name

                if contains(instrArray(x).Name,Driver.InstrumentName)
                    port=instrArray(x);     % assign the GPIB interface 
                    try fclose(port);catch;end       % close
                    delete(port);
                end
            end 
         end
        function result = read(driver,minLength, attempts)
             %Returns a line of text from the instrument (if any is available)
             %MinLength is minimum characters to attempt reading.  I it's known
             %that 20 characters are required, and the port < 20, do not
             %attempt to read (causes timeouts).  
             %Attempts is the number of times to try reading.  Sometimes long
             %strings are returned over multiple reads.   

            result=""; 

            if driver.serialStatus ==0 
                if driver.serialEcho==1; disp (driver.instrumentName + " not connected.");end
                return;
            end

            att=max(1,attempts);  % try at least one read :) 

            switch driver.portType
                case serialCommon.portSerial

                    minLength=max(2,minLength);  % some serial ports always present 1 byte
                    count=0 ; %count number of read attempts
                    while ( driver.instr.NumBytesAvailable>=minLength && count<att ) 
                        try
                            result=result + driver.instr.readline;
                            count=count+1;
                        catch
                            disp("error in serialCommon.read");
                        end
                    end 

                case {serialCommon.portGPIB, serialCommon.portVISA}
                    try result=fscanf(driver.instr);catch;end
            end % switch

            if driver.serialEcho==1 ;disp(result) ; end
         end
        function result = identify(driver)
              %display instrument information

              switch driver.portType
                  case serialCommon.portArduino
                      %cannot read and write with Arduino, need to call the identify method
                       msg=driver.identify;
                  otherwise
                        serialCommon.write(driver,driver.serialIdentifyCmd);
                        msg=serialCommon.read(driver,strlength(driver.serialIdentify),5); 
              end %switch
                 
                  if driver.serialEcho; disp(msg); end
                  result=msg;
          end
        function status(driver)
            %Display information
            disp("Hello from Serial Common");
            disp(driver.instrumentName);  
         end
        function Result=query(obj,cmd)
         %Use to Querry instrument text, write a command,read buffer
         serialCommon.write(obj,cmd);
         Result=serialCommon.read(obj,1,1);         
     end  
    function sList=serialList(inst)
            % returns a list of com ports. 
            % first port in the list is the 'preferred' port, perhaps previously connected
            % inst is the current instrument object
            
            % get array of available serial ports
            sList = serialportlist; 
            sSize = size(sList,2); %get length of port array

            % stop if there are no ports available
            if sSize<1 ;disp("No serial ports are available");return;end
            
            %create port string ie: "COMxx"
            portAddress="COM"+inst.portAddress;
            
            for i=1:sSize %swap favorite port into position 1 if it's available
                 if i>1 && strcmp(sList(1,i),portAddress)==1
                     temp=sList(1,1);
                     sList(1,1)=sList(1,i);
                     sList(1,i)=temp;
                 end %if
            end %for
            

        end
  end   
%     methods(Static,Hidden)
%         
%     end %static, hidden methods
end

