function varargout = SimViewerMain(varargin)
% SIMVIEWERMAIN MATLAB code for SimViewerMain.fig
%      SIMVIEWERMAIN, by itself, creates a new SIMVIEWERMAIN or raises the existing
%      singleton*.
%
%      H = SIMVIEWERMAIN returns the handle to a new SIMVIEWERMAIN or the handle to
%      the existing singleton*.
%
%      SIMVIEWERMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMVIEWERMAIN.M with the given input arguments.
%
%      SIMVIEWERMAIN('Property','Value',...) creates a new SIMVIEWERMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are applied to the GUI before SimViewerMain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SimViewerMain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SimViewerMain

% Last Modified by GUIDE v2.5 02-Oct-2012 18:28:10.90909

%Add custom tree node class for checkbox tree
javaaddpath([pwd '/Classes/Java Classes'], '-end');

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SimViewerMain_OpeningFcn, ...
    'gui_OutputFcn',  @SimViewerMain_OutputFcn, ...
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


% --- Executes just before SimViewerMain is made visible.
function SimViewerMain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimViewerMain (see VARARGIN)

% Choose default command line output for SimViewerMain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SimViewerMain wait for user response (see UIRESUME)
% uiwait(handles.SimViewerMain);

%Make sure SimViewer is clear
clear SimViewer_g

%Create global data structure
global SimViewer_g
SimViewer_g = SimViewerDataObj;
SimViewer_g.main_h  = handles;
SimViewer_g.reflectance_h = ReflectionPlot;
SimViewer_g.band_h = BandPlot;
SimViewer_g.rootDirectory = varargin{1};

%Position reflectance window
monitorConfiguration = varargin{2};

switch monitorConfiguration
    
    case 'one'
        MainPosition = [.01 , .01, .49, .9]; %position main window figure on left monitor
        ReflectancePosition = [.01 , .01, .98, .9]; %position reflectance figure on left monitor
        BandPosition = [.01 , .01, .98, .9]; %position band figure on left monitor
        
    case 'two'
        MainPosition = [.01 , .01, .49, .9]; %position main window figure on left monitor
        ReflectancePosition = [1.01 , .01, .98, .9]; %position reflectance figure on right monitor
        BandPosition = [1.01 , .01, .98, .9]; %position band figure on right monitor
        
    case 'three'
        MainPosition = [.01 , .01, .49, .9]; %position main window figure on left monitor
        ReflectancePosition = [1.01 , .01, .98, .9]; %position reflectance figure on center monitor for rdp
        BandPosition = [2.01 , .01, .98, .9]; %position band figure on right monitor
        
    case 'rdp'
        MainPosition = [.01 , .01, .49, .9]; %position main window figure on left monitor for rdp
        ReflectancePosition = [.49 , .01, .49, .9]; %position reflectance figure on right monitor for rdp
        BandPosition = [.01 , .01, .49, .9]; %position band figure on left monitor for rdp

        
end

% set(SimViewer_g.main_h,'Units', 'normalized');
% set(SimViewer_g.main_h,'Position', MainPosition);
% set(SimViewer_g.main_h,'Visible', 'on');

set(SimViewer_g.reflectance_h,'Units', 'normalized');
set(SimViewer_g.reflectance_h,'Position', ReflectancePosition);
set(SimViewer_g.reflectance_h,'Visible', 'on');

set(SimViewer_g.band_h,'Units', 'normalized');
set(SimViewer_g.band_h,'Position', BandPosition);
set(SimViewer_g.band_h,'Visible', 'on');

%Pause to allow updates to reflectance and band windows to take effect
pause(.1);

%Load CheckBoxTree folder viewer
createCheckBoxTree;


% --- Outputs from this function are returned to the command line.
function varargout = SimViewerMain_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BtnOpenSimulation.
function BtnOpenSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to BtnOpenSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over BtnOpenSimulation.

%Get directory and name for simulation
folder_path = uigetdir('W:/', 'Select Simulation Directory');
simulation_name = getFolderFromPath(folder_path);

%Load data structures for simulation run
load([folder_path '/save/' simulation_name], 'pbs', 'simulation', 'geometry', 'sources');

function token = getFolderFromPath(folder_path)

remain = folder_path;

%Loop until remaining string is empty
while(~isempty(remain))
    [token, remain] = strtok(remain);
end


% --- Executes on button press in btn_simGeometryFigExport.
function btn_simGeometryFigExport_Callback(hObject, eventdata, handles)
% hObject    handle to btn_simGeometryFigExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SimViewer_g
SimDataDisplay(SimViewer_g.currentFolderPath,true);



function edit_overrideSimName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_overrideSimName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_overrideSimName as text
%        str2double(get(hObject,'String')) returns contents of edit_overrideSimName as a double

%Do nothing, only override upon button press


% --- Executes during object creation, after setting all properties.
function edit_overrideSimName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_overrideSimName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_saveSimName.
function btn_saveSimName_Callback(hObject, eventdata, handles)
% hObject    handle to btn_saveSimName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Update simulation controls
mainControlsUpdate;

%Update reflectance plot
ReflectancePlotUpdate('normal');
BandPlotUpdate('normal');
