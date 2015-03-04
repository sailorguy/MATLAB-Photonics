function SimDataDisplay (folderPath, newFigure)
%This function updates the main viewer window with information about the
%currently selected simulation that exists at folderPath
global SimViewer_g

flagFound = false; %Flag to indicate simualtion was found-- shouldn't be needed unless error occured elsewhere

%Identify index of simulation
for k = 1:length(SimViewer_g.SimGroup)
    if(strcmp(folderPath, SimViewer_g.SimGroup(k).SVpath))
        flagFound = true;
        break;
    end
end

%If simulation wasn't found, return. Should not happen.
if(~flagFound)
    return
end

%Set current folder path to indicate what simulation is currently being
%displayed
SimViewer_g.currentFolderPath = folderPath;

textArray = SimViewer_g.SimGroup(k).print;

set(SimViewer_g.main_h.SimDisplay, 'String', char(textArray));


%Plot simulation geometry
if(~newFigure)
    %Set main figure to be current window
    set(0, 'CurrentFigure', SimViewer_g.main_h.SimViewerMain)
else
    %Plot in new figure for export/saving
    figure
end

%Get geometry data
h = SimViewer_g.SimGroup(k).plotGeometry;
geoPlotHandles = h;

%Add planes to show source, reflectance

%Loop over all sources
for m = 1:length(SimViewer_g.SimGroup(k).sources)
    
    %Get size of source
    size = SimViewer_g.SimGroup(k).sources(m).size;
    
    %Get origin of source
    origin = SimViewer_g.SimGroup(k).sources(m).center;
    
    %Check if simulation is 2D
    if(SimViewer_g.SimGroup(k).simulation.lat(3) == 0)
        origin(3) = 0;
        size(3) = 2; %Set size in Z dierction to make source visible
        %Legacy support for souces without explictly defined Z value
    elseif ~isempty(SimViewer_g.SimGroup(k).sources(m).center(3))
        origin(3) = SimViewer_g.SimGroup(k).sources(m).center(3);
    else
        origin(3) = 0;
    end
    
    %Set transparency for source
    transparency = .3;
    
    %Set Color for source
    color = [1 0 1];
    
    %Draw source
    h = drawRect(origin,size,transparency,color, 1);
    geoPlotHandles = [geoPlotHandles; h];
end

%Loop over all flux regions
for m = 1:length(SimViewer_g.SimGroup(k).simulation.fluxRegion)
    
    %Get size of flux region
    size = SimViewer_g.SimGroup(k).simulation.fluxRegion(m).size;
    
    %Get origin of flux region
    origin = SimViewer_g.SimGroup(k).simulation.fluxRegion(m).center;
    
    %Check if simulation is 2D
    if(SimViewer_g.SimGroup(k).simulation.lat(3) == 0)
        origin(3) = 0;
        size(3) = 2; %Set size in Z dierction to make source visible
        %Legacy support for flux regions without explictly defined Z value
    elseif ~isempty(SimViewer_g.SimGroup(k).simulation.fluxRegion(m).center(3))
        origin(3) = SimViewer_g.SimGroup(k).simulation.fluxRegion(m).center(3);
    else
        origin(3) = 0;
    end
    
    %Set transparency for flux region
    transparency = .3;
    
    %Set Color for fluxregion
    color = [0 1 0];
    
    h = drawRect(origin,size,transparency,color, 1);
    geoPlotHandles = [geoPlotHandles; h];
    
end


%Calculate axis scaling
xmin = -1*SimViewer_g.SimGroup(k).simulation.lat(1)/2 - SimViewer_g.SimGroup(k).lattice.radius;
xmax = SimViewer_g.SimGroup(k).simulation.lat(1)/2 + SimViewer_g.SimGroup(k).lattice.radius;
ymin = -1*SimViewer_g.SimGroup(k).simulation.lat(2)/2 - SimViewer_g.SimGroup(k).lattice.radius;
ymax = SimViewer_g.SimGroup(k).simulation.lat(2)/2 + SimViewer_g.SimGroup(k).lattice.radius;
zmin = -1*SimViewer_g.SimGroup(k).simulation.lat(3)/2 - SimViewer_g.SimGroup(k).lattice.radius;
zmax = SimViewer_g.SimGroup(k).simulation.lat(3)/2 + SimViewer_g.SimGroup(k).lattice.radius;

%Check if simulation is 2D (simulation.lat.Z = 0)
if(SimViewer_g.SimGroup(k).simulation.lat(3) == 0)
    %Square view of 2D-cell in Y-Z plane
    zmin = ymin;
    zmax = ymax;
end

%Scale axis to fit cell
axis([xmin xmax ymin ymax zmin zmax]);
axis equal

%Add plot labels
title('Simulation Geometry', 'FontSize', 16);
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14, 'Rotation', 0);
set(gca, 'FontSize', 13);

h = legend(geoPlotHandles,'Structure', 'Source', 'Flux Plane');
set(h,'FontSize', 14);

%Allow 3d rotation
rotate3d on


%disp(SimViewer_g.SimGroup(k).simulation);

end