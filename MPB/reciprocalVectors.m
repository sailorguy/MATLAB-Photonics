function [lattice] = reciprocalVectors(lattice)
%This function computes the reciprocol lattice vectors corresponding to a1,
%a2 and a3, which must be provided in row form

%Extract lattice vectors
a1 = lattice.a1;
a2 = lattice.a2;
a3 = lattice.a3;

a1 = a1';
a2 = a2';
a3 = a3';

%Compute[b1 b2 b3] = 2*pi*[a1 a2 a3]^-1
rLatVecs = 2*pi*inv([a1 a2 a3]);

%Extract vectors
lattice.b1 = rLatVecs(1,:);
lattice.b2 = rLatVecs(2,:);
lattice.b3 = rLatVecs(3,:);

end