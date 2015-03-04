function constraints = constraintBox(minPt, maxPt)
%This function constructs a set of PlaneConstraintObj that define a
%rectangular region spanning minPt and maxPt



%Define planar constraints
% -X
constraints(1).dir = -1;
constraints(1).norm = [-1 0 0];
constraints(1).pt = [minPt(1) 0 0];


% +X
constraints(2).dir = -1;
constraints(2).norm = [1 0 0];
constraints(2).pt = [maxPt(1) 0 0];


% -Y
constraints(3).dir = -1;
constraints(3).norm = [0 -1 0];
constraints(3).pt = [0 minPt(2) 0];


% +Y
constraints(4).dir = -1;
constraints(4).norm = [0 1 0];
constraints(4).pt = [0 maxPt(2) 0];


% -Z
constraints(5).dir = -1;
constraints(5).norm = [0 0 -1];
constraints(5).pt = [0 0 minPt(3)];


% +Z
constraints(6).dir = -1;
constraints(6).norm = [0 0 1];
constraints(6).pt = [0 0 maxPt(3)];




end