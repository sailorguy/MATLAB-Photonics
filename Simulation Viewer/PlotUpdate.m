function PlotUpdate
%This function updates the plot(s) by checking for which SimGroups are
%selected, importing any data as needed and replotting the results

global SimViewer_g

%Check if reflectance_h is valid
if(isempty(SimViewer_g.reflectance_h))
    SimViewer_g.reflectance_h = figure; %Set handle
    
    %Position figure
    set(SimViewer_g.reflectance_h,'Units', 'normalized');
    position = [1.01 , .01, .98, .9]; %position figure on middle monitor
    set(SimViewer_g.reflectance_h,'Position', position);
    
else
    %Clear plot
    cla(SimViewer_g.reflectance_h);
end

%Loop over all imported SimGroups
for k = 1:length(SimViewer_g.SimGroup)
    
    %Check to see if the group is checked
    if(SimViewer_g.SimGroup(k).checked)
        
        %Check if dataset is loaded
        if(~SimViewer_g.SimGroup(k).reflData_FLAG)
            %Load data set
            loadReflectanceData(k)
        end
        
        plotReflectanceData(k)
        
    end
    
end


end

function loadReflectanceData(k)
%Function loads reflectance data into SimViewer_g.SimGroup(k)
global SimViewer_g

%Get file names
folder = SimViewer_g.SimGroup(k).SVpath;
normFile = [folder '/output/norm.txt'];
reflFile = [folder '/output/refl.txt'];

%Read flux data
[normFlux,normfluxFound] = FluxRead(normFile);
[reflFlux,reflfluxFound] = FluxRead(reflFile);

%Check if both data sets were found
if(normFluxFound && reflFluxFound)
    SimViewer_g.SimGroup(k).normFlux = normFlux;
    SimViewer_g.SimGroup(k).reflFlux = reflFlux;
else
    %Data not found
    return;
end

%Update flag to indicate data has been loaded
SimViewer_g.SimGroup(k).reflData_FLAG = true;

end

function plotReflectanceData(k)
%Function plots reflectance data in SimViewer_g.SimGroup(k)
global SimViewer_g

%Check if data is actually loaded
if(~SimViewer_g.SimGroup(k).reflData_FLAG)
    return;
end

%Compute reflectance
[normalizedFreq,refl] = computeReflectance(SimViewer_g.SimGroup(k).normFlux, SimViewer_g.SimGroup(k).reflFlux);

if(SimViewer_g.SimGroup(k).averagedData)
    [normalizedFreq, refl] = averageReflectanceData(normalizedFreq,refl);
end

%Set reflectance to be current figure
set(0, 'CurrentFigure', SimViewer_g.reflectance_h);

hold on
scatter(normalizedFreq, refl)

axis( [0 1.5 0 1 ]);
xlabel( 'Wavelenth (um)');
ylabel( 'Reflectance');

end