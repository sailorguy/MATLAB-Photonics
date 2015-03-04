function ReflectancePlotUpdate(btnPress)
%This function updates the plot(s) by checking for which SimGroups are
%selected, importing any data as needed and replotting the results.
%If the newFigure flag is set, the plot is directed to a new figure to
%facilitate saving as an image

global SimViewer_g

%Update SimViewer_g with current plot control values
reflectanceControlsUpdate;

%Reset the color spec inUse flags
resetColorFlags;

%Reset legend data arrays
SimViewer_g = SimViewer_g.clearReflectanceLegendData;

switch btnPress
    
    case 'normal'
        %Set band window to be current figure, clear axes
        set(0, 'CurrentFigure', SimViewer_g.reflectance_h);
        cla;
        
        %Force painters
        set(gcf, 'Renderer', 'painters');
        
        %Process Sim Groups
        checkSimGroups;
        
    case 'exportFigure'
        
        %Create new figure
        figure;
        
        %Force painters
        set(gcf, 'Renderer', 'painters');
        
        %Process Sim Groups
        checkSimGroups;
        
    case 'printPDF'
        
        %Create new figure
        figure;
        
        %Force painters
        set(gcf, 'Renderer', 'painters');
        
        %Process Sim Groups
        checkSimGroups;
        
        %Print to PDF
        set(gcf, 'PaperPositionMode', 'auto', 'PaperType', 'C');
        set(gcf, 'Position', [200 200 1400 900]);
        %set(gcf, 'Position', [200 200 800 600]);
        print(gcf, 'MEEPPlot.pdf', '-dpdf')
        close;
        
    case 'printEPS'
        
        %Create new figure
        figure;
        
        %Force painters
        set(gcf, 'Renderer', 'painters');
        
        %Process Sim Groups
        checkSimGroups;
        
        %Print to EPS
        set(gcf, 'PaperPositionMode', 'auto', 'PaperType', 'C');
        set(gcf, 'Position', [200 200 800 600]);
        print(gcf, 'MEEPPlot.eps', '-depsc2')
        close;
        
end

end

function checkSimGroups
global SimViewer_g

%Loop over all imported SimGroups
for k = 1:length(SimViewer_g.SimGroup)
    
    %Check if simulation is an MPB simulation
    if(~strcmp(SimViewer_g.SimGroup(k).type,'MPB'))
        
        %Check to see if the group is checked
        if(SimViewer_g.SimGroup(k).checked)
            
            %Check if dataset is loaded
            if(~SimViewer_g.SimGroup(k).reflData_FLAG)
                %Load data set
                loadReflectanceData(k)
            end
            
            %Plot data
            drawPlotElements(k)
            
        end
    end
end

%Format plot
formatReflectancePlot

%Sort legend entries based upon user specification
[~,IX] = sort(SimViewer_g.reflectanceLegendNumbers);

if(isempty(SimViewer_g.reflectanceHandles))
    
    %Hide legend if there are no entries
    legend('hide')
else
    
    %Add sorted legend to plot
    legend(SimViewer_g.reflectanceHandles(IX), SimViewer_g.reflectanceNames(IX), 'Location', 'SouthEast', 'FontSize', 11, 'FontWeight', 'demi');
    
    %Make sure legend is visible
    legend('show')

end
end

function loadReflectanceData(k)
%Function loads reflectance data into SimViewer_g.SimGroup(k)
global SimViewer_g

%Get file names
folder = SimViewer_g.SimGroup(k).SVpath;
normFile = [folder '/output/norm.txt'];
reflFile = [folder '/output/refl.txt'];

