classdef HarminvObj
   
    properties 
        
        %Simulation setup
        component %Field Component
        pt %Point to run harminv at
        fcen %Frequency center
        df %Frequency width
        
        %Post-simulation data
        frequency %Resonant frequencies
        Q %Quality factor
        amplitude %Amplitude of mode
        error %Error from signal processing
        
        d %Defect to defect spacing
    
        
    end
    
    
    methods
        
        function [string] = ctlPrint(obj)
            
            string = sprintf('(harminv %s (vector3 %f %f %f) %f %f)', ...
                obj.component, obj.pt(1), obj.pt(2), obj.pt(3), obj.fcen, obj.df);
            
        end
        
        
        function [obj, dataFound] = loadData(obj, file)
          
            fid = fopen(file);
  
            %Check if file is valid
            if(fid == -1)
                return;
            end
            
            dataFound = false;
            
            %Initalize data index
            index = 1;
            
            %Read file line by line until we reach a harminv label
            while(1)
                line = fgets(fid);
                if(line == -1)
                    break %EOF
                elseif(length(line)>8)
                    if(strcmp(line(1:9), 'harminv0:'))
                        
                        if(strcmp(line(12:20),'frequency'))
                            %Header row, skip this data                          
                        else
                            
                            dataFound = true;
                            
                            %Eliminate Harminv0 Label
                            data = line(12:length(line));
                            %Read values from CSV data
                            %frequency, imag.frequency, Q, |amp|,amplitude, error
                            C = textscan(data,'%s');
                            
                            obj.frequency(index) = str2double(C{1}{1})+1i*str2double(C{1}{2}); %Frequency (real + imag)
                            obj.Q(index) = str2double(C{1}{3}); %Q value
                            ampTemp =  textscan(C{1}{5},'%f'); %Amplitdue (real + imag)
                            obj.amplitude(index) = ampTemp{1};
                            obj.error(index) = str2double(C{1}{6}); %Error
                            
                            index = index + 1;

                        end
                    end
                end
            end
            
            fclose(fid);
        end
        
        
        function obj = setDefectSpacing(obj,d)
            
            %Set displacement matrix of same size as frequency
           obj.d = ones(size(obj.frequency))*d;    
            
        end
  
    end
      
end