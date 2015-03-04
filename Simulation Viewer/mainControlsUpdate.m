function mainControlsUpdate
%This function updates values in SimViewer_g anytime the controls on the
%main window are changed. 

global SimViewer_g

handles = guihandles(SimViewer_g.main_h.SimViewerMain);

flagFound = false;
%Identify index of simulation
for k = 1:length(SimViewer_g.SimGroup)
    if(strcmp(SimViewer_g.currentFolderPath, SimViewer_g.SimGroup(k).SVpath))
        flagFound = true;
        break;
    end
end

%If simulation wasn't found, return. Should not happen.
if(~flagFound)
    return
end

%Simulation name override
SimViewer_g.SimGroup(k).overrideName = get(handles.edit_overrideSimName, 'String');