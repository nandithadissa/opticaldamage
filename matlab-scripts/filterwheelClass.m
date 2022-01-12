%filter whell class
classdef filterwheelClass < handle
    properties (SetAccess = private)
        nd1com;
        nd2com;
        timeout = 1;
    end
    
    methods
        function this = filterwheelClass()
            this.nd1com = serial('COM5','BaudRate', 115200, 'Terminator', 'CR');
            this.nd2com = serial('COM6','BaudRate', 115200, 'Terminator', 'CR');
            set(this.nd1com, 'Timeout', 1);
            set(this.nd2com, 'Timeout', 1);
            fopen(this.nd1com);
            fopen(this.nd2com);
            %move to default places
            this.moveND1(1);
            this.moveND2(1);
        end
        
        function moveND1(this,pos)
            cmd=sprintf('pos=%i',pos);
            fprintf(this.nd1com,cmd);
            fscanf(this.nd1com);
        end
        
        function r=readND1(this)
             fscanf(this.nd1com);
        end
        
        function r=readND2(this)
            fscanf(this.nd2com);
        end
        
        function moveND2(this,pos)
            cmd=sprintf('pos=%i',pos);
            fprintf(this.nd2com,cmd);
            fscanf(this.nd2com);
        end
        
        function delete(this)
            fclose(this.nd1com);
            fclose(this.nd2com);
            delete(this.nd1com);
            delete(this.nd2com);
        end
    end
end