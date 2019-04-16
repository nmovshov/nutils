function n = headcount(file_name, header_mark)
% Return number of header lines in text file.
%
% Many file-reading functions allow the user to specify a number of header lines
% to skip before reading in data. To facilitate reading from files with an unknown
% or varying number of header lines, this function opens a text file, counts the
% number of lines in the header block (defined by a header mark; default is '#''),
% and (always) closes the file. This allows reading in data with a single call.
% For example:
%
%   raw = importdata(filename,' ',headcount(filename));
%
% Parameters
% ----------
% file_name : string
%     File to examine. The file must exist or an error is thrown.
%
% header_mark : character (optional)
%     Character used to denote a comment/header line in data file. Default is '#'.
%
%
% Author: Naor Movshovitz (nmovshov at gmail dot com)

%% Input parsing
if nargin == 0, show_usage, return, end
validateattributes(file_name,{'char'},{'vector'},'','file_name',1)
if ~exist('header_mark','var'), header_mark = '#'; end
validateattributes(header_mark,{'char'},{'scalar'},'','header_mark',2)

%% Function body
fid = fopen(file_name);
if fid == -1
    error(['Could not open file ',file_name])
end
c = onCleanup(@()fclose(fid)); % Leave no file behind...
n = 0;
mline = strtrim(fgetl(fid));
while ischar(mline) && ~isempty(mline) && strcmp(mline(1), header_mark)
    n = n + 1;
    mline = strtrim(fgetl(fid));
end

function show_usage
disp(['Correct usage of ', mfilename, ' is:'])
disp(['    nb_header_lines = ', mfilename, '(file_to_examine, character_denoting_header)'])
disp('Example, read csv table from ascii file with some header lines:')
disp('    raw = importdata(my_file, '','', headcount(my_file, ''#''));')
