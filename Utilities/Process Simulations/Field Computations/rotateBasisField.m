function [field] = rotateBasisField(inField,direction, kDirection, latticeType)
%This function takes a field initally aligned in [direction], corresponding
%to [kDirection] and roatates it to align with all other degenerate
%directions

%Initalize output
field = ElectromagneticFieldObj;

%Create lattice object
lattice = latticeGenObj;
lattice.a = 1;
lattice.type = latticeType;
lattice = lattice.setLattice;

%Get Field Points
Epts = inField.E.ptVec;
Dpts = inField.D.ptVec;
Hpts = inField.H.ptVec;
Bpts = inField.B.ptVec;


%Get critical points 
CPts = lattice.getCPtsXYZ(kDirection);

%Loop over CPts
for k = 1:size(CPts,1)
    
    %Set Field to be equal to inField
    field(k) = inField;
    
    %Compute rotation of direction onto CPts(k,:)
    R = vecRotMat(direction/norm(direction), CPts(k,:)/norm(CPts(k,:)));
    
    %Rotate and store points
    pts = R*Epts';
    field(k).E = field(k).E.setPtsVec(pts');
    
    pts = R*Dpts';
    field(k).D = field(k).D.setPtsVec(pts');
    
    pts = R*Hpts';
    field(k).H = field(k).H.setPtsVec(pts');
    
    pts = R*Bpts';
    field(k).B = field(k).B.setPtsVec(pts');
    
    %Set name for field
    field(k).name = sprintf('%s [%.3f %.3f %.3f]', kDirection, CPts(k,1), CPts(k,2), CPts(k,3));
    
end
end