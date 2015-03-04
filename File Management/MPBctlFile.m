function MPBctlFile(SimGroup)
%This file contains functions used to generate a .ctl file for inputting
%simulation parameters to MPB.
global fid

%Open .ctl file for writing
fid = fopen([SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/' SimGroup.name 'MPB.ctl'],'w');


%Setup lattice
geoLattice(SimGroup);

%Setup k-points
kPoints(SimGroup);

%Setup geometry
if(SimGroup.MPBSimulation.epsFileFlag)
    epsFile(SimGroup); %Use epsilon input file to define geometry
else
    geometry(SimGroup); %Use list of geometry objects to define geometry
end

%Set parameters
setParam(SimGroup);

%Run simulation
run(SimGroup);

%Close file
fclose(fid);


%This function writes the lattice paramaters to the .ctl file
function geoLattice(SimGroup)
global fid

%Leave space between sections
fprintf(fid,'\n');

switch SimGroup.MPBSimulation.dimensionality
    
      case '1D'
        
        fprintf(fid,'(set! geometry-lattice (make lattice\n');
        formatSpec = '\t\t\t\t(basis-size %.5f no-size no-size)\n';
        fprintf(fid,formatSpec, norm(SimGroup.lattice.a1));
        
        %Basis 1
        formatSpec = '\t\t\t\t(basis1 %.5f %.5f %.5f)\n';
        fprintf(fid,formatSpec, SimGroup.lattice.a1(1),...
            SimGroup.lattice.a1(2), SimGroup.lattice.a1(3));
        
        %Lattice size (defaults to 1 1 1)
        formatSpec = '\t\t\t\t(size %.5f no-size no-size)';
        fprintf(fid, formatSpec, SimGroup.lattice.a1_mult);

        fprintf(fid, '\t\t\t\t))\n');
    
    case '2D'
        
        fprintf(fid,'(set! geometry-lattice (make lattice ');
        formatSpec = '(size %.3f %.3f no-size)\n';
        fprintf(fid,formatSpec, norm(SimGroup.lattice.a1), ...
            norm(SimGroup.lattice.a2));
        
        %Basis 1
        formatSpec = '\t\t\t\t(basis1 %.3f %.3f)\n';
        fprintf(fid,formatSpec, SimGroup.lattice.a1(1),...
            SimGroup.lattice.a1(2));
        
        %Basis 2
        formatSpec = '\t\t\t\t(basis2 %.3f %.3f)\n';
        fprintf(fid,formatSpec, SimGroup.lattice.a2(1),...
            SimGroup.lattice.a2(2));
        
        %Lattice size (defaults to 1 1)
        formatSpec = '\t\t\t\t(size %.5f %.5f)';
        fprintf(fid, formatSpec, SimGroup.lattice.a1_mult,...
            SimGroup.lattice.a2_mult);
        
        
        fprintf(fid, '\t\t\t\t))\n');
        
        
    case '3D'
        
        fprintf(fid,'(set! geometry-lattice (make lattice\n');
        formatSpec = '\t\t\t\t(basis-size %.5f %.5f %.5f)\n';
        fprintf(fid,formatSpec, norm(SimGroup.lattice.a1), ...
            norm(SimGroup.lattice.a2), norm(SimGroup.lattice.a3));
        
        %Basis 1
        formatSpec = '\t\t\t\t(basis1 %.5f %.5f %.5f)\n';
        fprintf(fid,formatSpec, SimGroup.lattice.a1(1),...
            SimGroup.lattice.a1(2), SimGroup.lattice.a1(3));
        
        %Basis 2
        formatSpec = '\t\t\t\t(basis2 %.5f %.5f %.5f)\n';
        fprintf(fid,formatSpec, SimGroup.lattice.a2(1),...
            SimGroup.lattice.a2(2), SimGroup.lattice.a2(3));
        
        %Basis 3
        formatSpec = '\t\t\t\t(basis3 %.5f %.5f %.5f)\n';
        fprintf(fid,formatSpec, SimGroup.lattice.a3(1),...
            SimGroup.lattice.a3(2), SimGroup.lattice.a3(3));
        
        %Lattice size (defaults to 1 1 1)
        formatSpec = '\t\t\t\t(size %.5f %.5f %.5f)';
        fprintf(fid, formatSpec, SimGroup.lattice.a1_mult,...
            SimGroup.lattice.a2_mult, SimGroup.lattice.a3_mult);
        
        
        fprintf(fid, '\t\t\t\t))\n');
        
end

%Leave space between sections
fprintf(fid,'\n');

%This function writes the k-point values to the .ctl file
function kPoints(SimGroup)
global fid

%Leave space between sections
fprintf(fid,'\n');

formatSpec = '(set! k-points (interpolate %.1f (list\n';
fprintf(fid,formatSpec, SimGroup.MPBSimulation.kPointInterp);

for k = 1:length(SimGroup.MPBSimulation.kPoints)
    
    %Get current k-point object
    curKpt = SimGroup.MPBSimulation.kPoints(k);
    formatSpec = '\t\t\t\t(vector3 %.4f %.4f %.4f)\t; %s\n';
    fprintf(fid,formatSpec, curKpt.point(1), curKpt.point(2), ...
        curKpt.point(3), curKpt.name);
end

fprintf(fid, '\t\t\t\t)))\n');

%Leave space between sections
fprintf(fid,'\n');


%Write epsilon input file information
function epsFile(SimGroup)
global fid

%Leave space between sections
fprintf(fid,'\n');

fprintf(fid, '(set-param! epsilon-input-file "epsilon.h5")\n');

%Leave space between sections
fprintf(fid,'\n');


%Write geometry to .ctl file
function geometry(SimGroup)
global fid

geometry = SimGroup.geometry;

fprintf(fid,'(set! geometry (list ');

objectNum = length(geometry);

%Write geometry to file
for k = 1:objectNum
    fprintf(fid, geometry(k).MPBctlPrint);
end
fprintf(fid,'))\n');
        

%This function writes parameters (resolution, num-bands etc.) to the .ctl
%file
function setParam(SimGroup)
global fid

%Leave space between sections
fprintf(fid,'\n');

fprintf(fid, '(set-param! resolution %u)\n', SimGroup.MPBSimulation.resolution);
fprintf(fid, '(set-param! mesh-size %u)\n', SimGroup.MPBSimulation.meshSize);
fprintf(fid, '(set-param! num-bands %u)\n', SimGroup.MPBSimulation.numBands);

%Leave space between sections
fprintf(fid,'\n');


%This function writes the run commands to the .ctl file
function run(SimGroup)
global fid

%Leave space between sections
fprintf(fid,'\n');

switch SimGroup.MPBSimulation.dimensionality
    
    case '2D'
        
        %Run TE calculation
        fprintf(fid, '(run-te');
        
        %Output functions in use
        if(SimGroup.MPBSimulation.output_FLAG)
            for k = 1:length(SimGroup.MPBSimulation.output)
                fprintf(fid, '(%s)', SimGroup.MPBSimulation.output(k).outFcn);
            end
            
        end
        fprintf(fid, ')');
        
        %Run TM calculation
        fprintf(fid, '\n(run-tm');
        
        %Output functions in use
        if(SimGroup.MPBSimulation.output_FLAG)
            for k = 1:length(SimGroup.MPBSimulation.output)
                fprintf(fid, '(%s)', SimGroup.MPBSimulation.output(k).outFcn);
            end
            
        end
        fprintf(fid, ')');
        
    case '3D'
        
        fprintf(fid, '(run');
        
        %Output functions in use
        if(SimGroup.MPBSimulation.output_FLAG)
            for k = 1:length(SimGroup.MPBSimulation.output)
                fprintf(fid, '(%s)', SimGroup.MPBSimulation.output(k).outFcn);
            end
            
        end 
        fprintf(fid, ')');
        
end

%Leave space between sections
fprintf(fid,'\n');





