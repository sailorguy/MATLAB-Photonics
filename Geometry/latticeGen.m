function [colors,radii,latticeSites,disorderSites, lattice] = latticeGen(lattice)

%Lattice Vectors

switch lattice.type
    
    case '1D'
        
        %Get basis location
        lattice.basisVec = [0 0 0];
        
        %Get Lattice Sites
        latticeSites = generateLatticeSites(lattice);
        
        %Set disorder
        [latticeSites, radii, disorderSites] = setDisorder(lattice,latticeSites);
        
        %Set color for plot
        colors = zeros(size(latticeSites,1),3); %Blue
        colors(:,3) = 1;
        
    case 'square'
        
        %Get basis location
        lattice.basisVec = [0 0 0];
        
        %Get Lattice Sites
        latticeSites = generateLatticeSites(lattice);
        
        %Set disorder
        [latticeSites, radii, disorderSites] = setDisorder(lattice,latticeSites);
        
        %Set color for plot
        colors = zeros(size(latticeSites,1),3); %Blue
        colors(:,3) = 1;
        
    case 'fcc'
        
        %Get lattice Sites for 1st FCC lattice
        lattice.basisVec = [0 0 0];
        latticeSites = generateLatticeSites(lattice);
        [latticeSites, radii, disorderSites] = setDisorder(lattice,latticeSites);
        
        %Set color for plot
        colors = zeros(size(latticeSites,1),3); %Blue
        colors(:,3) = 1;
        
    case 'diamond'
        
        %Get lattice Sites for 1st FCC lattice
        lattice.basisVec = [0 0 0];
        latticeSites1 = generateLatticeSites(lattice);
        [latticeSites1, radii1, disorderSites1] = setDisorder(lattice,latticeSites1);
        colors = zeros(size(latticeSites1,1),3); %Blue
        colors(:,3) = 1;
        
        %Add 2nd interpenetrating FCC lattice, offset by a*(.25, .25, .25)
        lattice.basisVec =  lattice.a*[.25 .25 .25];
        latticeSites2 = generateLatticeSites(lattice);
        [latticeSites2, radii2, disorderSites2] = setDisorder(lattice,latticeSites2);
        colors2 = zeros(size(latticeSites2,1),3); %Green
        colors2(:,2) = 1;
        
        %Append 1st and second lattice
        latticeSites = [latticeSites1; latticeSites2];
        radii = [radii1; radii2];
        disorderSites = [disorderSites1; disorderSites2];
        colors = [colors; colors2];
        
        length(latticeSites)
        
    case 'hexagonal'
        
        %Get lattice Sites for lattice
        lattice.basisVec = [0 0 0];
        latticeSites  = generateLatticeSites(lattice);
        [latticeSites1, radii1, disorderSites1]  = setDisorder(lattice,latticeSites);
        colors = zeros(size(latticeSites1,1),3); %Blue
        colors(:,3) = 1;
        
        %Add 2nd interpenetrating lattice, offset by a*(.66, .33, .5)
        lattice.basisVec = lattice.a*(2/3*lattice.a1 + 1/3*lattice.a2 + .5*lattice.a3);
        latticeSites2 = generateLatticeSites(lattice);
        [latticeSites2, radii2, disorderSites2] = setDisorder(lattice,latticeSites2);
        colors2 = zeros(size(latticeSites2,1),3); %Green
        colors2(:,2) = 1;
        
        %Append 1st and second lattice
        latticeSites = [latticeSites1; latticeSites2];
        radii = [radii1; radii2];
        disorderSites = [disorderSites1; disorderSites2];
        colors = [colors; colors2];
        
        
    case 'random'
        %Determine particle number
        sz = lattice.maxBound - lattice.minBound;
        
        %Compute N based upon number of dimensions
        N = ceil(4*prod(sz(1:lattice.dimensionality)/lattice.a));
        
        %Initalize positions
        latticeSites = zeros(N,3);
        
        %Initalize colors
        colors = zeros(N,3);
        colors(:,3) = 1;
        
        %Initalize radii
        radii = lattice.radius*ones(N,1);
        
        %Loop over number of dimensions, set lattice sites
        for k = 1:lattice.dimensionality
            
            latticeSites(:,k) = sz(k)*rand(N,1)-sz(k)/2;
            
        end
        
        
    case 'rsa'
        %Determine particle number
        sz = lattice.maxBound - lattice.minBound;
        
        %Compute N based upon number of dimensions
        N = prod(sz(1:lattice.dimensionality)/lattice.a);
        
        %Initalize lattice sites array
        latticeSites = zeros(N,3);
        
        %Initalize colors
        colors = zeros(N,3);
        colors(:,3) = 1;
        
        %Initalize radii
        radii = lattice.radius*ones(N,1);
        
        numParticles = 0;
        
        %Keep adding particles until N is reached
        while(numParticles < N)
            
            %Generate coordinates for new particle
            x = sz(1)*rand(1)-sz(1)/2;
            y = sz(2)*rand(1)-sz(2)/2;
            z = sz(3)*rand(1)-sz(3)/2;
            
            pos = [x y z];
            
            %First particle
            if(numParticles == 0)
                numParticles = numParticles + 1;
                latticeSites(numParticles, :) = pos;
                
            else %See if particle is too close to any other
                
                %Get occupied sites:
                sites = latticeSites(1:numParticles, :);
                
                %Compute distance to each site
                dist = (sites - repmat(pos, [size(sites,1), 1])).^2;
                dist = sum(dist,2);
                
                %See if particle is further than 2 radii from all others
                if(min(dist)>2*lattice.radius)
                    numParticles = numParticles + 1;
                    latticeSites(numParticles,:) = pos;
                    
                end
                
            end
        end
        
