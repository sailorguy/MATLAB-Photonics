function BandPlotUpdate(btnPress)
%This function updates the plot(s) by checking for which SimGroups are
%selected, importing any data as needed and replotting the results.
%If the newFigure flag is set, the plot is directed to a new figure to
%facilitate saving as an image

global SimViewer_g

%Update SimViewer_g with current plot control values
bandControlsUpdate;

%Reset the color spec inUse flags
resetColorFlags;

%Reset legend data arrays
SimViewer_g = SimViewer_g.clearBandLegendData;

switch btnPress
    
    case 'normal'
        %Set band window to be current figure, clear axes
        set(0, 'CurrentFigure', SimViewer_g.band_h);
        cla;
        
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
        
        %Print to EPS
        set(gcf, 'PaperPositionMode', 'auto', 'PaperType', 'C');
        set(gcf, 'Position', [200 200 1600 1000]);
        set(gcf, 'Position', [200 200 900 700]);
        print(gcf, 'MPBPlot.pdf', '-dpdf')
        close;
        
    case 'printEPS'
        
        %Create new figure
        figure;
        
        %Force painters
        set(gcf, 'Renderer', 'opengl');
        
        
        %Process Sim Groups
        checkSimGroups;
        
        %Print to EPS
        set(gcf, 'PaperPositionMode', 'auto', 'PaperType', 'C');
        set(gcf, 'Position', [200 200 800 600]);
        print(gcf,'-r1000', 'MPBPlot.jpeg', '-djpeg')

        close;
        
end

end

function checkSimGroups
global SimViewer_g

%Flag to indicate there are MPB simulations
MPBsim = false;

%Loop over all imported SimGroups
for k = 1:length(SimViewer_g.SimGroup)
    
    %Check to see if the group is checked
    if(SimViewer_g.SimGroup(k).checked)
        
        %Check if simulation is an MPB simulation
        if(strcmp(SimViewer_g.SimGroup(k).type,'MPB'))
            
            %Check if dataset is loaded
            if(~SimViewer_g.SimGroup(k).MPBData_FLAG)
                %Load data set
                loadBandData(k)
            end
            
            %Plot data
            drawPlotElements(k)
            
            %Set flag to indicate MPB simulations are present
            MPBsim = true;
            
        end     
    end
end

if(MPBsim)
    %Format plot
    formatBandPlot
    
    %Sort legend entries based upon user specification
    [~,IX] = sort(SimViewer_g.bandLegendNumbers);
    
    if(isempty(SimViewer_g.bandHandles))
        
        %Hide legend if there are no entries
        legend('hide')
    else
        
        %Add sorted legend to plot
        legend(SimViewer_g.bandHandles(IX), SimViewer_g.bandNames(IX), 'Location', 'SouthEast', 'FontSize', 11, 'FontWeight', 'demi');
        
        %Make sure legend is visible
        legend('show')
    end
    
end
end

function loadBandData(k)
%Function loads reflectance data into SimViewer_g.SimGroup(k)
global SimViewer_g

%Handle 2D and 3D simulations differently due to polarizations
switch SimViewer_g.SimGroup(k).MPBSimulation.dimensionality
    
    case '2D'
                
        %Get file names
        folder = SimViewer_g.SimGroup(k).SVpath;
        MPBFreqsTE = [folder '/output/MPBFreqsTE.txt'];
        MPBFreqsTM = [folder '/output/MPBFreqsTM.txt'];
        
        %Read TE frequency data
        SimViewer_g.SimGroup(k).MPBdata(1).polarization = 'TE';
        [SimViewer_g.SimGroup(k).MPBdata(1).kDist, SimViewer_g.SimGroup(k).MPBdata(1).kPoints, SimViewer_g.SimGroup(k).MPBdata(1).bands] = MPBFreqRead(MPBFreqsTE);
        
        %Read TM frequency data
        SimViewer_g.SimGroup(k).MPBdata(2).polarization = 'TM';
        [SimViewer_g.SimGroup(k).MPBdata(2).kDist, SimViewer_g.SimGroup(k).MPBdata(2).kPoints, SimViewer_g.SimGroup(k).MPBdata(2).bands] = MPBFreqRead(MPBFreqsTM);
        
    case '3D'
        
        %Get file names
        folder = SimViewer_g.SimGroup(k).SVpath;
        MPBFreqs = [folder '/output/MPBFreqs.txt'];
        
        %Read frequency data
        SimViewer_g.SimGroup(k).MPBdata.polarization = 'none';
        [SimViewer_g.SimGroup(k).MPBdata.kDist, SimViewer_g.SimGroup(k).MPBdata.kPoints, SimViewer_g.SimGroup(k).MPBdata.bands] = MPBFreqRead(MPBFreqs);
        
