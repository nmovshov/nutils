function [fh, ah] = adjust_to_target(target, hands)
%ADJUST_TO_TARGET Modify existing figure and/or axes properties to my liking.
%   [fh, ah] = ADJUST_TO_TARGET(target) modifies properties of the current figure
%   and axes to get closer to publication/presentation style, based on where the
%   figure is destined to end up, as defined by the string target. Currently the
%   supported targets are 'screen', 'publication', and 'projector'. Use this
%   function to modify existing figures to get a similar look to figures created
%   with ngraf.get_canvas().
%
%   [fh, ah] = ADJUST_TO_TARGET(target,[fh,ah]) works on given handles instead of
%   currents.

%% Inputs
if nargin == 0
    fprintf('Usage:\n\tadjust_to_target(''target'',[fh,ah])\n')
    return
end
narginchk(1,2)
if nargin < 2, hands=[gcf,gca]; end
target = validatestring(target, {'screen','projector','publication'});
validateattributes(hands, {'matlab.graphics.Graphics'}, {'vector', 'numel', 2})

%% For all targets
fh = hands(1);
ah = hands(2);
set(fh, 'defaultTextInterpreter', 'latex')
set(fh, 'defaultLegendInterpreter', 'latex')
set(fh, 'defaultLegendFontSize', 12)
set(fh, 'defaultLegendFontSizeMode', 'manual')
set(fh, 'defaultLineLinewidth', 2)
ah.Box = 'on';
hold(ah, 'on');
ah.XLabel.Interpreter = 'latex';
ah.XLabel.FontSize = 14;
ah.YLabel.Interpreter = 'latex';
ah.YLabel.FontSize = 14;
ah.Title.FontSize = 14;

%% Center and scale (this often auto-tweaks other stuff)
if ismember(target, {'projector','publication'})
    fh.Position(3:4) = [768, 576];
    ngraf.center_fig(fh);
end

%% The grey background is a signature MATLAB visual, but jarring for outsiders
fh.Color = 'w';

%% Magnify tick labels (they inherit from axes font)
if ismember(target, {'projector','publication'})
    ah.FontSize = 20;
end

%% Magnify axes labels (must come AFTER parent axes font size)
if ismember(target, {'projector','publication'})
    ah.XAxis.Label.FontSize = 24;
    ah.YAxis.Label.FontSize = 26;
end

%% Magnify ticks
if ismember(target, {'projector','publication'})
    ah.XAxis.TickLength(1) = 0.02;
    ah.YAxis.TickLength(1) = 0.02;
end

%% Thicker axes lines are easier to see, especially in two-column typesetting
if ismember(target, {'publication'})
    ah.XAxis.LineWidth = 2;
    ah.YAxis.LineWidth = 2;
end

%% And BYU
return

end
