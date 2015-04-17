classdef SourceObj
    
    properties
        
        %General source properties
        type %descriptor of source type (gaussian, cw etc)
        center %Source location
        size %Source size (X,Y,Z)
        component %Field component (Hz, Ex etc.)
        amplitude = 1 %Default amplitude for source of 1
        
        %Angular source properties
        angularfcen %Center frequency for angular source (could be different than fcen)
        angleY %Y directed angle of source away from propagating along X
        angleZ %Z directed angle of source away from propagating along Z
        kVec = [0 0 0]; %K vector to control angular source, defaults to normal incidence 
        
        %Source specific properties
        fcen %center frequency
        startTime = 0 %Default the source to start at T = 0
        width = 0 %Temporal width of smoothing
        cutoff = 5 %Default cutoff = 5, number of widths before setting source to 0
        
        %Gaussian Only
        df %bandwitch
        
        
    end
    
    methods
        
        function string = ctlPrint(obj,srcIndex)
            
            switch obj.type
                
                case 'gaussian-src'
                    formatSpec = ['(make source (src (make gaussian-src (frequency %f) (fwidth %f) (start-time %f) (cutoff %f) ))'...
                        ' (component %s) (center %f %f %f) (size %f %f %f) (amplitude %f) (amp-func src-amp_%u) )\n'];
                    
                    string = sprintf(formatSpec, obj.fcen, obj.df, obj.startTime, obj.cutoff, obj.component, obj.center(1),...
                        obj.center(2), obj.center(3), obj.size(1), obj.size(2), obj.size(3), obj.amplitude, srcIndex);
                    
                case 'continuous-src'
                    
                    formatSpec = ['(make source (src (make continuous-src (frequency %f) (start-time %f) (width %f) (cutoff %f) ))'...
                        ' (component %s) (center %f %f %f) (size %f %f %f) (amplitude %f) (amp-func src-amp_%u) )\n'];
                    
                    string = sprintf(formatSpec, obj.fcen, obj.startTime, obj.width, obj.cutoff, obj.component, ...
                        obj.center(1), obj.center(2), obj.center(3), obj.size(1), obj.size(2), obj.size(3), obj.amplitude, srcIndex);
                    
                case 'band-src'
                    formatSpec = ['(make source (src (make custom-src (src-func band-src_%u ) (start-time %f) (end-time %f)))'...
                        ' (component %s) (center %f %f %f) (size %f %f %f) (amplitude %f) (amp-func src-amp_%u) )\n'];
                    
                    string = sprintf(formatSpec, srcIndex, obj.startTime, obj.startTime + obj.cutoff, obj.component, obj.center(1),...
                        obj.center(2), obj.center(3), obj.size(1), obj.size(2), obj.size(3), obj.amplitude, srcIndex);
                    
            end
            
            
        end
        
        function string = customSource(obj,srcIndex)
            
            string = '';
            
           switch obj.type
               
               case 'band-src'
                   
                   formatSpec = [
                       '\n\n(define (band-src_%u t)\n\n',...
                       ';User inputs\n',...
                       '(let* (\n', ...
                       '(freq %f)\n',...
                       '(fwidth %f)\n',...
                       '(cutoff %f)\n\n',...
                       ';Derived quantities\n',...
                       '(peak_time (/ cutoff 2))\n',...
                       '(width (/ 4 fwidth))\n',...
                       '(tt (- t peak_time))\n\n',...
                       ';Compute sinc(t), step by step to make scheme code more readable\n' ,...
                       ';sincT = sin(tt*2*pi / width/2)/(tt*2*pi * width) * polar(1.0, -2*pi*freq*tt)\n\n', ... 
                       '(tt2pi (* tt 2 pi))\n' ,...
                       '(numerator (sin (/ tt2pi (/ width 2))))\n' ,...
                       '(denominator (* tt2pi width))\n' ,...
                       '(phase  (exp (* -1i tt2pi freq)))\n\n', ...
                       '(sincT (* (/ numerator denominator) phase))\n\n' ,...
                       ';Compute current value of Blackmann window, term by term to make scheme readable\n', ... 
                       ';wnd_Blackmann = (0.3635819 + 0.4891775*cos(tt/(cutoff)*pi*2) +  0.1365995*cos(tt/(cutoff)*pi*4)+ 0.0106411*cos(tt/(cutoff)*pi*6))\n\n' ,...
                       '(term1 0.3635819 )\n' ,...
                       '(term2 (* 0.4891775 (cos (/ (* tt 2 pi) cutoff))) )\n' ,...
                       '(term3 (* 0.1365995 (cos (/ (* tt 4 pi) cutoff))) )\n', ...
                       '(term4 (* 0.0106411 (cos (/ (* tt 6 pi) cutoff))) )\n\n', ...   
                       '(wnd_Blackmann (+ term1 term2 term3 term4) )\n\n' ,...
                       ') ; end let' ,...
                       ';Return sinc(t) if we are inside the cutoff, otherwise return 0\n',...
                       '(if (< (abs tt) (/ cutoff 2))\n', ...
                       '    (* sincT wnd_Blackmann) \n', ...
                       '	0			;else\n\n', ...
                       ')))\n\n', ...
                       ];
                   
                   string = sprintf(formatSpec, srcIndex, obj.fcen, obj.df, obj.cutoff);
                                             %'	(* sincT wnd_Blackmann) ;if\n', ...                       %'	(* sincT wnd_Blackmann) ;if\n', ... 
               
                                             
               otherwise
                   %Do nothing for non-custom sources
                   
                   
           end
           
           %Handle angular sources
           
           formatSpec = '%s\n\n(define (src-amp_%u p) (exp (* 2 pi 0+1i (vector3* (vector3 %f %f %f) p))))\n\n';
           
           string = sprintf(formatSpec, string, srcIndex, obj.kVec(1), obj.kVec(2), obj.kVec(3));
           
           
        end
        
        function SourceText = print(obj,index)
            %This function returns a cell array of formated text with the
            %values of all properties of the Source Object. As a simulation
            %may have more than one source, index is the index of the
            %current source.
            
            k=1; %Index of current line in array, allows for future expansion with new fields
            
            string = sprintf('Source %u Parameters:\n',index);
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Type: %s',obj.type);
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Center (X,Y,Z): %.2f,%.2f,%.2f',obj.center(1), obj.center(1), obj.center(3));
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Field Component: %s',obj.component);
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Start Time: %.2f',obj.startTime);
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Cutoff: %.2f',obj.cutoff);
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Amplitude: %.2f',obj.amplitude);
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Center Frequency: %.2f',obj.fcen);
            SourceText(k) = {string};
            k = k+1;
            
            string = sprintf('Bandwidth: %.2f',obj.df);
            SourceText(k) = {string};
            k = k+1;
            
            String = sprintf('\n\n');
            SourceText(k) = {String}; %Print some extra lines to leave space before next data set
            
        end
        
    end
    
end