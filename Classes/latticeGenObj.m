classdef latticeGenObj
    
    properties
        
        %Lattice vectors
        a1
        a2
        a3
        basisVec %Vector defining zero-referenced basis point. Used for lattices with two basis points
        
        %Reciprocal lattice vectors
        b1
        b2
        b3
        
        %Critical Points
        criticalPoints = KPointObj;
        CPtsXYZ %All critical point values for current lattice
        CPtNames %Names of critical points
        
        %Bounds on lattice
        maxBound %Point defining maximum of rectangular bounding box
        minBound %Point defining minimum of rectangular bounding box
        
        xmin
        xmax
        ymin
        ymax
        zmin
        zmax
        
        %Constraints
        constraints = PlaneConstraintObj %Planes definining constraints for lattice
        defineConstraintsFrom = 'bounds' %Use bounding values to define constraints
        
        structureThickness %Thickness of lattice, used to calcualte X-bounds
        
        %Disorder
        disorder = DisorderObj %Object describing disorder parameters
        
        a %Lattice constant
        basisPoint %Location for basis atom
        radius %Radius of spheres occupying lattice sites
        type %Lattice type (i.e. FCC, Diamond)
        dimensionality = 3 %Number of dimensions being used. Default to 3D. 
        

        %Point cloud
        point_tol = 0 %Point tolerance for capturing points on the boundry of lattice region
        
        %Epsilon
        epsL %Permittivity of lattice elements
        sigmaL %Conductivity of lattice elements
        epsS %Permittivity of substrate
        sigmaS %Conductivity of substrate
        
        %Rotations (in degrees)
        theta_X = 0 %rotation about X axis
        theta_Y = 0 %rotation about Y axis
        theta_Z = 0 %rotation about Z axis
        
        %Vector alignment (used to to rotate and align lattice)
        alignToVector = 0 %Flag to indicate vector alignment is in use
        alignToVectorLattice %Vector idnetifying lattice (i.e. 'a1', 'b1')
        alignToVectorDirection %Vector identifying direction to align lattice with (i.e. [1 0 0])
        
        %Lattice vector multipliers (used to construct MPB supercells)
        a1_mult = 1 
        a2_mult = 1 
        a3_mult = 1
        
    end
    
    methods
        
        function r = setRadius(obj)
            
            %Check if there is any radial deviation
            if(obj.disorder.rDeviation == 0)
                r = obj.radius;
                return
            else %Return radius with random deviation
                r = obj.radius + obj.disorder.rDeviation*(2*rand(1) - 1);
            end
            
        end
        
        function posVec = setPosition(obj, posVec)
            
            %Check if there is any positional displacement
            if(obj.disorder.pDisplacement == 0)
                return
            else%Return position with random displacement
                %Get random spherical coordinates
                r = obj.disorder.pDisplacement*rand(1);
                theta = pi*rand(1);
                phi = 2*pi*rand(1);
                
                if(obj.disorder.pDisplacementX)
                    %Set X coordinate
                    posVec(1) = psosVec(1) + r*sin(theta)*cos(phi);
                end
                
                if(obj.disorder.pDisplacementY)
                    %Set Y coordinate
                    posVec(2) = posVec(2) + r*sin(theta)*sin(phi);
                end
                
                if(obj.disorder.pDisplacementZ)
                    %Set Z coordinate
                    posVec(3) = posVec(3) + r*cos(theta);
                end
                
            end
            
            
        end
        
        function obj = setLattice(obj)
            
            %This function sets up lattice parameters for predefined
            %lattices. latticeType and a must be defined before calling
                  
            switch obj.type
                
                case '1D'
                    
                    %Lattice Vectors
                    obj.a1 = obj.a*[1 0 0];
                    obj.a2 = obj.a*[0 0 0];
                    obj.a3 = obj.a*[0 0 0];
                                        
                    %Compute reciprocal vecotors
                    obj = reciprocalVectors(obj);
                    
                    %K-Points, defining irreducible Brillouin zone, in canonical order
                    obj.criticalPoints(1).point = [0 0 0];
                    obj.criticalPoints(1).name = 'Gamma';
                    
                    obj.criticalPoints(2).point = [.5 0 0];
                    ojb.criticalPoints(2).name = 'X';
                    
                case 'square'
                    
                    %Lattice Vectors
                    obj.a1 = obj.a*[1 0 0];
                    obj.a2 = obj.a*[0 1 0];
                    obj.a3 = obj.a*[0 0 1];
                    
                    %Compute reciprocal vecotors
                    obj = reciprocalVectors(obj);
                                                  
                case {'fcc', 'diamond'}  
                    %Lattice Vectors
                    obj.a1 = .5*obj.a*[0 1 1];
                    obj.a2 = .5*obj.a*[1 0 1];
                    obj.a3 = .5*obj.a*[1 1 0];
                    
                    %Compute reciprocal vecotors
                    obj = reciprocalVectors(obj);
                    
                    %Critical Points
                    CriticalPoints = ...
                        [0 .5 .5;
                        0 .625 .375;
                        0 .5 0;
                        0 0 0;
                        .25 .75 .5;
                        .375 .75 .375];
                    
                    CPtNames = {'X', 'U', 'L', 'Gamma', 'W', 'K'};
                    
                    CPtsXYZ = CriticalPoints(:,1)*obj.b1 + CriticalPoints(:,2)*obj.b2 + CriticalPoints(:,3)*obj.b3;
                    
                    %K-Points, defining irreducible Brillouin zone, in canonical order
                    obj.criticalPoints(1).point = [0 .5 .5];
                    obj.criticalPoints(1).name  = 'X';
                    
                    obj.criticalPoints(2).point = [0 .625 .375];
                    obj.criticalPoints(2).name  = 'U';
                    
                    obj.criticalPoints(3).point = [0 .5 0];
                    obj.criticalPoints(3).name  = 'L';
                    
                    obj.criticalPoints(4).point = [0 0 0];
                    obj.criticalPoints(4).name  = 'Gamma';
                    
                    obj.criticalPoints(5).point = [0 .5 .5];
                    obj.criticalPoints(5).name  = 'X';
                    
                    obj.criticalPoints(6).point = [.25 .75 .5];
                    obj.criticalPoints(6).name  = 'W';
                    
                    obj.criticalPoints(7).point = [.375 .75 .375];
                    obj.criticalPoints(7).name  = 'K';
                    
                    %Construct full set of critical points for the
                    %Brillouin zone
                    
                    %Reflect across Gamma-L-X plane
                    plane = PlaneObj;
                    plane.pt = [0 0 0];
                    gamma_L = CPtsXYZ(3,:);
                    gamma_U = CPtsXYZ(2,:);
                    plane.norm = cross(gamma_L, gamma_U);
                    
                    CPtsXYZ = [CPtsXYZ; reflectAcrossPlane(CPtsXYZ, plane)];
                    CPtNames =  [CPtNames, CPtNames];
                                
                    %Rotate about Gamma-L
                    Rot1 = rotateAboutAxis(CPtsXYZ, gamma_L, 2*pi/3, 0);
                    Rot2 = rotateAboutAxis(CPtsXYZ, gamma_L, 4*pi/3, 0);
                    CPtsXYZ = [CPtsXYZ; Rot1; Rot2];
                    CPtNames =  [CPtNames, CPtNames, CPtNames];
      
                    %Rotate about vertical axis
                    Rot1 = rotateAboutAxis(CPtsXYZ, [0 0 1], pi/2, 0);
                    Rot2 = rotateAboutAxis(CPtsXYZ, [0 0 1], pi, 0);
                    Rot3 = rotateAboutAxis(CPtsXYZ, [0 0 1], 3*pi/2, 0);
                    CPtsXYZ = [CPtsXYZ; Rot1; Rot2; Rot3];
                    CPtNames = [CPtNames, CPtNames, CPtNames, CPtNames];
                    
                    %Reflect across Z = 0 plane
                    plane.pt = [0 0 0];
                    plane.norm = [0 0 1];
                    CPtsXYZ = [CPtsXYZ; reflectAcrossPlane(CPtsXYZ, plane)];
                    CPtNames = [CPtNames, CPtNames];
                    
                    %Get only unique points
                    [CPtsXYZ, ia, ic] = unique(CPtsXYZ, 'rows', 'stable');
                    
                    %Get corresponding point names
                    CPtNames = {CPtNames{ia}};
                    
                    obj.CPtsXYZ = CPtsXYZ;
                    obj.CPtNames = CPtNames;
                    
