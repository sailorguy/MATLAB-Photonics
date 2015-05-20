function runSimViewer

%Set path to simulation folders
simulationDirectory = 'W:\gpfs-scratch\IHO_2D\04-17-15';

monitorConfiguration = 'one'; %One, two or three

%Run SimViewer
SimViewerMain(simulationDirectory, monitorConfiguration);


end