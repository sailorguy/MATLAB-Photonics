function [pts_rot] = rotate3D(pts, theta_X, theta_Y, theta_Z, deg)
%This function performs a gimble rotation on an array of 3-vectors, in row
%form

%Check if angles are in degrees
if(deg)
    theta_X = pi*theta_X/180;
    theta_Y = pi*theta_Y/180;
    theta_Z = pi*theta_Z/180;
end

%Construct rotation matricies
Rx = [1             0               0
      0         cos(theta_X)   -sin(theta_X)
      0         sin(theta_X)    cos(theta_X)];
  
Ry = [cos(theta_Y)  0           sin(theta_Y)
      0             1               0
     -sin(theta_Y)  0           cos(theta_Y)];
 
Rz = [cos(theta_Z) -sin(theta_Z)    0
      sin(theta_Z)  cos(theta_Z)    0
      0             0               1];
  
 %Transpose rotation matricies to account for use of row vectors
 R = Rx'*Ry'*Rz'; 
 
 %Compute rotated points
 pts_rot = pts*R;