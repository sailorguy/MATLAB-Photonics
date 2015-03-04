function addEpsilonDataMPB

global simCount
simCount = 0;

%Parent directory for simulations
parentDirectory = 'W:\data\simulation\MPB\Diamond\InverseOpal\FieldMap';

%Process all simulations in parent directory
isFolderSim(parentDirectory);

end


function isFolderSim(parentDirectory)

%Get listing of all directories
listing = dir(parentDirectory);


%Loop over all directories in parent directory
for k = 3:length(listing)
    
    %Check if current listing is a simulation
    if(listing(k).isdir && exist([parentDirectory '/' listing(k).name '/save/' listing(k).name '.mat'], 'file'))
        
        epsilonFile = [parentDirectory '/' listing(k).name '/epsilon.h5'];
        
        %Attempt to read epsilon data
        [epsilonData, datasetFound] = readHDF5(epsilonFile, 'epsilon.xx-new' );
       
        if(~datasetFound)
            return;
        end
        
        %Compute fft of epsilon data
        epsFFT = fftn(epsilonData);
        
        %Write fft to epsilon file
        writeHDF5(epsilonFile, 'fft', epsFFT);
        
        %Get listing of files
        folder = [parentDirectory '/' listing(k).name];
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

