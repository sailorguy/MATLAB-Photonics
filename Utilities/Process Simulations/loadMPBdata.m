function loadMPBdata()

path = 'W:\gpfstest\MPB\1D\R-0.217_epsS-1.0_epsL-13.0\1D-R-0.217_epsS-1.0_epsL-13.0_a-1.000';
simName = '1D-R-0.217_epsS-1.0_epsL-13.0_a-1.000';

matFile = [path '/save/' simName '.mat'];

field = ElectromagneticFieldObj;
SimGroup = SimGroupObj;

%Load matlab data file
temp = load(matFile);
SimGroup = temp.SimGroup;

%Get file listing
listing = dir(path);
MPBData = ElectromagneticFieldObj;

index = 1;
figure

for k = 1:length(listing)
    
    if(listing(k).isdir)
        continue
    end
    
    file = [path '\' listing(k).name];
    
    %Get file extension
    [pathstr,name,ext] = fileparts(file);

    %0pen .h5 files
    if(strcmp(ext, '.h5'));
        
        [data, datasetFound] = readHDF5(file, 'data-new');
        
        %Store data, if found
        if(datasetFound)
            
            MPBData(index).magnitude = data/max(data);
            
            hold on
            plot(MPBData(index).magnitude);
            
            index = index + 1;
        end
        
        
    end
    
end

end