end

% %New Figure
% figure;
% 
% %Set all figures to render with OpenGL
% set(0,'DefaultFigureRenderer','opengl');
% 
% %Plot lattice sites as scatter plot
% scatter3(latticeSites(:,1), latticeSites(:,2), latticeSites(:,3), 400, colors, 'filled');

end


function latPts = generateLatticeSites(lattice)

%Rotate lattice vectors (defaults to 0)
[a1, a2, a3, lattice] = rotateBasis(lattice);

%Check if constraints need to be defined
switch lattice.defineConstraintsFrom
    
    case 'bounds'
        lattice = setConstraintsFromBounds(lattice);
        
    case 'lattice vectors'
        lattice = setConstraintsFromLatticeVectors(lattice);
        
end

%Get min and max coefficients from bounds
[minCoeff, maxCoeff] = coeffFromBounds(lattice,a1,a2,a3);

mult = 1;
minCoeff = minCoeff*mult;
maxCoeff = maxCoeff*mult;

%Generate grid vectors for mesh grid
a1gv = minCoeff(1):maxCoeff(1);
a2gv = minCoeff(2):maxCoeff(2);
a3gv = minCoeff(3):maxCoeff(3);

%Get list of coefficients for a1 a2 and a3
[a1coeff, a2coeff, a3coeff] = meshgrid(a1gv, a2gv, a3gv);

%Get lattice points
latPts = a1coeff(:)*a1 + a2coeff(:)*a2 + a3coeff(:)*a3;

%Add basis location
latPts(:,1) = latPts(:,1) + lattice.basisVec(1) + lattice.basisPoint(1);
latPts(:,2) = latPts(:,2) + lattice.basisVec(2) + lattice.basisPoint(2);
latPts(:,3) = latPts(:,3) + lattice.basisVec(3) + lattice.basisPoint(3);

%Get lattice points satisfying constraints
latPts = pointCloud(latPts,lattice.constraints, lattice.point_tol);


end

function [a1, a2, a3, lattice] = rotateBasis(lattice)

%Get lattice vectors
a1 = lattice.a1;
a2 = lattice.a2;
a3 = lattice.a3;

