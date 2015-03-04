function addEpsilonDataMEEP

global simCount
simCount = 0;

%Parent directory for simulations
parentDirectory = 'W:\scratch\simulation\Resonance\IDO\R-0.250_epsS-13.0_epsL-1.0\DefectRadius-0.000';

%Process all simulations in parent directory
isFolderSim(parentDirectory);

end


function isFolderSim(parentDirectory)

%Get listing of all directories
listing = dir(parentDirectory);


%Loop over all directories in parent directory
for k = 3:length(listing)
    
    %Sim folder
    simFolder = [parentDirectory '/' listing(k).name];
    
    %Matfile
    matFile = [simFolder '/save/' listing(k).name '.mat'];
    
    %Check if current listing is a simulation
    if(listing(k).isdir && exist(matFile, 'file'))
        
        %Read data
        temp = load(matFile);
        SimGroup = temp.SimGroup;
        
        %Epsilon file
        epsilonFile = [simFolder '/data/' SimGroup.name '-eps-000000.00.h5'];

        %Attempt to read epsilon data
        [epsilonData, datasetFound] = readHDF5(epsilonFile, 'eps' );
       
        if(~datasetFound)
            return;
        end
        
        %Get listing of files
        folder = [simFolder '/data'];
        files = dir(folder);
        
        for q = 1:length(files)
           
            %Check if file is a .h5 file
            if(length(files(q).name) > 2 && strcmp('.h5', files(q).name(length(files(q).name) - 2: length(files(q).name))))
                
                %Add epsilon dataset
                writeHDF5([folder '/' files(q).name], 'epsilon', epsilonData);
            end
        end
  
        %Make recursive call on non-simulation directories
    elseif(listing(k).isdir)
        isFolderSim([parentDirectory '/' listing(k).name])
        
    end
end
end

