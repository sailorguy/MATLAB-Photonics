function [points, indices] = pointCloud(points,constraints, tol)
%This function takes a point cloud and returns only the points that satisfy
%the specified planar constraints, along with the corresponding indicies in
%the original array

%Return original points if constraints are empty
if(length(constraints) == 1 && isempty(constraints(1).dir))
    
    indices = 1:size(points,1);
    
    return    
end

%Get X,Y,Z coordinates
X = points(:,1);
Y = points(:,2);
Z = points(:,3);

%Initalize indicies
indices = ones(size(X));

%Loop over all constraints
for k = 1:length(constraints)
    
    %Get normal vector to plane
    normal = constraints(k).norm;
    
    %Get point on plane
    pt = constraints(k).pt;
    
    %Get direction (above/below)
    dir = constraints(k).dir;
    
    %Compute distance between each point in cloud and plane along each
    %coordinate
    xDist = (X - pt(1))*normal(1);
    yDist = (Y - pt(2))*normal(2);
    zDist = (Z - pt(3))*normal(3);
    
    %Compute total signed distance
    dist = (xDist+yDist+zDist)*dir;
    
    %Add small value to capture points that are on a boundary,
    dist = dist + tol;
    
    %Flag indices for points outside current constraint object
    indices(dist<0) = 0;
    
end

indices = find(indices);

X = X(indices);
Y = Y(indices);
Z = Z(indices);

%Combine final X, Y, Z vectors
points = [X Y Z];

end