classdef SimOutputObj
    %Class used to identify various output functions
   
    properties
        StepMod = StepFcnModifierObj %Modifications to step functions
        outFcn = '' %Output function in use (i.e. epsilon, mu, field, etc.)
        uniqueIndex %Index for use in post-processing representing unique time/geometry combination
        
        %Field Specific properties, for outFcn = 'field'
        
        field  %Field (h, b, e, d, s)
        component = '' %(x,y,z)
        
        
        %MPB
        band %Band number for field/power being output
        
        
        
    end
    
end