%Switch on MEEP simulation type
switch SimViewer_g.SimGroup(k).simulation.type
    
    case 'Reflection'
        
        if(~SimViewer_g.SimGroup(k).averagedData) %Normal run, no averaging
            
            %Read normalization and reflectance flux data
            SimViewer_g.SimGroup(k).normFlux = FluxRead(normFile);
            SimViewer_g.SimGroup(k).reflFlux = FluxRead(reflFile);
                     
        end
        
        %Compute reflectance/transmissison
        [SimViewer_g.SimGroup(k).normFreq, SimViewer_g.SimGroup(k).reflectance] = computeReflectance(SimViewer_g.SimGroup(k).normFlux, SimViewer_g.SimGroup(k).reflFlux);
        [~, SimViewer_g.SimGroup(k).transmission] = computeTransmission(SimViewer_g.SimGroup(k).normFlux,  SimViewer_g.SimGroup(k).reflFlux);
        
        if(SimViewer_g.SimGroup(k).averagedData)
            
            %Compute average
             [SimViewer_g.SimGroup(k).normFreq, SimViewer_g.SimGroup(k).reflectance, SimViewer_g.SimGroup(k).transmission]...
                 = averageReflectanceData2( SimViewer_g.SimGroup(k).normFreq, SimViewer_g.SimGroup(k).reflectance, SimViewer_g.SimGroup(k).transmission);
        end
        
    case 'SingleRunTransmission'
        
        %Read reflectance flux data
        SimViewer_g.SimGroup(k).reflFlux = FluxRead(reflFile);
        SimViewer_g.SimGroup(k).normFlux = ones(size(SimViewer_g.SimGroup(k).reflFlux));
        
        %Get single run transmisison
        [SimViewer_g.SimGroup(k).normFreq, SimViewer_g.SimGroup(k).transmission] = computeSingleRunTransmission(SimViewer_g.SimGroup(k).reflFlux);
        
        %Set reflectance data to 1 - transmission
        SimViewer_g.SimGroup(k).reflectance = 1 - SimViewer_g.SimGroup(k).transmission;
        
end

%Ensure data does not contain negative frequency values
xData = SimViewer_g.SimGroup(k).normFreq(SimViewer_g.SimGroup(k).normFreq >= 0);
reflectance = SimViewer_g.SimGroup(k).reflectance(SimViewer_g.SimGroup(k).normFreq >= 0);
transmission = SimViewer_g.SimGroup(k).transmission(SimViewer_g.SimGroup(k).normFreq >= 0);

%Define plot element obj
SimViewer_g.SimGroup(k).plotElement = PlotElementObj;
%Reflectance
SimViewer_g.SimGroup(k).plotElement(1).dataType = 'Reflectance';
SimViewer_g.SimGroup(k).plotElement(1).name = 'Reflectance';
SimViewer_g.SimGroup(k).plotElement(1).type = 'Primary Data';
SimViewer_g.SimGroup(k).plotElement(1).xData = xData;
SimViewer_g.SimGroup(k).plotElement(1).yData = reflectance;
SimViewer_g.SimGroup(k).plotElement(1).color = getDataSetColor(k);
SimViewer_g.SimGroup(k).plotElement(1).visible = false;
SimViewer_g.SimGroup(k).plotElement(1).lineStyle = 'none';
SimViewer_g.SimGroup(k).plotElement(1).markerType = 'o';

%Transmission
SimViewer_g.SimGroup(k).plotElement(2).dataType = 'Reflectance';
SimViewer_g.SimGroup(k).plotElement(2).name = 'Transmission';
SimViewer_g.SimGroup(k).plotElement(2).type = 'Primary Data';
SimViewer_g.SimGroup(k).plotElement(2).xData = xData;
SimViewer_g.SimGroup(k).plotElement(2).yData = transmission; 
SimViewer_g.SimGroup(k).plotElement(2).color = getDataSetColor(k);
SimViewer_g.SimGroup(k).plotElement(2).visible = true;
SimViewer_g.SimGroup(k).plotElement(2).lineStyle = 'none';
SimViewer_g.SimGroup(k).plotElement(2).markerType = 'o';

