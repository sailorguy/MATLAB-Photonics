classdef PlaneConstraintObj <PlaneObj
%This class defines a plane (by 3 points) to use as a point cloud
%constraint
    
    properties 
    
        dir %1 for points above plane (in direction of normal), -1 for points below plane      
        
    end
    
end
