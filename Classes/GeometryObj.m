classdef GeometryObj
    
    properties
        type %Descriptor of object type (sphere, block etc.)
        center %Center of geometric object
        epsilonRE %Real component of permitivitty
        sigmaD = 0 %Electric conductivity (frequency independant)
        chi2 = 0 %2nd order nonlinearity
        chi3 = 0 %3rd order nonlinearity
        color %Color of lattice element. Used for setting lattice color in plots.
        
        %Blocks
        size %Size of block in X, Y, Z
        
        %Sphere
        radius %Sphere radius
        
        %Cylinder
        %radius -- already availible for sphere
        height %Cylinder height
        axis  %Cylinder Axis
        
        %Cone
        radius2 = 0 %Radius for tip of cone, default to 0
        
        
        
    end
    
    
    methods
        
        function string = ctlPrint(obj)
            %This function outputs the geometry object for a ctl file
            
            switch obj.type
                
                case 'sphere'
                    formatSpec = '(make sphere (center %s) (radius %f) (material(make dielectric(epsilon %f)(D-conductivity %f)(chi2 %f)(chi3 %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),obj.radius,obj.epsilonRE,obj.sigmaD, obj.chi2, obj.chi3);
                    
                case 'cylinder'
                    formatSpec = '(make cylinder (center %s) (radius %f) (height %f) (axis %s) (material(make dielectric(epsilon %f)(D-conductivity %f)(chi2 %f)(chi3 %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),obj.radius, obj.height,...
                        vecToStr(obj.axis), obj.epsilonRE, obj.sigmaD, obj.chi2, obj.chi3);
                    
                case 'cone'
                    formatSpec = '(make cone (center %s) (radius %f) (radius2 %f) (height %f) (axis %s) (material(make dielectric(epsilon %f)(D-conductivity %f)(chi2 %f)(chi3 %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),obj.radius, obj.radius2, obj.height,...
                        vecToStr(obj.axis), obj.epsilonRE, obj.sigmaD,obj.chi2, obj.chi3);
                    
                case 'block'
                    formatSpec = '(make block (center %s) (size %s) (material(make dielectric(epsilon %f)(D-conductivity %f)(chi2 %f)(chi3 %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),vecToStr(obj.size),...
                        obj.epsilonRE, obj.sigmaD, obj.chi2, obj.chi3);
                    
                case 'ellipsoid'
                    formatSpec = '(make ellipsoid (center %s) (size %s) (material(make dielectric(epsilon %f)(D-conductivity %f)(chi2 %f)(chi3 %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),vecToStr(obj.size), obj.epsilonRE, obj.sigmaD, obj.chi2, obj.chi3);
                    
            end
        end   
        
        function string = MPBctlPrint(obj)
            %This function outputs the geometry object for an MPBctl file.
            %MPB does not support the same material options that MEEP does.
            
            switch obj.type
                
                case 'sphere'
                    formatSpec = '(make sphere (center %s) (radius %f) (material(make dielectric(epsilon %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),obj.radius,obj.epsilonRE);
                    
                case 'cylinder'
                    formatSpec = '(make cylinder (center %s) (radius %f) (height %f) (axis %s) (material(make dielectric(epsilon %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),obj.radius, obj.height,...
                        vecToStr(obj.axis), obj.epsilonRE);
                    
                case 'cone'
                    formatSpec = '(make cone (center %s) (radius %f) (radius2 %f) (height %f) (axis %s) (material(make dielectric(epsilon %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),obj.radius, obj.radius2, obj.height,...
                        vecToStr(obj.axis), obj.epsilonRE);
                    
                case 'block'
                    formatSpec = '(make block (center %s) (size %s) (material(make dielectric(epsilon %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),vecToStr(obj.size),...
                        obj.epsilonRE);
                    
                case 'ellipsoid'
                    formatSpec = '(make ellipsoid (center %s) (size %s) (material(make dielectric(epsilon %f))))\n';
                    string = sprintf(formatSpec,vecToStr(obj.center),vecToStr(obj.size), obj.epsilonRE);
                    
            end
        end   
        
    end
end