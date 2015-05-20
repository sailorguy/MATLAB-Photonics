function checkSimulationCompletion
global simCount
simCount = 0;
global SimGroup
global localPath;
localPath = 'W:/';
global pbsQueue
pbsQueue = 'iw-shared-6';
global pbsNodes
pbsNodes = 256;
global walltime
walltime = 12;
%Parent directory for simulations
parentDirectory = [localPath 'gpfs-scratch\IDO\Clean\Test'];

%Allowed runID's
allowedRunID = [1 2 3 4 5];

%Delete queue file
if(exist([localPath '/data/qf.sh'], 'file'))
    delete([localPath '/data/qf.sh']);
end

%Process all simulations in parent directory
% isFolderSim(parentDirectory, allowedRunID);

%Display number of simulations found for resubmission
simCount

end

function isFolderSim(parentDirectory, allowedRunID)

%Get listing of all directories
listing = dir(parentDirectory);

%Loop over all directories in parent directory
for k = 1:length(listing)
    
    if( ~strcmp(listing(k).name, '.') && ~strcmp(listing(k).name, '..'))
        
        %Check if current listing is a simulation
        if(listing(k).isdir && exist([parentDirectory '/' listing(k).name '/save/' listing(k).name '.mat'], 'file'))
            
            runID = getRunIDFromFolderName(listing(k).name);
            
            if(ismember(runID, allowedRunID))
                
                %Process found simulations
                processSimulation(parentDirectory,listing(k));
                
            end
            
            %Make recursive call on non-simulation directories
        elseif(listing(k).isdir)
            isFolderSim([parentDirectory '/' listing(k).name], allowedRunID)
            
        end
        
    end
end
end

function processSimulation(parentDirectory,listing)
global simCount
global SimGroup
global localPath
global pbsQueue
global pbsNodes
global walltime
simFolder = [parentDirectory '/' listing.name];

%Check if the normalization run completed
if(checkSimRun([simFolder '/output/norm.txt']))
    
    %Check if reflection run completed
    if(checkSimRun([simFolder '/output/refl.txt']))
        %Both runs completed, do nothing
        return
        
    else %Reflectance run didn't complete, resubmit reflectance
        
        %Delete out, error and reflectance files
        file = [simFolder '/output/out.txt']; %out.txt
        if(exist(file, 'file'))
            delete(file);
        end
        
        file = [simFolder '/output/error.txt']; %error.txt
        if(exist(file, 'file'))
            delete(file);
        end
        
        file = [simFolder '/output/refl.txt']; %refl.txt
        if(exist(file, 'file'))
            delete(file);
        end
        
        %Load simulation data
        temp = load([simFolder '/save/' listing.name '.mat']);
        SimGroup = temp.SimGroup;
        
        %Only rerun reflectance calculation
        SimGroup.simulation.reflOnly = true;
        
        %Check if first simualtion run, if so, discard shell script
        if(simCount == 0)
            SimGroup.pbs.discard = true;
        else
            SimGroup.pbs.discard = false;
        end
        
        
        %Update local path
        SimGroup.localPath = localPath;
        
        %Modify .pbs settings
        SimGroup.pbs.queue = pbsQueue;
        SimGroup.pbs.nodes = pbsNodes;
        SimGroup.pbs.walltime = walltime;
        
        %Resubmit
        writeSimFiles(SimGroup);
        simCount = simCount+1;
        
        display('Reflectance run');
        display(simFolder)
        
        %Resubmit complete
        return
        
    end
end

%Normalization run didn't complete or no out.txt, resubmit whole simulation

%Load simulation data
temp = load([simFolder '/save/' listing.name '.mat']);
SimGroup = temp.SimGroup;

%Check if first simualtion run, if so, discard shell script
if(simCount == 0)
    SimGroup.pbs.discard = true;
else
    SimGroup.pbs.discard = false;
end

%Update local path
SimGroup.localPath = localPath;

%Modify .pbs settings
SimGroup.pbs.queue = pbsQueue;
SimGroup.pbs.nodes = pbsNodes;
SimGroup.pbs.walltime = walltime;

%Resubmit
writeSimFiles(SimGroup);
simCount = simCount+1;

display('Normalization run');
display(simFolder)

end

function runID =  getRunIDFromFolderName(folder)

%Find all the "_", the last of which will prefix the runID

k = strfind(folder, '_');

%Get runID, convert to number
runID = str2num(folder(k(length(k))+1:length(folder)));

end


