function SimGroup = kPointCloud(SimGroup)
%This function generates a k-point cloud according to the constraints and
%point density specified in MPBSimulationObj


%Get bounding points for generating point cloud
minVec = SimGroup.MPBSimulation.minBound.getVec;
maxVec = SimGroup.MPBSimulation.maxBound.getVec;

%Compute number of points in each direction to satisfy point density
xVec = linspace(minVec(1), maxVec(1), ceil((maxVec(1) - minVec(1))*SimGroup.MPBSimulation.pointDensityDOS));
yVec = linspace(minVec(2), maxVec(2), ceil((maxVec(2) - minVec(2))*SimGroup.MPBSimulation.pointDensityDOS));
zVec = linspace(minVec(3), maxVec(3), ceil((maxVec(3) - minVec(3))*SimGroup.MPBSimulation.pointDensityDOS));

%Reshape point arrays
xVec = reshape(xVec,size(xVec,1)*size(xVec,2)*size(xVec,3),1);
yVec = reshape(yVec,size(yVec,1)*size(yVec,2)*size(yVec,3),1);
zVec = reshape(zVec,size(zVec,1)*size(zVec,2)*size(zVec,3),1);

%Compute point cloud
[X,Y,Z] = meshgrid(xVec, yVec, zVec);

%Reshape point arrays
X = reshape(X,size(X,1)*size(X,2)*size(X,3),1);
Y = reshape(Y,size(Y,1)*size(Y,2)*size(Y,3),1);
Z = reshape(Z,size(Z,1)*size(Z,2)*size(Z,3),1);

[points, indices] = pointCloud([X,Y,Z], SimGroup.MPBSimulation.constraints, .001);

X = points(:,1);
Y = points(:,2);
Z = points(:,3);

%Get reciprocal lattice vectors
b1 = SimGroup.lattice.b1;
b2 = SimGroup.lattice.b2;
b3 = SimGroup.lattice.b3;

%Dot k points with reciprocal vectors
kPts_b1 = (b1(1)*X + b1(2)*Y + b1(3)*Z);
kPts_b2 = (b2(1)*X + b2(2)*Y + b2(3)*Z);
kPts_b3 = (b3(1)*X + b3(2)*Y + b3(3)*Z);

%Form "solution" matrix for transform
kPts = [kPts_b1 kPts_b2 kPts_b3];

%Form transformation matrix
T = [b1*b1' b2*b1' b3*b1'
    b1*b2' b2*b2' b3*b2'
    b1*b3' b2*b3' b3*b3'];

%Solve system for coordinates of reciprocal vectors
kPts = kPts/T;

%Recover k-points in terms of kx, ky, kz to verify
kPts_xyz = kPts(:,1)*b1 + kPts(:,2)*b2 + kPts(:,3)*b3;

scatter3(kPts_xyz(:,1),kPts_xyz(:,2),kPts_xyz(:,3), 'MarkerEdgeColor', 'b');


%Set k-point values
for k = 1:length(kPts)
    
    
    SimGroup.MPBSimulation.kPoints(k).point = [kPts(k,1) kPts(k,2) kPts(k,3)];
    SimGroup.MPBSimulation.kPoints(k).index  = k;
    
    
end

