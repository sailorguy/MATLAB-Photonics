function [X] = projectVectorField(field,basis)
%This function takes a VectorFieldObj, and a list of basis VectorFieldObj
%and performs a least squares fit of the field onto the basis. The
%coefficients of the fit are stored in the basis array and returned. This
%is accomplished by solving the massively overdetermined system AX = B

%Reshape field arrays
fieldX = reshape(field.X, numel(field.X), 1);
fieldY = reshape(field.Y, numel(field.Y), 1);
fieldZ = reshape(field.Z, numel(field.Z), 1);

%Append field arrays to construct "B" matrix
B = [fieldX; fieldY; fieldZ];


%Construct fitting matrix, with length(field) rows and length(basis) columns
A = zeros(length(B),length(basis));

%Loop over all basis vector fields to populate fitting matrix A
for k = 1:length(basis)
    
    %Reshape basis arrays
    basisX = reshape(basis(k).X, numel(basis(k).X), 1);
    basisY = reshape(basis(k).Y, numel(basis(k).Y), 1);
    basisZ = reshape(basis(k).Z, numel(basis(k).Z), 1);
    
    %Append basis arrays
    basisXYZ = [basisX; basisY; basisZ];
    
    %Insert current basis elements into A matrix
    A(:,k) = basisXYZ;
    
end

%Solve over determined system by least squares
X = A\B;

end
