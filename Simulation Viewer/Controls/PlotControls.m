function varargout = PlotControls(varargin)
% REFLECTIONPLOTCONTROLS MATLAB code for PlotControls.fig
%      REFLECTIONPLOTCONTROLS, by itself, creates a new REFLECTIONPLOTCONTROLS or raises the existing
%      singleton*.
%
%      H = REFLECTIONPLOTCONTROLS returns the handle to a new REFLECTIONPLOTCONTROLS or the handle to
%      the existing singleton*.
%
%      REFLECTIONPLOTCONTROLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REFLECTIONPLOTCONTROLS.M with the given input arguments.
%
%      REFLECTIONPLOTCONTROLS('Property','Value',...) creates a new REFLECTIONPLOTCONTROLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlotControls_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlotControls_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlotControls

% Last Modified by GUIDE v2.5 18-Dec-2013 16:28:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlotControls_OpeningFcn, ...
                   'gui_OutputFcn',  @PlotControls_OutputFcn, ...
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


% --- Executes just before PlotControls is made visible.
function PlotControls_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlotControls (see VARARGIN)

% Choose default command line output for PlotControls
handles.output = hObject;

%Record what plot these controls are for
handles.type = varargin{1};

%Modify the figure title depending on type of plot
handles.figure1.Name = [varargin{1} ' Plot Controls'];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlotControls wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlotControls_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clean up  plot controls
plotControlsCleanup(handles.type);



function edit_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_name as text
%        str2double(get(hObject,'String')) returns contents of edit_name as a double


% --- Executes during object creation, after setting all properties.
function edit_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_elementType.
function popup_elementType_Callback(hObject, eventdata, handles)
% hObject    handle to popup_elementType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_elementType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_elementType


% --- Executes during object creation, after setting all properties.
function popup_elementType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_elementType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btn_color.
function btn_color_Callback(hObject, eventdata, handles)
% hObject    handle to btn_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SimViewer_g

%Get current color
color = get(hObject, 'BackgroundColor');

%Display color selector
color = uisetcolor(color);

indices = [];
switch handles.type
    
    case 'Reflectance'
        
        %Get indices for currently selected element
        indices = SimViewer_g.reflPlotControls.indices;
        
    case 'Bands'
        
        %Get indices for currently selected element
        indices = SimViewer_g.bandPlotControls.indices;
        
end

%Get currently selected element
[element, found] = getPlotElement(indices);

%Check to make sure an element was selected
if(~found)
    return;
end

%Set color
element.color = color;

%Update plot element display
displayPlotElementData(handles.type);



function edit_markerSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_markerSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_markerSize as text
%        str2double(get(hObject,'String')) returns contents of edit_markerSize as a double


% --- Executes during object creation, after setting all properties.
function edit_markerSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_markerSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_markerType.
function popup_markerType_Callback(hObject, eventdata, handles)
% hObject    handle to popup_markerType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_markerType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_markerType


% --- Executes during object creation, after setting all properties.
function popup_markerType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_markerType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_lineWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lineWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_lineStyle.
function popup_lineStyle_Callback(hObject, eventdata, handles)
% hObject    handle to popup_lineStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_lineStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_lineStyle


% --- Executes during object creation, after setting all properties.
function popup_lineStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_lineStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_applyChanges.
function btn_applyChanges_Callback(hObject, eventdata, handles)
% hObject    handle to btn_applyChanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Update plot element, passing type of controls
readPlotElementData(handles.type)

switch handles.type
    
    case 'Reflectance'
        
        %Update reflection plot
        ReflectancePlotUpdate('normal');
        
    case 'Bands'
        
        %Update reflection plot
        BandPlotUpdate('normal');
       
end


function edit_smoothingCoeff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_smoothingCoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_smoothingCoeff as text
%        str2double(get(hObject,'String')) returns contents of edit_smoothingCoeff as a double


% --- Executes during object creation, after setting all properties.
function edit_smoothingCoeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_smoothingCoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_smoothingMethod.
function popup_smoothingMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popup_smoothingMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_smoothingMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_smoothingMethod


% --- Executes during object creation, after setting all properties.
function popup_smoothingMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_smoothingMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_fitType.
function popup_fitType_Callback(hObject, eventdata, handles)
% hObject    handle to popup_fitType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_fitType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_fitType

global SimViewer_g

%Get handle to GUI elements
handles = guihandles(SimViewer_g.reflectanceControls_h);

%Get indices for currently selected element
indices = SimViewer_g.reflPlotControls.indices;