%Loss
SimViewer_g.SimGroup(k).plotElement(3).dataType = 'Reflectance';
SimViewer_g.SimGroup(k).plotElement(3).name = 'Loss';
SimViewer_g.SimGroup(k).plotElement(3).type = 'Primary Data';
SimViewer_g.SimGroup(k).plotElement(3).xData = xData;
SimViewer_g.SimGroup(k).plotElement(3).yData = 1 - transmission - reflectance; 
SimViewer_g.SimGroup(k).plotElement(3).color = getDataSetColor(k);
SimViewer_g.SimGroup(k).plotElement(3).visible = false;
SimViewer_g.SimGroup(k).plotElement(3).lineStyle = 'none';
SimViewer_g.SimGroup(k).plotElement(3).markerType = 'o';


%Update flag to indicate data has been loaded
SimViewer_g.SimGroup(k).reflData_FLAG = true;

end

function formatReflectancePlot
global SimViewer_g

%Format axis
%Font
set(gca, 'FontSize', 14, 'FontName', 'Helvetica', 'FontWeight', 'Normal');

%Axis properties
set(gca, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.02 .02],...
    'XMinorTick', 'on', 'YMinorTick', 'on');

%Axis labels
%X-Axis
if(SimViewer_g.normfreq)
    xlabel( '\omegaa/2\pic', 'FontSize', 15); %Plot by frequency
    xmin = SimViewer_g.normfreqmin;
    xmax = SimViewer_g.normfreqmax;
else
    xlabel( 'Wavelength (um)', 'FontSize', 15); %Plot by wavelength
    xmin = SimViewer_g.wavelengthmin;
    xmax = SimViewer_g.wavelengthmax;
end

%Set up X ticks
numTicks = 10;

%Get range for ticks
range = xmax - xmin;

mantissa = range/(10^floor(log10(range)));
interval = (floor(mantissa)/numTicks)*10^floor(log10(range));

xticks = xmin:interval:xmax;

set(gca,'XTick', xticks);

%Y-Axis
ylabel( 'Transmitted Power', 'FontSize', 13, 'FontWeight', 'light');

%Set axis limits
ymin = SimViewer_g.rcoeffmin;
ymax = SimViewer_g.rcoeffmax;
axis( [xmin xmax ymin ymax ]);

end


function color = getDataSetColor(k)
%Function gets currently assigned dataset color or assigns a new one if no
%color is currently in use or not yet asssigned
global SimViewer_g


%Check if color has already been assigned to dataset
if(~isempty(SimViewer_g.SimGroup(k).colorNum))
    
    %Check if color is already in use, loop over all color choices
    if(~SimViewer_g.reflectanceColors(SimViewer_g.SimGroup(k).colorNum).inUse)
        
        %Color is not currently in use, assign it to current  data set
        SimViewer_g.reflectanceColors(SimViewer_g.SimGroup(k).colorNum).inUse = true;
        
        %Return  color RGB value
        color = SimViewer_g.reflectanceColors(SimViewer_g.SimGroup(k).colorNum).RGB;
        return
        
    end
end

%Dataset has no color, or color already assigned is currently in use
%Attempt to assign other unused color:

%Loop over all color values
for m = 1:length(SimViewer_g.reflectanceColors)
    
    %Check if value is in use
    if(~SimViewer_g.reflectanceColors(m).inUse)
        %Value not in use, assign to dataset
        SimViewer_g.SimGroup(k).colorNum = m;
        
        %Color is now in use
        SimViewer_g.reflectanceColors(m).inUse = true;
        
        %Get color RGB value
        color = SimViewer_g.reflectanceColors(SimViewer_g.SimGroup(k).colorNum).RGB;
        return;
    end
end
%All colors already in use, assign one randomly

numColors = length(SimViewer_g.reflectanceColors)-1;

color = SimViewer_g.reflectanceColors(floor(numColors*rand + 1)).RGB;
end


function resetColorFlags
%This function resets the inUse flag for color spec objects
global SimViewer_g

for k = 1:length(SimViewer_g.reflectanceColors)
    
    SimViewer_g.reflectanceColors(k).inUse = false;
    
end
end

