function field = fieldDecomposition(field,basis)
%This function decomposes each of the fields into the set of basis fields.
%The fields are assumed to be normalized.

basisE = VectorFieldObj;

%Extract E field from basis
for k = 1:length(basis)
   
    basisE(k) = basis(k).E;
    
end
%Loop over fields
for k = 1:length(field)
    
    field(k).coeff = projectVectorField(field(k).E, basisE);

end
end
