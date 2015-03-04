classdef VectorObj
    
    properties 
        X
        Y
        Z

    end
    
    methods
       
        %Set components in vector form
        function obj = setVec(obj,vec)
            obj.X = vec(1);
            obj.Y = vec(2);
            obj.Z = vec(3);
        end
        
        %Return components in vector form
        function vec = getVec(obj)
            vec = [obj.X obj.Y obj.Z];
        end
        
        function d = getLength(obj)
            vec = [obj.X obj.Y obj.Z];
            d = norm(vec);
        end
        
    end
    
end