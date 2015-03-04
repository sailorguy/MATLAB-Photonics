classdef ColorSpecObj
    %This class is used to keep track of in-use colors when plotting to
    %enusre consistency of color as the plot is updated
   
    properties 
       shortName %Matlab short name for color
       RGB %RGB value for color
       inUse = false %Indicates if color is currently in use
    
    end
    
end