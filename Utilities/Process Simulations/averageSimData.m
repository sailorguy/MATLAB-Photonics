function averageSimData
global simCount
simCount = 0;
global localPath;
localPath = 'W:/';

%Parent directory for simulations
parentDirectory = [localPath 'gpfstest\IDO\Clean\X\Reflectance-band-src\R-0.250_epsS-13.0_epsL-1.0\Occupancy-T1000'];

%Process all simulations in parent directory
isFolderSim(parentDirectory);

simCount

end


function isFolderSim(parentDirectory)
global simCount

%Get listing of all directories
listing = dir(parentDirectory);

%Initalize dataset storage
norm_data = [];
refl_data = [];

%Loop over all directories in parent directory
for k = 1:length(listing)
    
    if( ~strcmp(listing(k).name, '.') && ~strcmp(listing(k).name, '..'))
        
        %Check if current listing is a simulation
        if(listing(k).isdir && exist([parentDirectory '/' listing(k).name '/save/' listing(k).name '.mat'], 'file'))
            
            %Process found simulation
            [norm_flux, refl_flux, dataFound] = getSimData(parentDirectory,listing(k));
            
            %Check if data sets were found
            if(dataFound)
                
                simCount = simCount + 1;
                
                %Take middle 80% of data
                lowIndex  = uint16(round(.1*length(norm_flux)));
                highIndex = uint16(round(.9*length(norm_flux)));
                
                norm_flux = norm_flux(lowIndex:highIndex,:);
                refl_flux = refl_flux(lowIndex:highIndex,:);
                
                %Append data
                if(isempty(norm_data)) %First data set
                    norm_data = norm_flux;
                    refl_data = refl_flux;
                else
                    %Subsequent data set
                    norm_data = [norm_data; norm_flux];
                    refl_data = [refl_data; refl_flux];
                end
                
            end
            
            %Make recursive call on non-simulation directories
        elseif(listing(k).isdir)
            isFolderSim([parentDirectory '/' listing(k).name])
            
        end
    end
end

%Check if data has been collected
if(~isempty(norm_data))
    
    %Build folder structure
    folder = [parentDirectory '/Average'];
    if(~exist(folder, 'dir'))
        mkdir(folder);
    end
    
    %Save data
    save([parentDirectory '/Average/average_data.mat'], 'norm_data', 'refl_data');
    
end

end

function [norm_flux,refl_flux, dataFound] = getSimData(parentDirectory,listing)

simFolder = [parentDirectory '/' listing.name];

dataFound = false;
norm_flux = [];
refl_flux = [];

%Check if simulation has completed
if(exist([simFolder '/output/out.txt'],'file'))
     
    %Attempt to read normalization data
    [norm_flux, fluxFound] = FluxRead([simFolder '/output/norm.txt']);
    
    if(~fluxFound) %No data in file
        return;
    else
        %Attempt to read reflectance data
        [refl_flux, fluxFound] = FluxRead([simFolder '/output/refl.txt']);
        
        if(~fluxFound) %No data in file
            return;
        end
    end
    if(length(norm_flux) == length(refl_flux))
        dataFound = true;
    else
        
        simFolder

    end
end

end