end

%Loop over loaded data sets
for m = 1:length(SimViewer_g.SimGroup(k).MPBdata)

    %Define plot element obj
    SimViewer_g.SimGroup(k).plotElement(m) = PlotElementObj;
    SimViewer_g.SimGroup(k).plotElement(m).dataType = 'Bands';
    SimViewer_g.SimGroup(k).plotElement(m).name = ['Bands-' SimViewer_g.SimGroup(k).MPBdata(m).polarization];
    SimViewer_g.SimGroup(k).plotElement(m).type = 'Primary Data';
    SimViewer_g.SimGroup(k).plotElement(m).kDist = SimViewer_g.SimGroup(k).MPBdata(m).kDist;
    SimViewer_g.SimGroup(k).plotElement(m).kPoints = SimViewer_g.SimGroup(k).MPBdata(m).kPoints;
    SimViewer_g.SimGroup(k).plotElement(m).bands = SimViewer_g.SimGroup(k).MPBdata(m).bands;
    SimViewer_g.SimGroup(k).plotElement(m).color = getDataSetColor(k);
    SimViewer_g.SimGroup(k).plotElement(m).visible = true;
    SimViewer_g.SimGroup(k).plotElement(m).lineStyle = '-';
    SimViewer_g.SimGroup(k).plotElement(m).markerType = 'd';
    
end

%Get axis labels for critical points
labels = cellstr(''); %Label names for critical points
labelPoints = 0; %Locations for labels of critical points (X-Axis)
labelIndex = 0; %Indicies of label locations
labelCount = 1;

%Tolerance for identifying points to handle round off errors
tol = .01;

%Loop over all K-Points
for n = 1:size(SimViewer_g.SimGroup(k).MPBdata(m).kPoints,1)
    
    %Get current K-Point
    curPt = SimViewer_g.SimGroup(k).MPBdata(m).kPoints(n,:);
    
    %Loop over all critical points
    for p = 1:length(SimViewer_g.SimGroup(k).MPBSimulation.kPoints)
        
        %Check if the current critical point equals the current k-point
        if(abs(curPt - SimViewer_g.SimGroup(k).MPBSimulation.kPoints(p).point) < tol)
            
            labels(labelCount) = cellstr(SimViewer_g.SimGroup(k).MPBSimulation.kPoints(p).name);
            %Check if greek letter (gamma)
            if(strcmp('Gamma', SimViewer_g.SimGroup(k).MPBSimulation.kPoints(p).name))
                labels(labelCount) = cellstr('\Gamma');
            end
            labelPoints(labelCount) = SimViewer_g.SimGroup(k).MPBdata(m).kDist(n);
            labelIndex(labelCount) = labelCount;
            labelCount = labelCount+1;
            break
        end
    end
end

%Sort tick points and indices
sortedTicks = sort([labelPoints', labelIndex']);
SimViewer_g.labelPoints = sortedTicks(:,1);
SimViewer_g.labelIndex = sortedTicks(:,2);
SimViewer_g.labels = labels;
SimViewer_g.band_xmin = min(SimViewer_g.SimGroup(k).MPBdata(m).kDist);
SimViewer_g.band_xmax = max(SimViewer_g.SimGroup(k).MPBdata(m).kDist);

%Update flag to indicate data has been loaded
SimViewer_g.SimGroup(k).MPBData_FLAG = true;

