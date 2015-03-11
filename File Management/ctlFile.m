%This file contains functions used to generate a  .ctl file for inputting
%simulation parameters to MEEP.
%Materials, Geometry and Simulation are data structures containing fields
%that describe those parameters. Sim is a switch variable that is used to
%call the correct sub-function for the simulatio under consideration.


%Main function, serves to route calls to appropriate sub-functions and
%performs primary file operations
function ctlFile(Sims, simulation,geometry,sources)
global fid
global SimGroup

SimGroup = Sims;

if(simulation.normalization)
    %Normalization file
    fid= fopen([SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/' SimGroup.name 'Norm.ctl'],'w');
    
else
    %Standard simulation run
    fid= fopen([SimGroup.localPath '/' SimGroup.dir '/' SimGroup.name '/' SimGroup.name '.ctl'],'w');
end

%Set resolution
setParam('resolution', simulation.resolution);

%Set Courant factor
setParam('Courant', simulation.courantFactor);

%Epsilon averaging
if(~SimGroup.simulation.epsAvg)
    CTLset('eps-averaging?', 'false');
end

%Force complex fields
if(SimGroup.simulation.forceComplexFields)
    CTLset('force-complex-fields?', 'true');
end

%Define Lattice Geometry
geoLattice(simulation);

%Define elements
CTLgeometry();

%Define PML Layers
BoundaryConditions(simulation);

%Define Sources
CTLsources(sources);

%Set Output Directory
fprintf(fid, ['\n(use-output-directory "' SimGroup.dir '/' SimGroup.name '/data")\n']);

%Set Filename prefix
%fprintf(fid, ['(set! filename-prefix "' SimGroup.name '")\n']);

switch simulation.type
    
    case 'Bands'
        Band(geometry, sources, simulation);
    case 'Reflection'
        Reflectance(geometry,sources,simulation);
    case 'SingleRunTransmission'
        SingleRunTransmission(geometry,sources,simulation);
    case 'Modes'
        Modes(geometry, sources, simulation);
    
end

fclose(fid);

%Funaction for handling band structures
function Band(geometry, sources, simulation)
global fid

%Define symmetries
%fprintf(fid, '(set! symmetries (list (make mirror-sy, (directionY) (phase -1))))\n');

defineParam('kx','false');
defineParam('k-interp', 19);

%Write code to generate Band structure
formatSpec = '(if kx \n (begin \n (set! k-point (vector3 kx)) \n (run-sources+\n';
fprintf(fid,formatSpec);
formatSpec = '300 (at-beginning output-epsilon) \n (after-sources (harminv Hz (vector3 %f %f) %f %f)))\n';
fprintf(fid, formatSpec, simulation.harminvCenter.X, simulation.harminvCenter.Y, sources(1).fcen, sources(1).df);
formatSpec = '(run-until(/1 %f) (at-every (/1 %f 20) output-hfield-z)))';
fprintf(fid, formatSpec, sources(1).fcen, sources(1).fcen);
formatSpec = '(run-k-points 300 (interpolate k-interp (list (vector3 %f) (vector3 %f)))))';
fprintf(fid, formatSpec, simulation.kmin, simulation.kmax);


%Function for handling structure reflectance
function Reflectance(geometry, sources, simulation)
global fid

%Define flux regions
fluxRegion(simulation);

%Switch based on normalization run
switch simulation.normalization
    
    case true %Normalization run
        runSources(simulation);
        fprintf(fid, '(save-flux "refl-flux" refl)');
        fprintf(fid, '(display-fluxes trans refl)');
        
    case false %Standard simulation run
        fprintf(fid, '(load-minus-flux "refl-flux" refl)');
        runSources(simulation);
        fprintf(fid, '(display-fluxes trans refl)');
end

function SingleRunTransmission(geometry, sources, simulation)
global fid

%Define flux regions
fluxRegion(simulation);     

%Run sources, display flux
runSources(simulation);
fprintf(fid, '(display-fluxes trans refl)');


function Modes(geometry, sources, simulation)
global fid
    
    runSources(simulation);


%Function for running sources
function runSources(simulation)
global fid;
global SimGroup;

switch simulation.runType
    
    case 'run-until'
        fprintf(fid, '(run-until ');
        
    case 'run-sources'
        fprintf(fid, '(run-sources ');
        
    case 'run-sources+'
        fprintf(fid, '(run-sources+ ');
        
end

switch simulation.runTermination
    
    case 'time'
        fprintf(fid, '%f', simulation.runTime);
        
    case 'field-decay'
        fprintf(fid, '(stop-when-fields-decayed  %f %s ', simulation.fieldDecay.dT, simulation.fieldDecay.component);
        fprintf(fid,'(vector3 %f %f %f) %s)', ...
        simulation.fieldDecay.pt.X, simulation.fieldDecay.pt.Y, simulation.fieldDecay.pt.Z, simulation.fieldDecay.tolerance);
        
end

%Call function to write output, no output on normalization runs
if(simulation.outputFlag && ~simulation.normalization)
    simOutput(simulation);
end

%Write harminv commands if in use
if(simulation.harminv)
    
    %Loop over all harminv objects
    for k = 1:length(SimGroup.harminv)
    
        fprintf(fid, '\n(after-sources %s)', SimGroup.harminv(k).ctlPrint);

    end
end

fprintf(fid,')\n');

%Function for identifying simulation outputs
function simOutput(simulation)
global fid

%Loop over defined outputs
for k = 1:length(simulation.output)
    %Check to make sure output is in use (should only be problem for first
    %output if undefined)
    if(~strcmp(simulation.output(k).outFcn,''))
        closingParen = '';
        %Loop over all step function modifiers
        for c = 1:length(simulation.output(k).StepMod)
            %Check to see if output modifiers are in use
            if(simulation.output(k).StepMod(c).flag == true)
                fprintf(fid, '(');
                fprintf(fid,'%s', simulation.output(k).StepMod(c).ctlPrint);
                closingParen = [closingParen ')'];
            end
        end
        
        %Check to see if output is a field, which is treated differently
        switch simulation.output(k).outFcn
            case 'field'
                fprintf(fid,' output-%sfield',simulation.output(k).field);
                if(~strcmp(simulation.output(k).component,''))
                    fprintf(fid,'-%s',simulation.output(k).component);
                end
                
            otherwise
                %Write non-field output command
                fprintf(fid,' output-%s',simulation.output(k).outFcn);
                
        end
        fprintf(fid, [closingParen '\n']);
    end
    
end

%Function for defining flux regions
function fluxRegion(simulation)
global fid

for k = 1:length(simulation.fluxRegion)
    
    fR = simulation.fluxRegion(k);
    
    fprintf(fid, '(define %s (add-flux %f %f %u', fR.name, fR.fcen, fR.df, fR.nfreq);
    fprintf(fid, '(make flux-region(center %f %f %f) (size %f %f %f) (direction %s) (weight %f))\n))\n',...
        fR.center(1), fR.center(2), fR.center(3), fR.size(1), ...
        fR.size(2), fR.size(3), fR.direction, fR.weight);
end


%Function for writing boundary conditions to file
function BoundaryConditions(simulation)
global fid

if(simulation.PML.usePML)
    fprintf(fid, '(set! pml-layers (list\n');
    
    if(simulation.PML.Xh.thickness ~= 0)
        setPML(simulation.PML.Xh);
    end
    if(simulation.PML.Xl.thickness ~= 0)
        setPML(simulation.PML.Xl);
    end
    
    if(simulation.PML.Yh.thickness ~= 0)
        setPML(simulation.PML.Yh);
    end
    if(simulation.PML.Yl.thickness ~= 0)
        setPML(simulation.PML.Yl);
    end
    
    if(simulation.PML.Zh.thickness ~= 0)
        setPML(simulation.PML.Zh);
    end
    if(simulation.PML.Zl.thickness ~= 0)
        setPML(simulation.PML.Zl);
    end
    
    fprintf(fid, '))\n');
    
end


%Write periodic boundary conditions if flag is set
if(simulation.kPoint_FLAG)
    fprintf(fid, '(set! k-point (vector3 %f %f %f))\n', simulation.kPoint.X, simulation.kPoint.Y, simulation.kPoint.Z);
end

fprintf(fid, '(set! ensure-periodicity false)\n'); %Turn off automatic geometric object repeating-- completely worthless "feature" JK 2012


%Function for writing individual PML layers
function setPML(PML)
global fid

fprintf(fid,'(make pml (direction %s ) (thickness %f) (side %s) (strength %f) (R-asymptotic %s) (pml-profile %s))\n',...
    PML.direction, PML.thickness, PML.side, PML.strength, PML.rAsymptotic, PML.profile );

%Write geometry to .ctl file
function CTLgeometry()
global fid
global SimGroup

if(~SimGroup.simulation.normalization && SimGroup.simulation.epsInputFile) %Check for epsilon input file in use on reflctance run)
    fprintf(fid, ['(set! epsilon-input-file "' SimGroup.dir '/' SimGroup.name '/epsilon.h5")\n\n']);
else
    fprintf(fid,'(set! geometry (list ');
    
    if(SimGroup.simulation.normalization)
        objectNum = SimGroup.simulation.geometryNormalizationLimit;
    else
        objectNum = length(SimGroup.geometry);
    end
    
    %Write geometry to file
    for k = 1:objectNum
        fprintf(fid, SimGroup.geometry(k).ctlPrint);
    end
    fprintf(fid,'))\n');
end


%Write sources to .ctl file
function CTLsources(sources)
global fid

%Print any custom-src functions (does nothing if there are no custom-src)
for k = 1:length(sources)
   
    fprintf(fid, sources(k).customSource(k)); %Pass k as source index to index functions...ugh
    
end

fprintf(fid,'(set! sources (list ');

for k = 1:length(sources)

    fprintf(fid,sources(k).ctlPrint(k));
    
end

fprintf(fid,'))\n');


%Write geometry-lattice command to .ctl file
function geoLattice(simulation)
global fid

if( simulation.lat(1) == 0)
    strX = 'no-size';
else
    strX = num2str(simulation.lat(1));
end

if( simulation.lat(2) == 0)
    strY = 'no-size';
else
    strY = num2str(simulation.lat(2));
end

if( simulation.lat(3) == 0)
    strZ = 'no-size';
else
    strZ = num2str(simulation.lat(3));
end


formatSpec = '\n(set! geometry-lattice (make lattice (size %s %s %s)))\n';

str = sprintf(formatSpec, strX, strY, strZ);

fprintf(fid, str);

%Write single parameter line to .ctl file
function defineParam(name, value)
global fid

if(isnumeric(value))
    value = num2str(value);
end

formatSpec = '(define-param %s %s)\n';

fprintf(fid, formatSpec, name, value);

%Write set a single parameter in the .ctl file
function setParam(name, value)
global fid

if(isnumeric(value))
    value = num2str(value);
end

formatSpec = '(set-param! %s %s)\n';

fprintf(fid, formatSpec, name, value);

%Write set! command to .ctl file
function CTLset(name, value)
global fid

formatSpec = '(set! %s %s)\n';

fprintf(fid, formatSpec, name, value);
