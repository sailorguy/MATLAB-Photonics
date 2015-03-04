function newField = interpolateVectorField(field, newField)
%This function takes a vector field described by field, and interpolates
%its data onto the points of newField

%Get input and output point arrays
pts = field.ptVec;
newPts = newField.ptVec;

%Create scattered interpolants
Fx = scatteredInterpolant(pts, reshape(field.X,numel(field.X),1));
Fy = scatteredInterpolant(pts, reshape(field.Y,numel(field.Y),1));
Fz = scatteredInterpolant(pts, reshape(field.Z,numel(field.Z),1));

%Evaluate interpolants at newPts, save to newField
newField.X = reshape(Fx(newPts),size(newField.ptX,1), size(newField.ptX,2), size(newField.ptX,3));
newField.Y = reshape(Fy(newPts),size(newField.ptX,1), size(newField.ptX,2), size(newField.ptX,3));
newField.Z = reshape(Fz(newPts),size(newField.ptX,1), size(newField.ptX,2), size(newField.ptX,3));

end