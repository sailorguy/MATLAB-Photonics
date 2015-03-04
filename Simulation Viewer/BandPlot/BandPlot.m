function varargout = BandPlot(varargin)
% BANDPLOT MATLAB code for BandPlot.fig
%      BANDPLOT, by itself, creates a new BANDPLOT or raises the existing
%      singleton*.
%
%      H = BANDPLOT returns the handle to a new BANDPLOT or the handle to
%      the existing singleton*.
%
%      BANDPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BANDPLOT.M with the given input arguments.
%
%      BANDPLOT('Property','Value',...) creates a new BANDPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BandPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BandPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BandPlot

% Last Modified by GUIDE v2.5 17-Feb-2015 18:42:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BandPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @BandPlot_OutputFcn, ...
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


% --- Executes just before BandPlot is made visible.
function BandPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BandPlot (see VARARGIN)

% Choose default command line output for BandPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BandPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BandPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_bandnormfreqmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bandnormfreqmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bandnormfreqmin as text
%        str2double(get(hObject,'String')) returns contents of edit_bandnormfreqmin as a double
BandPlotUpdate('normal')

% --- Executes during object creation, after setting all properties.
function edit_bandnormfreqmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bandnormfreqmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_bandnormfreqmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bandnormfreqmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bandnormfreqmax as text
%        str2double(get(hObject,'String')) returns contents of edit_bandnormfreqmax as a double
BandPlotUpdate('normal')

% --- Executes during object creation, after setting all propertiesx.
function edit_bandnormfreqmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bandnormfreqmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_bandplot_printpdf.
function btn_bandplot_printpdf_Callback(hObject, eventdata, handles)
% hObject    handle to btn_bandplot_printpdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BandPlotUpdate('printPDF')


% --- Executes on button press in btn_bandplot_exportfigure.
function btn_bandplot_exportfigure_Callback(hObject, eventdata, handles)
% hObject    handle to btn_bandplot_exportfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BandPlotUpdate('exportFigure')


% --- Executes on button press in btn_bandplot_printEPS.
function btn_bandplot_printEPS_Callback(hObject, eventdata, handles)
% hObject    handle to btn_bandplot_printEPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BandPlotUpdate('printEPS')


% --- Executes on button press in btn_projectBandStructure.
function btn_projectBandStructure_Callback(hObject, eventdata, handles)
% hObject    handle to btn_projectBandStructure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
projectBandStructure;


% --- Executes on button press in btn_plotControls.
function btn_plotControls_Callback(hObject, eventdata, handles)
% hObject    handle to btn_plotControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SimViewer_g

%Open plot controls window, indicating this is for band plot
SimViewer_g.bandControls_h = PlotControls('Bands');

%Create the plot element tree
createPlotElementTree('Bands');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btn_plotControls.
function btn_plotControls_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btn_plotControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
