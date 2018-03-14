function varargout = frameViewer(varargin)
%FRAMEVIEWER M-file for frameViewer.fig
%      FRAMEVIEWER, by itself, creates a new FRAMEVIEWER or raises the existing
%      singleton*.
%
%      H = FRAMEVIEWER returns the handle to a new FRAMEVIEWER or the handle to
%      the existing singleton*.
%
%      FRAMEVIEWER('Property','Value',...) creates a new FRAMEVIEWER using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to frameViewer_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FRAMEVIEWER('CALLBACK') and FRAMEVIEWER('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FRAMEVIEWER.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help frameViewer

% Last Modified by GUIDE v2.5 18-Jul-2009 14:44:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frameViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @frameViewer_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before frameViewer is made visible.
function frameViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for frameViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes frameViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = frameViewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1LoadMovie.
function pushbutton1LoadMovie_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1LoadMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName pathName]=uigetfile('*.avi');
if fileName==0, return, end
handles.mmObj=mmreader([pathName fileName]);
handles.currentFrame=1;
guidata(hObject,handles)
updateMovieText;
updateFrameText;
updateFrame;


% --- Executes on button press in pushbutton2Plus1.
function pushbutton2Plus1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2Plus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'currentFrame'), return, end
handles.currentFrame=handles.currentFrame+1;
if handles.currentFrame>handles.mmObj.NumberOfFrames
    handles.currentFrame=handles.mmObj.NumberOfFrames;
end
guidata(hObject,handles)
updateFrameText
updateFrame

% --- Executes on button press in pushbutton3Plus10.
function pushbutton3Plus10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3Plus10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'currentFrame'), return, end
handles.currentFrame=handles.currentFrame+10;
if handles.currentFrame>handles.mmObj.NumberOfFrames
    handles.currentFrame=handles.mmObj.NumberOfFrames;
end
guidata(hObject,handles)
updateFrameText
updateFrame

% --- Executes on button press in pushbutton4Minus1.
function pushbutton4Minus1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4Minus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'currentFrame'), return, end
handles.currentFrame=handles.currentFrame-1;
if handles.currentFrame<1, handles.currentFrame=1; end
guidata(hObject,handles)
updateFrameText
updateFrame

% --- Executes on button press in pushbutton5Minus10.
function pushbutton5Minus10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5Minus10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'currentFrame'), return, end
handles.currentFrame=handles.currentFrame-10;
if handles.currentFrame<1, handles.currentFrame=1; end
guidata(hObject,handles)
updateFrameText
updateFrame


% --- Helper functions ---
function updateMovieText
handles=guidata(gcbo);
set(handles.text3MovieName,'string',handles.mmObj.Name)

function updateFrameText
handles=guidata(gcbo);
set(handles.text2FrameNumber,'string',...
    [num2str(handles.currentFrame) '/' num2str(handles.mmObj.NumberOfFrames)])

function updateFrame
handles=guidata(gcbo);
frame=read(handles.mmObj,handles.currentFrame);
image('CData',frame)