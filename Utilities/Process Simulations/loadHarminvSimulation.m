function [Sims, simNumber] = loadHarminvSimulation(parentDirectory)
global simCount
global SimGroup
simCount = 0;

SimGroup = SimGroupObj;

%Process all simulations in parent directory
isFolderSim(parentDirectory);

%Display number of simulations found for resubmission
simCount

%Return SimGroup
Sims = SimGroup;

simNumber = simCount;
end

function isFolderSim(parentDirectory)

%Get listing of all directories
listing = dir(parentDirectory);

%Loop over all directories in parent directory
for k = 1:length(listing)
    
    if( ~strcmp(listing(k).name, '.') && ~strcmp(listing(k).name, '..'))
        
        %Check if current listing is a simulation
        if(listing(k).isdir && exist([parentDirectory '/' listing(k).name '/save/' listing(k).name '.mat'], 'file'))
            
            %Process found simulations
            processSimulation(parentDirectory,listing(k));
            
            %Make recursive call on non-simulation directories
        elseif(listing(k).isdir)
            isFolderSim([parentDirectory '/' listing(k).name])
            
        end
        
    end
end
end

function processSimulation(parentDirectory,listing)
global simCount
global SimGroup

simFolder = [parentDirectory '/' listing.name];

%Check if simulation has completed
if(exist([simFolder '/output/out.txt'],'file'))
    
    %Load SimGroup for simulation
    matFile = [simFolder '/save/' listing.name '.mat'];
    temp = load(matFile);
    
    %Attempt to load Harminv data
    [temp.SimGroup, dataFound] = readHarminvData([simFolder '/output/out.txt'], temp.SimGroup);

    if(~dataFound) %No data, don't load this simulation
        return;
    end

    %Increment simCount;
    simCount = simCount + 1;
   
    %Store SimGroup
    SimGroup(simCount) = temp.SimGroup;
    
    
end
end
