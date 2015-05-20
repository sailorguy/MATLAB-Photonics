function exportData

global SimViewer_g

global data
global headers
global writtenXdata index
writtenXdata = false;
index = 1;

%Get export folder
exportFolder = SimViewer_g.reflPlotControls.exportFolder;

%Get indices for currently selected element
indices = SimViewer_g.reflPlotControls.indices;

%Preallocate data arrays
headers = {};
data = [];
fileName = '';

for k = 1:length(SimViewer_g.SimGroup)
    
    %Only look at selected SimGroups that are of type MEEP
    if(SimViewer_g.SimGroup(k).checked && strcmp(SimViewer_g.SimGroup(k).type, 'MEEP'))
        
        
        %Loop over top level plot elments
        for m = 1:length(SimViewer_g.SimGroup(k).plotElement)
            
            %Export top level data if visible
            if(SimViewer_g.SimGroup(k).plotElement(m).visible)
                exportPlotElementData(SimViewer_g.SimGroup(k).plotElement(m));
            end
            
            %Loop over second level elements
            for n = 1:length(SimViewer_g.SimGroup(k).plotElement(m).children)
                
                %Export second level data if visible
                if(SimViewer_g.SimGroup(k).plotElement(m).children(n).visible)
                    
                    exportPlotElementData(SimViewer_g.SimGroup(k).plotElement(m).children(n))
                end            
            end   
        end
    end
    
    
end

fileName = 'data';

%Sort x values
[~, index] = sort(data(:,1));

%Sort data array according to x values
data = data(index, :);

%File path
file = [exportFolder '/' fileName '.csv'];
file = 'data.csv';

%Write data file
writeCSV(file, headers, data);

end

function exportPlotElementData(plotElement)
global SimViewer_g
global data
global headers

global writtenXdata index

%Get X data if first plot element
if(~writtenXdata)
    %Get X data
    xData = plotElement.xData;
    
    %Check if exporting by frequency or wavelength
    if(SimViewer_g.wavelength)
        xData = 1./xData;
        xLabel = 'Wavelength (um)';
        
    else
        xLabel = 'Normalized Frequency';
    end
    
    %Write X data
    data(:,index) = xData;
    
    %Write X header
    headers{1,index} = xLabel;
    
    %Increment dataset counter
    index = index + 1;
    
    %Indicate that we have written xData
    writtenXdata = true;
end


%Get header information
headers{1,index} = plotElement.name;

%Write Y Data
data(:,index) = plotElement.yData;

%Increment dataset counter
index = index + 1;


end