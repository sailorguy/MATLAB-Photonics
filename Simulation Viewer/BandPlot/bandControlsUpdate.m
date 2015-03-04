function bandControlsUpdate
%This function updates values in SimViewer_g anytime the controls on the
%band window are changed. Also called during start-up to extract default
%values. 
global SimViewer_g

handles = guihandles(SimViewer_g.band_h);

%Plot Controls 

%Y-Axis
SimViewer_g.band_normfreqmin = str2double(get(handles.edit_bandnormfreqmin, 'String'));
SimViewer_g.band_normfreqmax = str2double(get(handles.edit_bandnormfreqmax, 'String'));

end
