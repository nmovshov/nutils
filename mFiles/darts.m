function varargout = darts(varargin)
% DARTS M-file for darts.fig
%      DARTS, by itself, creates a new DARTS or raises the existing
%      singleton*.
%
%      H = DARTS returns the handle to a new DARTS or the handle to
%      the existing singleton*.
%
%      DARTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DARTS.M with the given input arguments.
%
%      DARTS('Property','Value',...) creates a new DARTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before darts_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to darts_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help darts

% Last Modified by GUIDE v2.5 03-Sep-2005 23:06:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @darts_OpeningFcn, ...
                   'gui_OutputFcn',  @darts_OutputFcn, ...
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


% --- Executes just before darts is made visible.
function darts_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to darts (see VARARGIN)

% Choose default command line output for darts
handles.output = hObject;

% set number of players (hard coded)
handles.numPlayers   = 3;
handles.scores       = 301*ones(1,handles.numPlayers);
handles.activePlayer = 0;
set(handles.text1,'backgroundcolor',[1 0.5 1])
set(handles.text2,'backgroundcolor',[0.9 0.9 0.8])
set(handles.text2,'backgroundcolor',[0.9 0.9 0.8])
handles.arrTxt=[handles.scoreTxtBox1;...
                handles.scoreTxtBox2;...
                handles.scoreTxtBox3];
                

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes darts wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = darts_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function scoreInputBox_Callback(hObject, eventdata, handles)
% hObject    handle to scoreInputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scoreInputBox as text
%        str2double(get(hObject,'String')) returns contents of scoreInputBox as a double


% --- Executes during object creation, after setting all properties.
function scoreInputBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scoreInputBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in recalcButton.
function recalcButton_Callback(hObject, eventdata, handles)
% hObject    handle to recalcButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%keyboard
S1=get(handles.scoreInputBox,'string');
S2=get(handles.scoreInputBox2,'string');
S3=get(handles.scoreInputBox3,'string');
err=checkScoreInput(S1,S2,S3);
switch err
    case 0
        
    case 1
        return
    case 2
        set(handles.prompt2,'string','Incorrect format.');
        set(handles.prompt2,'backgroundcolor','yellow');
        beep
        guidata(hObject, handles);
        return
end
%keyboard
N1=str2num(S1);
N2=str2num(S2);
N3=str2num(S3);
if any([N1 N2 N3]>60)
    set(handles.prompt2,'string','Liar!');
    set(handles.prompt2,'backgroundcolor','red');
    beep
    guidata(hObject, handles)
    return
end
if (handles.scores(handles.activePlayer+1)-(N1+N2+N3))==0
    set(handles.prompt2,'string',...
        ['Player ' num2str(handles.activePlayer+1) ' is the winner']);
    set(handles.prompt2,'backgroundcolor','blue');
    beep
    set(handles.prompt1,'string','');
    set(handles.recalcButton,'enable','inactive');
    guidata(hObject, handles)
    return
end
if (handles.scores(handles.activePlayer+1)-(N1+N2+N3))>0
handles.scores(handles.activePlayer+1)=...
    handles.scores(handles.activePlayer+1)-(N1+N2+N3);
end
refreshScores(hObject, handles);
handles.activePlayer=mod((handles.activePlayer+1),handles.numPlayers);
switch handles.activePlayer
    case 0
        set(handles.text1,'backgroundcolor',[1 0.5 1])
        set(handles.text2,'backgroundcolor',[0.9 0.9 0.8])
        set(handles.text3,'backgroundcolor',[0.9 0.9 0.8])
    case 1
        set(handles.text2,'backgroundcolor',[1 0.5 1])
        set(handles.text3,'backgroundcolor',[0.9 0.9 0.8])
        set(handles.text1,'backgroundcolor',[0.9 0.9 0.8])
    case 2
        set(handles.text3,'backgroundcolor',[1 0.5 1])
        set(handles.text1,'backgroundcolor',[0.9 0.9 0.8])
        set(handles.text2,'backgroundcolor',[0.9 0.9 0.8])
end
set(handles.prompt1,'string',['Player ',num2str(handles.activePlayer+1),...
    ' Input Score']);
guidata(hObject, handles);



% --- Helper function refreshScores ---
function refreshScores(hObject, handles)
for k=1:handles.numPlayers
set(handles.arrTxt(k),'string',num2str(handles.scores(k)));
end
set(handles.scoreInputBox,'string','');
set(handles.scoreInputBox2,'string','');
set(handles.scoreInputBox3,'string','');
set(handles.prompt2,'string','');
set(handles.prompt2,'backgroundcolor',get(handles.figure1,'color'));
guidata(hObject, handles);



function scoreInputBox2_Callback(hObject, eventdata, handles)
% hObject    handle to scoreInputBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scoreInputBox2 as text
%        str2double(get(hObject,'String')) returns contents of scoreInputBox2 as a double


% --- Executes during object creation, after setting all properties.
function scoreInputBox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scoreInputBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scoreInputBox3_Callback(hObject, eventdata, handles)
% hObject    handle to scoreInputBox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scoreInputBox3 as text
%        str2double(get(hObject,'String')) returns contents of scoreInputBox3 as a double


% --- Executes during object creation, after setting all properties.
function scoreInputBox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scoreInputBox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- helper function checkScoreInput ---
function err=checkScoreInput(S1,S2,S3)
S={S1;S2;S3};
if isempty(S1)||isempty(S2)||isempty(S3)
    err=1;
    return
end
if isempty(str2num(S1))||isempty(str2num(S2))||isempty(str2num(S3))
    err=2;
    return
end
if (str2num(S1)-round(str2num(S1)) || str2num(S2)-round(str2num(S2)) ||...
        str2num(S3)-round(str2num(S3)))
    err=2;
    return
end
err=0;