% zero = [0 0 0];
% figure
%Plot vectors
% points = [zero; a1];
% plot3(points(:,1) , points(:,2), points(:,3), 'LineWidth', 2, 'Color' ,'r');
% hold on
% points = [zero; a2];
% plot3(points(:,1) , points(:,2), points(:,3), 'LineWidth', 2, 'Color' ,'r');
% points = [zero; a3];
% plot3(points(:,1) , points(:,2), points(:,3), 'LineWidth', 2, 'Color' ,'r');

%Check to see if lattice is being rotated to align to a vector
if(lattice.alignToVector)
    
    %Get Rotation matrix
    R = vecRotMat(lattice.alignToVectorLattice/norm(lattice.alignToVectorLattice), ...
        lattice.alignToVectorDirection/norm(lattice.alignToVectorDirection));
    
    %R = quaternion.rotateutov(lattice.alignToVectorLattice', lattice.alignToVectorDirection', 1,1);
    
    %Rotate lattice vectors
    a1 = R*a1';
    a2 = R*a2';
    a3 = R*a3';
    
    lattice.basisVec = R*lattice.basisVec';
    
    %Transpose back to row form
    a1 = a1';
    a2 = a2';
    a3 = a3';
    lattice.basisVec = lattice.basisVec';
    
end

% points = [zero; a1];
% plot3(points(:,1) , points(:,2), points(:,3), 'LineWidth', 2, 'Color' ,'b');
% points = [zero; a2];
% plot3(points(:,1) , points(:,2), points(:,3), 'LineWidth', 2, 'Color' ,'b');
% points = [zero; a3];
% plot3(points(:,1) , points(:,2), points(:,3), 'LineWidth', 2, 'Color' ,'b');

%Apply any roatations about the axes
a1 = rotate3D(a1,lattice.theta_X, lattice.theta_Y, lattice.theta_Z, true);
a2 = rotate3D(a2,lattice.theta_X, lattice.theta_Y, lattice.theta_Z, true);
a3 = rotate3D(a3,lattice.theta_X, lattice.theta_Y, lattice.theta_Z, true);
lattice.basisVec = rotate3D(lattice.basisVec, lattice.theta_X, lattice.theta_Y, lattice.theta_Z, true);


end

function lattice = setConstraintsFromBounds(lattice)

lattice.constraints = constraintBox(lattice.minBound, lattice.maxBound);

end

function [minCoeff, maxCoeff] = coeffFromBounds(lattice,a1, a2, a3)

%Initialize coefficients
minCoeff = zeros(3,1);
maxCoeff = zeros(3,1);

basisLoc = lattice.basisPoint + lattice.basisVec;

%Project basis point onto basis vectors
basis_proj = projectOntoBasis(basisLoc,a1,a2,a3);

%Bounds matrix
bounds = [lattice.minBound; lattice.maxBound];

for xBound = 1:2
    for yBound = 1:2
        for zBound = 1:2
            
            %Get bounding point
            x = bounds(xBound,1);
            y = bounds(yBound,2);
            z = bounds(zBound,3);
            point = [x y z];
            
            %Project point onto vectors
            point_proj = projectOntoBasis(point,a1,a2,a3);
            
            dist = point_proj - basis_proj;
            
            %Check if any of the distance values are infinite, set to zero
            for k = 1:3
                if(isinf(dist(k)))
                    dist(k) = 0;
                end
            end
            
            %Update X coeffs
            minCoeff(1) = min(minCoeff(1),dist(1));
            maxCoeff(1) = max(maxCoeff(1),dist(1));
            
            %Update Y coeffs
            minCoeff(2) = min(minCoeff(2),dist(2));
            maxCoeff(2) = max(maxCoeff(2),dist(2));
            
            %Update Z coeffs
            minCoeff(3) = min(minCoeff(3),dist(3));
            maxCoeff(3) = max(maxCoeff(3),dist(3));
            
        end
    end
end

%Get integer coefficients
minCoeff = floor(minCoeff);
maxCoeff = ceil(maxCoeff);

end
