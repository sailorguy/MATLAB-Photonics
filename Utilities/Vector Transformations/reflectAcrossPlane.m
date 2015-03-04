function [points] = reflectAcrossPlane(points, plane)
%This function reflects the points across the plane described by a
%PlaneObj. Points is a list of vectors, in row form


%Ref(v) = v - 2*(v*a-c)a/(a*a)

%Create matrix of normal vectors
A = repmat(plane.norm, size(points,1),1);

%Create matrix of points on plane
C = repmat(plane.pt,size(points,1),1);

Acoeff = 2*((points-C)*plane.norm')/(plane.norm*plane.norm');

Acoeff = repmat(Acoeff,1,size(A,2));

points = points - Acoeff.*A;

end