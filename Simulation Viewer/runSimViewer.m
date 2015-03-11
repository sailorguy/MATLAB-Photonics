function runSimViewer

%Set path to simulation folders
simulationDirectory = 'W:\gpfstest\IDO\Clean\X\Reflectance-band-src\R-0.250_epsS-13.0_epsL-1.0\Occupancy-T1000';

monitorConfiguration = 'one'; %One, two or three

%Run SimViewer
SimViewerMain(simulationDirectory, monitorConfiguration);


end