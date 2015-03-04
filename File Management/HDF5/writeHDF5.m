function writeHDF5(file, dataset, data)

%Default to failure
datasetFound = false;

%Check to see if the file exists
if(~exist(file, 'file'))
    %Create file
    h5create(file, ['/' dataset], size(data));
    
    %File exists, check to see if the dataset path exists
else
    info = h5info(file);
    
    %Check to see if the requested dataset is present
    for k = 1:length(info.Datasets)
        
        if(strcmp(dataset, info.Datasets(k).Name))
            datasetFound = true;
            break;
            
        end
    end
    
    %Dataset doesn't exist, create
    if(~datasetFound)
        h5create(file, ['/' dataset], size(data));
    end
    
    
end

%Write data into file
h5write(file,['/' dataset], data);
  
    
end