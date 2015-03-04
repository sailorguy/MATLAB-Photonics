function lattice = setConstraintsFromLatticeVectors(lattice)

%Get lattice vectors
a1 = lattice.a1;
a2 = lattice.a2;
a3 = lattice.a3;

%Cell is centered around 0
%Get min point
minPt = -.5*(a1*lattice.a1_mult + a2*lattice.a2_mult + a3*lattice.a3_mult);
maxPt = .5*(a1*lattice.a1_mult + a2*lattice.a2_mult + a3*lattice.a3_mult);

%Set lattice bounds
lattice.minBound = minPt;
lattice.maxBound = maxPt;

%Check if we have a 1D lattice
if(strcmp(lattice.type, '1D'))
    
    %Set constraints perpendicular to lattice vector
    lattice.constraints(1).dir = 1;
    lattice.constraints(1).norm = a1;
    lattice.constraints(1).pt = minPt;
    
    lattice.constraints(2).dir = -1;
    lattice.constraints(2).norm = a1;
    lattice.constraints(2).pt = maxPt;
 
    return
end

%Define planar constraints (min point near lower left)

%3  distinct normals
normalVecs = [cross(a1,a2);
              cross(a1,a3);
              cross(a2,a3)];

%Standardize vector direction
for k = 1:size(normalVecs,1)
   
    %Get curent vector
    vec = normalVecs(k,:);
    
    %Distance between plane and origin
    originDist = vec*(-1*minPt')/norm(vec);
    
    %Set vector to be inward facing
    if(originDist < 0) 
        normalVecs(k,:) = -1*vec;
    end
  
end

%Define plane constraints
   
%Plane 1
lattice.constraints(1).dir = 1;
lattice.constraints(1).norm = normalVecs(1,:);
lattice.constraints(1).pt = minPt;

%Plane 2
lattice.constraints(2).dir = 1;
lattice.constraints(2).norm = normalVecs(2,:);
lattice.constraints(2).pt = minPt;
 
%Plane 3
lattice.constraints(3).dir = 1;
lattice.constraints(3).norm = normalVecs(3,:);
lattice.constraints(3).pt = minPt;

%Plane 4
lattice.constraints(4).dir = -1;
lattice.constraints(4).norm = normalVecs(1,:);
lattice.constraints(4).pt = maxPt;

%Plane 5
lattice.constraints(5).dir = -1;
lattice.constraints(5).norm = normalVecs(2,:);
lattice.constraints(5).pt = maxPt;

%Plane 6
lattice.constraints(6).dir = -1;
lattice.constraints(6).norm = normalVecs(3,:);
lattice.constraints(6).pt = maxPt;



end

