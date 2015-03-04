function [data, datasetFound] = readHDF5(file,dataset)
%This function reads a dataset from an HDF5 file

%Default to return failure
datasetFound = false;

%Empty return data
data = [];

%Get info on the H5 file
info = h5info(file);

file

%Check to see if the requested dataset is present
for k = 1:length(info.Datasets)
    
   if(strcmp(dataset, info.Datasets(k).Name))
       datasetFound = true;
       break;
       
   end
end

%Read data if the dataset exists
if(datasetFound)
   
    data = h5read(file,['/' dataset]);
    
end