%Get currently selected element
[element, found] = getPlotElement(indices);

%Check to make sure an element was selected
if(~found)
    return;
end

%Set element.fitType
element.fitType = readPopup(handles.popup_fitType);

%Update plot element display
displayPlotElementData;




% --- Executes during object creation, after setting all properties.
function popup_fitType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_fitType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xMin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xMin as text
%        str2double(get(hObject,'String')) returns contents of edit_xMin as a double


% --- Executes during object creation, after setting all properties.
function edit_xMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xMax as text
%        str2double(get(hObject,'String')) returns contents of edit_xMax as a double


% --- Executes during object creation, after setting all properties.
function edit_xMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_applyChanges.
function btn_applyChanges_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btn_applyChanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Update plot element
readPlotElementData

%Update reflection plot
ReflectancePlotUpdate('normal');

%Update display
displayPlotElementData


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over tog_visible.
function tog_visible_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to tog_visible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SimViewer_g

indices = [];

%Get the right indices
switch handles.type
    
    case 'Reflectance'
        
        %Get indices for currently selected element
        indices = SimViewer_g.reflPlotControls.indices;
        
    case 'Bands'
        
        %Get indices for currently selected element
        indices = SimViewer_g.bandPlotControls.indices;
end

%Get currently selected element
[element, found] = getPlotElement(indices);

%Check to make sure an element was selected
if(~found)
    return;
end

%Change value
if(element.visible)
    element.visible = false;
else
    element.visible = true;
end

%Update display
displayPlotElementData(handles.type);



function edit_E1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_E1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_E1 as text
%        str2double(get(hObject,'String')) returns contents of edit_E1 as a double


% --- Executes during object creation, after setting all properties.
function edit_E1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_E1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_plotType.
function popup_plotType_Callback(hObject, eventdata, handles)
% hObject    handle to popup_plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_plotType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_plotType

global SimViewer_g

%Get indices for currently selected element
indices = SimViewer_g.reflPlotControls.indices;

%Get currently selected element
[element, found] = getPlotElement(indices);

%Check to make sure an element was selected
if(~found)
    return;
end

%Get plot type
element.plotType = readPopup(handles.popup_plotType);

%Update display
displayPlotElementData;



% --- Executes during object creation, after setting all properties.
function popup_plotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_exportData.
function btn_exportData_Callback(hObject, eventdata, handles)
% hObject    handle to btn_exportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Export data for currently selected plot element
exportData;


% --- Executes on button press in btn_exportFolder.
function btn_exportFolder_Callback(hObject, eventdata, handles)
% hObject    handle to btn_exportFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SimViewer_g

%Get folder
SimViewer_g.reflPlotControls.exportFolder  = uigetdir('W:/scratch');

%Update display
displayPlotElementData;



function edit_modelDataXmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_modelDataXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_modelDataXmin as text
%        str2double(get(hObject,'String')) returns contents of edit_modelDataXmin as a double


% --- Executes during object creation, after setting all properties.
function edit_modelDataXmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_modelDataXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_modelDataXmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_modelDataXmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_modelDataXmax as text
%        str2double(get(hObject,'String')) returns contents of edit_modelDataXmax as a double


% --- Executes during object creation, after setting all properties.
function edit_modelDataXmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_modelDataXmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_modelDisplayXmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_modelDisplayXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_modelDisplayXmin as text
%        str2double(get(hObject,'String')) returns contents of edit_modelDisplayXmin as a double


% --- Executes during object creation, after setting all properties.
function edit_modelDisplayXmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_modelDisplayXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_modelDisplayXmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_modelDisplayXmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_modelDisplayXmax as text
%        str2double(get(hObject,'String')) returns contents of edit_modelDisplayXmax as a double


% --- Executes during object creation, after setting all properties.
function edit_modelDisplayXmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_modelDisplayXmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_modelType.
function popup_modelType_Callback(hObject, eventdata, handles)
% hObject    handle to popup_modelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_modelType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_modelType


% --- Executes during object creation, after setting all properties.
function popup_modelType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_modelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_legendNumber_Callback(hObject, eventdata, handles)
% hObject    handle to edit_legendNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_legendNumber as text
%        str2double(get(hObject,'String')) returns contents of edit_legendNumber as a double


% --- Executes during object creation, after setting all properties.
function edit_legendNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_legendNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_decimationFactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_decimationFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_decimationFactor as text
%        str2double(get(hObject,'String')) returns contents of edit_decimationFactor as a double


% --- Executes during object creation, after setting all properties.
function edit_decimationFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_decimationFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
