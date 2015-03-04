classdef hstructObj < handle
    properties
        h %Handle to assigned struct
    end
    
    methods
        
        function obj = hstructObj(structure)
            obj.h = structure;
        end
    end
end
    