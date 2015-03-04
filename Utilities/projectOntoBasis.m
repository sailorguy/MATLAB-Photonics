function [projPoints] = projectOntoBasis(points,a1, a2, a3)

%Get X, Y, Z points
X = points(:,1);
Y = points(:,2);
Z = points(:,3);

%Dot points with basis vectors
points_a1 = (a1(1)*X + a1(2)*Y + a1(3)*Z);
points_a2 = (a2(1)*X + a2(2)*Y + a2(3)*Z);
points_a3 = (a3(1)*X + a3(2)*Y + a3(3)*Z);

%Form "solution" matrix
projPoints = [points_a1 points_a2 points_a3];

%Form transformation matrix
T = [a1*a1' a2*a1' a3*a1'
     a1*a2' a2*a2' a3*a2'
     a1*a3' a2*a3' a3*a3'];

%Solve system for coordinates in projected basis
projPoints = T\projPoints';
 
projPoints(isnan(projPoints)) = 0;

projPoints = projPoints';
end