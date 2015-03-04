function varargout = ReflectionPlot(varargin)
% REFLECTIONPLOT MATLAB code for ReflectionPlot.fig
%      REFLECTIONPLOT, by itself, creates a new REFLECTIONPLOT or raises the existing
%      singleton*.
%
%      H = REFLECTIONPLOT returns the handle to a new REFLECTIONPLOT or the handle to
%      the existing singleton*.
%
%      REFLECTIONPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REFLECTIONPLOT.M with the given input arguments.
%
%      REFLECTIONPLOT('Property','Value',...) creates a new REFLECTIONPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ReflectionPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ReflectionPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ReflectionPlot

% Last Modified by GUIDE v2.5 05-Sep-2013 17:08:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ReflectionPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @ReflectionPlot_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ReflectionPlot is made visible.
function ReflectionPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ReflectionPlot (see VARARGIN)


% Choose default command line output for ReflectionPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ReflectionPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = ReflectionPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_normfreqmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_normfreqmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_normfreqmin as text
%        str2double(get(hObject,'String')) returns contents of edit_normfreqmin as a double

%Update plot 
ReflectancePlotUpdate('normal');


% --- Executes during object creation, after setting all properties.
function edit_normfreqmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_normfreqmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_normfreqmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_normfreqmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_normfreqmax as text
%        str2double(get(hObject,'String')) returns contents of edit_normfreqmax as a double

%Update plot 
ReflectancePlotUpdate('normal');

% --- Executes during object creation, after setting all properties.
function edit_normfreqmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_normfreqmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wavelengthmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wavelengthmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wavelengthmin as text
%        str2double(get(hObject,'String')) returns contents of edit_wavelengthmin as a double

%Update plot 
ReflectancePlotUpdate('normal');


% --- Executes during object creation, after setting all properties.
function edit_wavelengthmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wavelengthmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_wavelengthmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wavelengthmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wavelengthmax as text
%        str2double(get(hObject,'String')) returns contents of edit_wavelengthmax as a double

%Update plot 
ReflectancePlotUpdate('normal');

% --- Executes during object creation, after setting all properties.
function edit_wavelengthmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wavelengthmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

%Update plot 
ReflectancePlotUpdate('normal');


% --- Executes when selected object is changed in pnl_XaxisUnits.
function pnl_XaxisUnits_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pnl_XaxisUnits 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

%Update plot 
ReflectancePlotUpdate('normal');



function edit_rcoeffmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rcoeffmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rcoeffmin as text
%        str2double(get(hObject,'String')) returns contents of edit_rcoeffmin as a double

%Update plot 
ReflectancePlotUpdate('normal');

% --- Executes during object creation, after setting all properties.
function edit_rcoeffmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rcoeffmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rcoeffmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rcoeffmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rcoeffmax as text
%        str2double(get(hObject,'String')) returns contents of edit_rcoeffmax as a double

%Update plot 
ReflectancePlotUpdate('normal');

% --- Executes during object creation, after setting all properties.
function edit_rcoeffmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rcoeffmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_figExport.
function btn_figExport_Callback(hObject, eventdata, handles)
% hObject    handle to btn_figExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Export plot to window
ReflectancePlotUpdate('exportFigure');

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in btn_reflectance_printPDF.
function btn_reflectance_printPDF_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reflectance_printPDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Update plot, print to pdf
ReflectancePlotUpdate('printPDF');


% --- Executes on button press in btn_reflectance_printEPS.
function btn_reflectance_printEPS_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reflectance_printEPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Update plot, print to eps
ReflectancePlotUpdate('printEPS');


% --- Executes on button press in btn_plotControls.
function btn_plotControls_Callback(hObject, eventdata, handles)
% hObject    handle to btn_plotControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SimViewer_g

%Open plot controls window, indicating this is for reflectance plot
SimViewer_g.reflectanceControls_h = PlotControls('Reflectance');

%Create the plot element tree
createPlotElementTree('Reflectance');


% --- Executes when selected object is changed in pnl_yAxis.
function pnl_yAxis_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pnl_yAxis 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object


% handles    structure with handles and user data (see GUIDATA)

%Update plot 
ReflectancePlotUpdate('normal');
