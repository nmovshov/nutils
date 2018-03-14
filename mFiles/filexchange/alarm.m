function out = alarm(t, msg, varargin)

%ALARM  Displays an alarm message after a set time.
%   ALARM(T, MSG) displays a message after T seconds with a text message
%   MSG. After T seconds, the computer will start beeping and display a
%   dialog box with an option to Snooze. The beeping will stop after one
%   minute or when the dialog box is closed. The snooze interval is 5
%   minutes and up to 10 snoozes are allowed. These values can be changed
%   by ALARM(T, MSG, PROP, VAL, ...) where PROP can be one of the two:
%
%     'SnoozeInt'   : snooze interval in seconds (default: 300)
%     'SnoozeCount' : number of maximum snoozes (default: 10)
%
%   T can also be a string of a specific time for the alarm. The string may
%   be any of the following formats:
%       HH:MM, HH:MM:SS, HH:MM PM, HH:MM:SS PM.
%   If the date is specified, it is ignored. The alarm will go off at the
%   next possible HH:MM:SS.
%
%   The dialog box is a QUESTDLG, which means that all execution will be
%   halted until the user selects one of the buttons.
%
%   ALARM by itself will list all active alarms. It will display whether
%   the alarm has not yet gone off (pending) or has been snoozed, the time
%   til the next alarm, and the alarm message.
%
%   ALARM('-delete') will display the active alarms and give the option of
%   deleting any of the alarms.
%
%   When an ALARM is initially defined, it can return the number of seconds
%   before it will go off. Use semicolon to suppress this output.
%
%   This code uses a timer object, and it will delete itself once the alarm
%   is turned off. Note that the timer can be deleted. When MATLAB closes,
%   it will also be deleted and will NOT be restored at the next session.
%   The purpose of this code is for a simple time reminder function for
%   those long coding sessions one might have.
%
% Example:
%   % alarm in 60 seconds
%   alarm(60, 'You can stop waiting now');
%
%   % alarm at 9 PM
%   alarm('9:00 PM', 'It''s 9 PM!!');
%
%   % snooze time of 3 minutes for a max of 5 snoozes
%   alarm(120, 'Hello!', 'SnoozeInt', 180, 'SnoozeCount', 5);
%
% See also TIMER

%   VERSIONS:
%     v1.0 - first version
%     v2.0 - added option to view and delete active alarms.
%     v2.1 - added 1-min beeping until dialog box is closed. This behaves
%            more like an alarm clock.
%     v3.0 - added option to specify a time. (12/6/2005)
%     v3.1 - minor code change, from MLINT (Mar 2, 2006)
%     v3.2 - only use the HH:MM:SS information. (April 22, 2006)
%     v3.3 - set the ObjectVisibility to off (June, 2007)
%     v3.31- added examples (June, 2008)
%
% Jiro Doke
% Copyright The MathWorks, Inc.
% November 2005

if nargin == 0          % view active alarms
  findAlarm('view');
  return;  
end

if nargin == 1 && ischar(t)
  if strcmpi(t, '-delete')
    findAlarm('delete');
    return;
  end
end

if nargin < 2
  msg = 'This is an Alarm Clock!';
end

if ischar(t)  % it may be a time string -- convert to time in seconds
  curT_vec = clock;
  try
    c = datevec(t);
  catch ME1
    fprintf('Invalid TIME string: ''%s''.\n', t);
    rethrow(ME1);
  end
  % ignore the date (1st 3 elements).
  if datenum([0 0 0, c(4:end)]) > datenum([0 0 0, curT_vec(4:end)])
    % the time is after current time
    c = [curT_vec(1:3), c(4:end)];
  else
    % the time is before, meaning it may be on the next day
    cc = datevec(datenum(curT_vec(1:3))+1); % add one day
    c = [cc(1:3), c(4:end)];
  end
  
  t = etime(c, curT_vec);
end
if ~isnumeric(t) || ~ischar(msg)
  error('T must be time in seconds and MSG must be a string');
end

% default values
st = 300; % snooze interval in seconds
sc = 10;  % number of snoozes

%% Optional input arguments
if nargin > 2
  vars = varargin;
  nvar = length(varargin);
  if mod(nvar, 2)
    error('Optional arguments must be in PROP/VAL pairs');
  end
  while ~isempty(vars)
    if ischar(vars{1})
      switch lower(vars{1})
        
        case 'snoozeint'  % snooze interval
          st = vars{2};
          
        case 'snoozecount'  % number of snoozes
          sc = vars{2};
          
        otherwise
          error('Invalid PROPERTY');
          
      end
      vars(1:2) = '';
    else
      error('Invalid PROPERTY');
    end
  end