%                     figure
%                     scatter3(CPtsXYZ(:,1), CPtsXYZ(:,2), CPtsXYZ(:,3));

                    
                case 'hexagonal'
                    
                    %Lattice Vectors
                    obj.a1 = .5*obj.a*[1 -1*sqrt(3) 0];
                    obj.a2 = .5*obj.a*[1 1*sqrt(3) 0];
                    obj.a3 = 2*sqrt(2/3)*obj.a*[0 0 1];
                  
                    %Critical Points
                    
                    %K-Points, defining irreducible Brillouin zone, in canonical order
                    obj.criticalPoints(1).point = [0 0 0];
                    obj.criticalPoints(1).name  = 'Gamma';
                    
                    obj.criticalPoints(2).point = [0 0 .5];
                    obj.criticalPoints(2).name  = 'A';
                    
                    obj.criticalPoints(3).point = [1/3 1/3 1/2];
                    obj.criticalPoints(3).name  = 'H';
                    
                    obj.criticalPoints(4).point = [1/3 1/3 0];
                    obj.criticalPoints(4).name  = 'K';
                    
                    obj.criticalPoints(5).point = [0 0 0];
                    obj.criticalPoints(5).name  = 'Gamma';
                    
                    obj.criticalPoints(6).point = [.5 0 0];
                    obj.criticalPoints(6).name  = 'M';
                    
                    obj.criticalPoints(7).point = [.5 0 .5];
                    obj.criticalPoints(7).name  = 'L';
                    
                    obj.criticalPoints(8).point = [0 0 .5];
                    obj.criticalPoints(8).name  = 'A';
                    
                    %L-H
                    obj.criticalPoints(9).point = [.5 0 .5];
                    obj.criticalPoints(9).name  = 'L';
                    
                    obj.criticalPoints(10).point = [1/3 1/3 1/2];
                    obj.criticalPoints(10).name  = 'H';
                    
                    %M-K
                    obj.criticalPoints(11).point = [.5 0 0];
                    obj.criticalPoints(11).name  = 'M';
                    
                    obj.criticalPoints(12).point = [1/3 1/3 0];
                    obj.criticalPoints(12).name  = 'K';
                    
                otherwise
                    %Lattice Vectors (not applicable, but needed to avoid
                    %problems elsewhere)
                    obj.a1 = obj.a*[0 0 0];
                    obj.a2 = obj.a*[0 0 0];
                    obj.a3 = obj.a*[0 0 0];

            end
            
            %Compute reciprocal vecotors
            obj = reciprocalVectors(obj);
            
        end
        
        function cpVec = getCriticalPoint(obj, name, cartesian)
            %This function returns a critical point vector in either
            %reciprocal lattice vector coordinates (cartesian = 0), or
            %cartesian coordinates (cartesian = 1)
            
            cpVec = [];
            
            for k = 1:length(obj.criticalPoints)
                
                %Check name against current critical point
                if(strcmp(name,obj.criticalPoints(k).name))
                    
                    cpVec = obj.criticalPoints(k).point;
                    
                end
                
            end
            
            if(cartesian)
                
                %Convert ciritcal point vector from reciprocal lattice
                %vector coordinates to cartesian coordinates
                cpVec = cpVec(1)*obj.b1 + cpVec(2)*obj.b2 + cpVec(3)*obj.b3;
                
            end
        end
        
        function CPts = getCPtsXYZ(obj, name)
            
            indices = zeros(length(obj.CPtNames),1);
            
            %Loop over Critical Points to find those that satisfy the name
            for k = 1:length(obj.CPtNames)
                
                %Check if current point matches name
                if(strcmp(name, obj.CPtNames{k}))
                    indices(k) = 1;
                end
                
                
                
            end
            
            %Return matching CPts
            CPts = obj.CPtsXYZ(logical(indices),:);
     
        end
    end

end