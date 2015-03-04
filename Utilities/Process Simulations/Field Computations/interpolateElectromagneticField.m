function field = interpolateElectromagneticField(field, newField)
%This function interpolates an electromagnetic field onto the set of points
%in newField

%Loop over field

tic

for k = 1:length(field)
    
    field(k).E = interpolateVectorField(field(k).E, newField.E);
    field(k).D = interpolateVectorField(field(k).D, newField.D);
    field(k).H = interpolateVectorField(field(k).H, newField.H);
    field(k).B = interpolateVectorField(field(k).B, newField.B);
    
    %Normalize vector field
    field(k).normalize;
    
end

toc

end