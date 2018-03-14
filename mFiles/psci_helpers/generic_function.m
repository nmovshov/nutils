function y = generic_function(filename,nLines,varargin)
% Template for a generic function.
%
% Copy and paste the contents of this file to start work on a new function.
%
% Author: Naor Movshovitz (nmovshov at gee mail dot com)

%% Input parsing
p = inputParser;
p.addRequired('filename',@ischar);
p.addRequired('nLines',@(x)isnumeric(x) && all(x<20));
p.addOptional('dbg',false,@islogical);
p.addParamValue('color',[0 0 1],@(x)validateattributes(x,{'numeric'},{'vector'}));
p.parse(filename,nLines,varargin{:});

%% Function body
y = 2;