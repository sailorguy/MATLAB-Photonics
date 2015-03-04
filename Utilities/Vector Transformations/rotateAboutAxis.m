function [points] = rotateAboutAxis(points, axis, theta, deg)
%This function rotates the points around the given axis, by the specified
%angle

%Convert to radians if needed
if(deg)
    theta = pi*theta/180;
end

%Get rotation matrix
R = RotationMatrix(quaternion.angleaxis(theta,axis));

%Compute rotated points
points = points*R;

end