function reflectanceControlsUpdate
%This function updates values in SimViewer_g anytime the controls on the
%reflectance window are changed. Also called during start-up to extract default
%values. 
global SimViewer_g

handles = guihandles(SimViewer_g.reflectance_h);

%Plot Controls 

%X-Axis
%Normalized Frequency
SimViewer_g.normfreq = get(handles.rdo_normfreq, 'Value');
SimViewer_g.normfreqmin = str2double(get(handles.edit_normfreqmin,'String'));
SimViewer_g.normfreqmax = str2double(get(handles.edit_normfreqmax,'String'));

%Wavelength
SimViewer_g.wavelength = get(handles.rdo_wavelength, 'Value');
SimViewer_g.wavelengthmin = str2double(get(handles.edit_wavelengthmin,'String'));
SimViewer_g.wavelengthmax = str2double(get(handles.edit_wavelengthmax,'String'));

%Y-Axis
SimViewer_g.rcoeffmin = str2double(get(handles.edit_rcoeffmin, 'String'));
SimViewer_g.rcoeffmax = str2double(get(handles.edit_rcoeffmax, 'String'));
SimViewer_g.yAxisLogarithmic = get(handles.rdo_yAxisLogarithmic, 'Value');

end