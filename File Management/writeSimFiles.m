function writeSimFiles(SimGroup)
%This function creates the simulation directories (specified in simulation)
%and writes the input files for the simulation (.ctl files and .pbs
%scripts)

%Close any open files
fclose('all');

%Create directory structure
%/Simulation <-- accessible from cluster (i.e /home/data/Simulation)
%   /fooSim  <-- contains all inputs and outputs for a single simulation run
%       /data --> .h5 data files
%       /output --> output and output error files from .pbs script
%       /save --> save data structures from Matlab here
%       fooSim.pbs
%       fooSim.ctl


%Make /fooSim
folder = [SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name];
if(~exist(folder, 'dir'))
    mkdir(folder);
end

%Make /data
folder = [SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/data'];
if(~exist(folder, 'dir'))
    mkdir(folder);
end

%Make /output
folder = [SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/output'];
if(~exist(folder, 'dir'))
    mkdir(folder);
end

%Make /save
folder = [SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/save'];
if(~exist(folder, 'dir'))
    mkdir(folder);
end

switch SimGroup.type
    
    case 'MEEP'
        
        %Don't create second pbs file for reflectance runs
        if(~SimGroup.simulation.normalization)
            %Create .pbs file
            pbsScript(SimGroup);
        end
        
        %Create .ctl file
        ctlFile(SimGroup,SimGroup.simulation,SimGroup.geometry,SimGroup.sources);
        
    case 'MPB'
        
        %Create pbs file
        pbsScript(SimGroup);
        
        %Write .ctl file
        MPBctlFile(SimGroup);
        
        %Check if epsilon input file is in use
        if(SimGroup.MPBSimulation.epsFileFlag)
            hdf5write([SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/epsilon.h5'],...
                '/eps',SimGroup.MPBSimulation.epsFile)
            
        end
        
end

%Save data structures
 save([SimGroup.localPath '/' SimGroup.dir '/' ...
     SimGroup.name '/save/' SimGroup.name '.mat'], 'SimGroup'); 
 
 