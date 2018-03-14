function varargout = nTune(varargin)
%NTUNE A GUI guitar tuner.
% NTUNE Is a graphical user interface guitar tuning aid.
%
% Syntax: nTune
%
% Arguments: none.
%
% Usage: nTune creates a figure window with five pushbutons, one for each
% guitar string, and a time slider. Pressing each button causes the
% respective note to be played on the speakers, for the duration indicated
% by the time slider. As a safety measure all buttons are disabled for the
% duration of playback, as sending a second sound command to the speakers
% while still playing WILL crash MATLAB. NTUNE uses the NSOUND function to
% produce the sound on speakers.
%
% Called m-functions: nsound.m. (included as helper function)
%
% Author: Naor
%
% See also: sound, nsound.m, nplay.

% Last Modified by GUIDE v2.5 06-Jul-2005 22:08:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nTune_OpeningFcn, ...
                   'gui_OutputFcn',  @nTune_OutputFcn, ...
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


% --- Executes just before nTune is made visible.
function nTune_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nTune (see VARARGIN)

% Choose default command line output for nTune
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nTune wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nTune_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in EString.
function EString_Callback(hObject, eventdata, handles)
% hObject    handle to EString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.EString,'Enable','off')
set(handles.AString,'Enable','off')
set(handles.DString,'Enable','off')
set(handles.GString,'Enable','off')
set(handles.HString,'Enable','off')
set(handles.eString,'Enable','off')
nsound('E3',get(handles.length_slider,'value')*5);
pause(get(handles.length_slider,'value')*5);
set(handles.EString,'Enable','on')
set(handles.AString,'Enable','on')
set(handles.DString,'Enable','on')
set(handles.GString,'Enable','on')
set(handles.HString,'Enable','on')
set(handles.eString,'Enable','on')


% --- Executes on button press in AString.
function AString_Callback(hObject, eventdata, handles)
% hObject    handle to AString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.EString,'Enable','off')
set(handles.AString,'Enable','off')
set(handles.DString,'Enable','off')
set(handles.GString,'Enable','off')
set(handles.HString,'Enable','off')
set(handles.eString,'Enable','off')
nsound('A3',get(handles.length_slider,'value')*5);
pause(get(handles.length_slider,'value')*5);
set(handles.EString,'Enable','on')
set(handles.AString,'Enable','on')
set(handles.DString,'Enable','on')
set(handles.GString,'Enable','on')
set(handles.HString,'Enable','on')
set(handles.eString,'Enable','on')

% --- Executes on button press in DString.
function DString_Callback(hObject, eventdata, handles)
% hObject    handle to DString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.EString,'Enable','off')
set(handles.AString,'Enable','off')
set(handles.DString,'Enable','off')
set(handles.GString,'Enable','off')
set(handles.HString,'Enable','off')
set(handles.eString,'Enable','off')
nsound('D4',get(handles.length_slider,'value')*5);
pause(get(handles.length_slider,'value')*5);
set(handles.EString,'Enable','on')
set(handles.AString,'Enable','on')
set(handles.DString,'Enable','on')
set(handles.GString,'Enable','on')
set(handles.HString,'Enable','on')
set(handles.eString,'Enable','on')


% --- Executes on button press in GString.
function GString_Callback(hObject, eventdata, handles)
% hObject    handle to GString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.EString,'Enable','off')
set(handles.AString,'Enable','off')
set(handles.DString,'Enable','off')
set(handles.GString,'Enable','off')
set(handles.HString,'Enable','off')
set(handles.eString,'Enable','off')
nsound('G4',get(handles.length_slider,'value')*5);
pause(get(handles.length_slider,'value')*5);
set(handles.EString,'Enable','on')
set(handles.AString,'Enable','on')
set(handles.DString,'Enable','on')
set(handles.GString,'Enable','on')
set(handles.HString,'Enable','on')
set(handles.eString,'Enable','on')


% --- Executes on button press in HString.
function HString_Callback(hObject, eventdata, handles)
% hObject    handle to HString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.EString,'Enable','off')
set(handles.AString,'Enable','off')
set(handles.DString,'Enable','off')
set(handles.GString,'Enable','off')
set(handles.HString,'Enable','off')
set(handles.eString,'Enable','off')
nsound('B4',get(handles.length_slider,'value')*5);
pause(get(handles.length_slider,'value')*5);
set(handles.EString,'Enable','on')
set(handles.AString,'Enable','on')
set(handles.DString,'Enable','on')
set(handles.GString,'Enable','on')
set(handles.HString,'Enable','on')
set(handles.eString,'Enable','on')


