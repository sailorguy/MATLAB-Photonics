classdef simVarObj
    %This class is used to pass simulation values around structure
    %definition files
    
    properties
        
        field %Name of field described by SimVarObj
        data %Data associated with SimVarObj, can be text or numerical depending on field
        
    end
    
    methods
        
        function obj = SimVarObj(field, data)
            %This constructor assigns values to the fields in the class
            
            obj.field = field;
            obj.data = data;
            
        end
                   
    end 
end