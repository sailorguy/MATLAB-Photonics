function [eps] = geometry2matrix(SimGroup)

%Get resolution
res = SimGroup.simulation.resolution;

%Compute range of X,Y and Z
xMin = -1*SimGroup.simulation.lat(1)/2;
xMax = SimGroup.simulation.lat(1)/2;
yMin = -1*SimGroup.simulation.lat(2)/2;
yMax = SimGroup.simulation.lat(2)/2;
zMin = -1*SimGroup.simulation.lat(3)/2;
zMax = SimGroup.simulation.lat(3)/2;

%Get grid of coordinates
[X,Y,Z] = meshgrid(xMin:1/res:xMax, yMin:1/res:yMax, zMin:1/res:zMax);

%Store gridsize for reshaping eps matrix
gridSize = size(X);

%Reshape point arrays into vectors
X = X(:);
Y = Y(:);
Z = Z(:);

%Create epsilon matrix
eps = ones(gridSize);
eps = eps(:);

%Loop over geometry objects
for k = 1:length(SimGroup.geometry)
    
    %Get center for geometric object, in terms of matrix coordinates
    center = SimGroup.geometry(k).center;

    switch SimGroup.geometry(k).type
        
        case 'block'
            
            boxSize = SimGroup.geometry(k).size;
            
            %Get corners of box
            minPt = center - boxSize/2;
            maxPt = center + boxSize/2;
            
            %Get constraints corresponding to box
            constraints = constraintBox(minPt,maxPt);
            
            [~,indices] = pointCloud([X,Y,Z],constraints, .1/res);
            
            eps(indices) = SimGroup.geometry(k).epsilonRE;
            
            
        case 'sphere'

            %Compute distance between points in box and center
            distance = sqrt((X - center(1)).^2 + (Y - center(2)).^2 + (Z - center(3)).^2);
               
            %Set epsilon values
            eps(distance<SimGroup.geometry(k).radius) = SimGroup.geometry(k).epsilonRE;
            
    end
    
end

%Reshape epsilon back into array
eps = reshape(eps,gridSize);