% --- Executes on button press in eString.
function eString_Callback(hObject, eventdata, handles)
% hObject    handle to eString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.EString,'Enable','off')
set(handles.AString,'Enable','off')
set(handles.DString,'Enable','off')
set(handles.GString,'Enable','off')
set(handles.HString,'Enable','off')
set(handles.eString,'Enable','off')
nsound('E5',get(handles.length_slider,'value')*5);
pause(get(handles.length_slider,'value')*5);
set(handles.EString,'Enable','on')
set(handles.AString,'Enable','on')
set(handles.DString,'Enable','on')
set(handles.GString,'Enable','on')
set(handles.HString,'Enable','on')
set(handles.eString,'Enable','on')


% --- Executes on slider movement.
function length_slider_Callback(hObject, eventdata, handles)
% hObject    handle to length_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function length_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- HELPERS ---
function y=nsound(note,duration,muteFlag)
%NSOUND Play a single note on the C Major scale.
% NSOUND plays a single note for a specified duration. NSOUND recognizes
% traditional english notaion, e.g., C, G#, E, etc.
%
% Syntax:  y = nsound(note,duration,[muteFlag])
%
% Arguments:
% note - one of the strings
% {'C3','C#3','D3','D#3','E3','F3','F#3','G3','G#3','A3','A#3','B3',
% {'C4','C#4','D4','D#4','E4','F4','F#4','G4','G#4','A4','A#4','B4',
% {'C5','C#5','D5','D#5','E5','F5','F#5','G5','G#5','A5','A#5','B5'},
% or the character 'p'.
% duration - a numeric scalar.
% muteFlag (optional) - a logical scalar.
%
% Usage and output:
% The default behavior of NSOUND is to create a vector y holding a sine
% wave with a frequency corresponding to note and length corresponding to
% duration, and then send it to MATLAB's SOUND function to produce the note
% on speakers. If 'p' is entered instead of a note symbol a vector of zeros
% is produced and silence is `played' for duration seconds. An optional
% input argument muteFlag can be used to supress the final stage, and just
% return the vector y to the caller.
%
% Examples:
%   nsound('C4',1)
%   plays middle C for one second.
%   nsound('E3',1)
%   plays E below middle C (the bass E string on a guitar).
%   y=nsound('C4',1,true)
%   creates a vector y without playing anything.
%   sound(y)
%   will then sound middle C for one second.
%
% Called m-files: sound.m (MATLAB intrinsic).
%
% Author: Naor
%
% See also sound, nPlay, nTune.

% --- Verify input ---
switch nargin
    case 0
        note='C4';
        duration=1;
        muteFlag=false;
    case 1
        duration=1;
        muteFlag=false;
    case 2
        muteFlag=false;
end

if ~isreal(duration)||~ischar(note)
    error('Wrong type of input argument.')
end
if ~isscalar(duration)||duration<=0
    error('Argument must be positive scalar.')
end

% --- Determine frequency ---
% (American standard pitch. Adopted by the American Standards Association
% in 1936.)
switch note
    case 'C3'
        f=130.81;
    case 'C#3'
        f=138.59;
    case 'D3'
        f=146.83;
    case 'D#3'
        f=155.56;
    case 'E3'
        f=164.81;
    case 'F3'
        f=174.61;
    case 'F#3'
        f=185.00;
    case 'G3'
        f=196.00;
    case 'G#3'
        f=207.65;
    case 'A3'
        f=220.00;
    case 'A#3'
        f=233.08;
    case 'B3'
        f=246.94;
    case 'C4'
        f=261.63;
    case 'C#4'
        f=277.18;
    case 'D4'
        f=293.66;
    case 'D#4'
        f=311.13;
    case 'E4'
        f=329.63;
    case 'F4'
        f=349.23;
    case 'F#4'
        f=369.99;
    case 'G4'
        f=392.00;
    case 'G#4'
        f=415.30;
    case 'A4'
        f=440.00;
    case 'A#4'
        f=466.16;
    case 'B4'
        f=493.88;
    case 'C5'
        f=523.25;
    case 'C#5'
        f=554.37;
    case 'D5'
        f=587.33;
    case 'D#5'
        f=622.25;
    case 'E5'
        f=659.26;
    case 'F5'
        f=698.46;
    case 'F#5'
        f=739.99;
    case 'G5'
        f=783.99;
    case 'G#5'
        f=830.61;
    case 'A5'
        f=880.00;
    case 'A#5'
        f=932.33;
    case 'B5'
        f=987.77;
    case 'p'
        f=000.00;
    otherwise
        error('%s is not a recognized note.',note)
end

% --- Create a pitch vector ---
Fs=8192; % Sampling frequency.
t=0:1/Fs:duration;
y=sin(2*pi*f*t);
% % fading the vector to avoid clicks
% fadetime=.02;
% fadein=0:1/(Fs*fadetime):1;
% fadeout=1:(-1/(Fs*fadetime)):0;
% y(1:(length(fadein)))=y(1:(length(fadein))).*fadein;
% y(length(y)+1-(length(fadein)):length(y))=...
%     y(length(y)+1-(length(fadein)):length(y)).*fadeout;
if muteFlag, return, end

% --- Sound off ---
sound(y,Fs)