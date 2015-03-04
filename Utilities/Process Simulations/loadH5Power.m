function loadH5Power()

path = 'W:\gpfstest\1D\MPBW:\gpfstest\MPB\IHO\R-0.500_epsS-1.0_epsL-13.0';
simName = 'IHO-R-0.500_epsS-1.0_epsL-13.0_a-1.000';

dataPath = [path '\data'];

matFile = [path '/save/' simName '.mat'];

field = ElectromagneticFieldObj;
SimGroup = SimGroupObj;

%Load matlab data file
temp = load(matFile);
SimGroup = temp.SimGroup;

%Get file listing
listing = dir(dataPath);
PowerData = 0;

index = 1;

for k = 1:length(listing)
    
    if(listing(k).isdir)
        continue
    end
    
    file = [dataPath '\' listing(k).name];
    
    %Get file extension
    [pathstr,name,ext] = fileparts(file);

    %0pen .h5 files
    if(strcmp(ext, '.h5'));
        
        [data, datasetFound] = readHDF5(file, 'sx');
        
        %Store data, if found
        if(datasetFound)
            
            PowerData = data;
            index = index + 1;
            
        end
        
        
    end
    
    
end

figure
plot(PowerData(1:500,1,1));


