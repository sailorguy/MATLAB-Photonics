classdef ModelPropertiesObj
    
   properties 
    
       dataXmin %Minimum x value for data used in fit
       dataXmax %Maximum x value for data used in fit
       displayXmin %Minimum x value for data display
       displayXmax %Maximum x value for data display
       
       modelType = 'exp1' %Type of model to fit. Default to exponential.
       modelTypeOptions = {'exp1', 'exp2', 'poly1', 'poly2', 'poly3'}
       
       %Model data
       formula = ''
       coeffNames = ''
       coeffValues = ''
         
    
   end
   
   methods
       
       function [modelText] =  print(obj)
      
           %Print formula
           modelText = obj.formula;
           
           %Print coefficients
           for k = 1:length(obj.coeffValues)
               
               string = sprintf('%s: %.3f', obj.coeffNames{k}, obj.coeffValues(k));
               
               modelText = sprintf('%s\n%s', modelText, string);
                
           end
   
       end
       
   end
end