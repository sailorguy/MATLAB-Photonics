function runSimViewer

%Set path to simulation folders
simulationDirectory = 'W:\gpfstest\IHO_2D\Test2';

monitorConfiguration = 'one'; %One, two or three

%Run SimViewer
SimViewerMain(simulationDirectory, monitorConfiguration);


end