end

% %Compute light line
% KptsXYZ = kPoints(:,1)*SimViewer_g.SimGroup(k).lattice.b1 + kPoints(:,2)*SimViewer_g.SimGroup(k).lattice.b2 + kPoints(:,3)*SimViewer_g.SimGroup(k).lattice.b3;
% KptsXYZ = KptsXYZ/(2*pi);
% Kyz = zeros(size(kPoints,1),1);
% 
% %Loop over all kPoints
% for m = 1:size(KptsXYZ,1)
%     
%     %Extract Kyz
%     Kyz(m) = norm(KptsXYZ(m,2:3));
%        
% end

% H=area(kDist,Kyz, 'LineWidth', 1.6);
% h=get(H,'children');
% set(h,'FaceAlpha',0.5); %#Tada!



function formatBandPlot
%Function plots reflectance data in SimViewer_g.SimGroup(k)
global SimViewer_g

%Axis limits
xmin = SimViewer_g.band_xmin;
xmax = SimViewer_g.band_xmax;
ymin = SimViewer_g.band_normfreqmin;
ymax = SimViewer_g.band_normfreqmax;

axis( [xmin xmax ymin ymax ]);

%Format axis
%Font
set(gca, 'FontSize', 13, 'FontName', 'Helvetica', 'FontWeight', 'Normal');

%Axis properties
set(gca, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.02 .02],...
    'XMinorTick', 'off', 'YMinorTick', 'on');

%Set up axis labels
%X-Axis
set(gca, 'XTick', SimViewer_g.labelPoints);
%set(gca, 'XTickLabels', labels(labelIndex), 'interpreter', 'latex');
[hx,hy] = format_ticks(gca, SimViewer_g.labels(SimViewer_g.labelIndex),[], SimViewer_g.labelPoints, [], 0, 0, .025);

%Y-Axis
%Compute y axis ticks

%Set up X ticks
numTicks = 10;

%Get range for ticks
range = ymax - ymin;

mantissa = range/(10^floor(log10(range)));
interval = (floor(mantissa)/numTicks)*10^floor(log10(range));

yticks = ymin:interval:ymax;

set(gca, 'YTick', yticks);
ylabel( '\omegaa/2\pic', 'FontSize', 16, 'FontWeight', 'light');


end

function color = getDataSetColor(k)
%Function gets currently assigned dataset color or assigns a new one if no
%color is currently in use or not yet asssigned
global SimViewer_g


%Check if color has already been assigned to dataset
if(~isempty(SimViewer_g.SimGroup(k).colorNum))
    
    %Check if color is already in use, loop over all color choices
    if(~SimViewer_g.bandColors(SimViewer_g.SimGroup(k).colorNum).inUse)
        
        %Color is not currently in use, assign it to current  data set
        SimViewer_g.bandColors(SimViewer_g.SimGroup(k).colorNum).inUse = true;
        
        %Return  color RGB value
        color = SimViewer_g.bandColors(SimViewer_g.SimGroup(k).colorNum).RGB;
        return
        
    end
end

%Dataset has no color, or color already assigned is currently in use
%Attempt to assign other unused color:

%Loop over all color values
for m = 1:length(SimViewer_g.bandColors)
    
    %Check if value is in use
    if(~SimViewer_g.bandColors(m).inUse)
        %Value not in use, assign to dataset
        SimViewer_g.SimGroup(k).colorNum = m;
        
        %Color is now in use
        SimViewer_g.bandColors(m).inUse = true;
        
        %Get color RGB value
        color = SimViewer_g.bandColors(SimViewer_g.SimGroup(k).colorNum).RGB;
        return;
    end
end
%All colors already in use, assign one randomly

numColors = length(SimViewer_g.bandColors)-1;

color = SimViewer_g.bandColors(floor(numColors*rand + 1)).RGB;
end


function resetColorFlags
%This function resets the inUse flag for color spec objects
global SimViewer_g

for k = 1:length(SimViewer_g.bandColors)
    
    SimViewer_g.bandColors(k).inUse = false;
    
end
end