end

if ~(isnumeric(st) && numel(st) == 1) || ~(isnumeric(sc) && numel(sc) == 1)
  error('SnoozeInt and SnoozeCount must be a scalar');
end

%% Create timer object
tm = timer(...
  'Name'            , 'Alarm Clock',        ...
  'Period'          , st,                   ...  % snooze interval in seconds
  'StartDelay'      , t,                    ...  % alarm in t seconds
  'TasksToExecute'  , sc,                   ...  % number of snoozes
  'ExecutionMode'   , 'fixedSpacing',       ...
  'ObjectVisibility', 'off',                ...
  'TimerFcn'        , {@displayAlarm, msg}, ...
  'StopFcn'         , @deleteAlarm,         ...
  'tag'             , datestr(now));


%% Start alarm timer
start(tm);

if nargout == 1
  out = t;
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function displayAlarm(obj, edata, msg) %#ok

% beeping sound
t         = 0:1/8192:60;      % beep for 1 minute
x         = 0.25*sin(3000*t);
y         = sin(4*pi*t);      % 2 Hz wave
x(y < 0)  = 0;                % use this to create breaks in the sound
sound(x);

if get(obj, 'TasksExecuted') == get(obj, 'TasksToExecute')  % Reached maximum limit for snooze
  btn = questdlg({datestr(now), msg}, ...
    sprintf('ALARM CLOCK: Snooze (%d)', get(obj, 'TasksExecuted')), ...
    'Okay (Stop)', ...
    'Okay (Stop)');
else
  btn = questdlg({datestr(now), msg}, ...
    sprintf('ALARM CLOCK: Snooze (%d)', get(obj, 'TasksExecuted')), ...
    'Okay (Stop)', ...
    sprintf('Snooze (%0.2g min)', get(obj, 'Period')/60), ...
    'Okay (Stop)');
end

% stop alarm sound
clear playsnd;

switch btn
  
  case 'Okay (Stop)'
    set(obj, 'TasksToExecute', get(obj, 'TasksExecuted'));
    
  otherwise
    % update the current time, so that snooze time starts NOW
    set(obj, 'Tag', datestr(now));
    
end

%--------------------------------------------------------------------------
% deleteAlarm
%--------------------------------------------------------------------------
function deleteAlarm(obj, edata) %#ok

wait(obj);
delete(obj);


%--------------------------------------------------------------------------
% findAlarm
%--------------------------------------------------------------------------
function findAlarm(action)

t = timerfindall('Name', 'Alarm Clock');
if isempty(t)
  fprintf('\nThere are no active alarms.\n\n');
else
  % delete ghost timers (timers that are not active)
  r = get(t, 'Running');
  notRunning = strmatch('off', r, 'exact');
  if ~isempty(notRunning)
    delete(t(notRunning));t(notRunning) = [];
  end
  
  if isempty(t)
    fprintf('\nThere are no active alarms.\n\n');
    return;
  end
  
  fprintf('\nThere are %d active alarms.\n\n', length(t));
  fprintf('Alarm #:  Status:    Time til next alarm:   Alarm message:\n');
  
  snoozeStatus = {'Pending', 'Snoozed'};
  for iTimer = 1:length(t)
    msg = t(iTimer).TimerFcn; msg = msg{2};
    if t(iTimer).TasksExecuted == 0
      alarmTime = t(iTimer).StartDelay;
      isSnooze  = 1;
      
    else
      alarmTime = t(iTimer).Period;
      isSnooze  = 2;
    end
    elapsedTime = etime(clock, datevec(t(iTimer).Tag));
    remainTime  = alarmTime - elapsedTime;
    if remainTime < 60
      rT  = remainTime;
      unt = 'sec';
      
    elseif remainTime < 3600
      rT  = remainTime / 60;
      unt = 'min';
      
    else
      rT  = remainTime / 3600;
      unt = 'hrs';
    end
    
    fprintf('%5d     %-11s%4.1f %-18s%s\n', iTimer, snoozeStatus{isSnooze}, rT, unt, msg);
  end
  fprintf('\n');
  
  if strcmpi(action, 'delete')
    s = input('Enter alarm number(s) to delete or <ENTER> leave untouched: ', 's');
    s = str2double(s);
    if ~isnan(s)
      try
        stop(t(s));
        % the timer object should automatically delete itself after stopping
      catch %#ok
      end
    end
  end
end
