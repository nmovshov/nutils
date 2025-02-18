function set_session_style(target)
%SET_SESSION_STYLE Modify groot default properties to my liking.
%   SET_SESSION_STYLE(target) modifies default properties of the groot object
%   so that new figures get closer to publication/presentation style, based on
%   where the figure is destined to end up, as defined by the string target.
%   Currently the supported targets are 'screen', 'publication', and
%   'projector' and they in fact result in the same property values.

%% Inputs
if nargin == 0
    fprintf('Usage:\n\tset_session_style(''target'')\n')
    return
end
narginchk(1,1)
target = validatestring(target, {'screen','projector','publication'}); %#ok<NASGU>

%% Some basics
set(groot, 'defaultTextInterpreter', 'latex')
set(groot, 'defaultLineLinewidth', 2)

%% Figure properties
set(groot, 'defaultFigurePosition', [256   112   768   576])
set(groot, 'defaultFigureColor', 'w')

%% Axes properties
set(groot, 'defaultAxesBox', 'on')
set(groot, 'defaultAxesNextPlot', 'add')
set(groot, 'defaultAxesFontSize', 20)
set(groot, 'defaultAxesTickLength', [0.02, 0.025])

%% Legend properties
set(groot, 'defaultLegendInterpreter', 'latex')
set(groot, 'defaultLegendFontSize', 14)

%% And BYU
return

end
