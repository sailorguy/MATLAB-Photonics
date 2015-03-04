classdef GeoPropertiesObj
    %This class defines global geometric properites related to specialized
    %geometires (i.e. core-shell spheres)
   
    properties
       
        shellList = SphereShellObj %A list of spherical shell ojbects that describe the spherical shell geometry, in order from largest to smallest
        
    end
end
    