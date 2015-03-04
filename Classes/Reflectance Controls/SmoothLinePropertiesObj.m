classdef SmoothLinePropertiesObj
    
    properties
        
        method = 'lowess'
        methodOptions = {'moving', 'lowess', 'loess', 'sgolay', 'rlowess', 'rloess'};
        coeff = .003 %Smoothing coefficient
        
        
    end
    
end
    
    
    