function vecField = loadHDF5VectorData(file, vecField)

%Read x data
dataset = [vecField.name 'x.r'];
[xReal, found] = readHDF5(file,dataset);

dataset = [vecField.name 'x.i'];
[xImag, found] = readHDF5(file,dataset);

%Read y data
dataset = [vecField.name 'y.r'];
[yReal, found] = readHDF5(file,dataset);

dataset = [vecField.name 'y.i'];
[yImag, found] = readHDF5(file,dataset);

%Read z data
dataset = [vecField.name 'z.r'];
[zReal, found] = readHDF5(file,dataset);

dataset = [vecField.name 'z.i'];
[zImag, found] = readHDF5(file,dataset);

%Store data in vector field
vecField.X = xReal + 1i*xImag;
vecField.Y = yReal + 1i*yImag;
vecField.Z = zReal + 1i*zImag;

%Permute the data to account for inexplicable!! HDF5 formatting of (Z,Y,X)
%(for 3D field only)
if(length(size(vecField.X)) == 3)
    vecField.X = permute(vecField.X, [3 2 1]);
    vecField.Y = permute(vecField.Y, [3 2 1]);
    vecField.Z = permute(vecField.Z, [3 2 1]);
end

%Set loaded flag to indicate data has been loaded
vecField.loaded = true;


end