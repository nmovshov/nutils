function [data, header]=xdr2mat(filename,be)
%XDR2MAT  Convert an xplot-style xdr-file to a MATLAB friendly data file
% XDR2MAT(filename) reads in a file in xdr format, and saves the data as a MATLAB
% array in a .mat file with the same name. A .xdr file is the format used by CSPH for
% input and output. It consists of an ASCII header, ending in a ^^^ delimiter, and
% followed by a stream of unformatted, single precision numbers. The header is
% supposed to contain the number of written variables, and XDR2MAT uses this
% information to reshape the data stream into an array. The ASCII header is displayed
% in the command window.
%
% XDR2MAT(filename,be) reads the .xdr file in big-endian format if be evaluates to
% |true|. The default is |false| as little-endian is near-universal these days.
%
% DATA = XDR2MAT(...) saves the data in the current workspace instead of a .mat file.
%
% [DATA HEADER] = XDR2MAT(...) also saves the header text in the cell array HEADER.
%
% [...] = XDR2MAT with no input arguments will open a file selection dialog.
%
% Minimum MATLAB version: Unknown (tested on R2011b)
% Required Toolboxes: None
%
% Author: Me (Naor)

% Set defaults
if ~exist('filename','var'), filename=''; end
if ~exist('be','var'), be=false; end

% Validate inputs
if ~ischar(filename) || ~islogical(be)
    error('Wrong inputs, RTFM')
end

% Optional: get file name interactively
if isempty(filename)
    [name path]=uigetfile('*.xdr');
    if (name==0), error('Never mind then'), end
    filename=[path name];    
end

% Open file for header (text) access
if (be)
    [fid msg]=fopen(filename,'rt','ieee-be'); % big endian, unlikely but just in case...
else
    [fid msg]=fopen(filename,'rt','ieee-le');
end
if fid<0, error(['Could not open file because:  ' msg]), end

try % leave no file behind...
    
    % Scan the header, looking for indicated number of vars and counting ascii bytes
    header='';
    headerBytes=0;
    lineStr=fgetl(fid);
    nbLines=1;
    while ischar(lineStr) % fgets returns -1 when eof is reached
        header=[header lineStr char(10)]; %#ok
        headerBytes=headerBytes+length(lineStr)+1; % fgetl discards the newline char
        if strcmp(lineStr,'^^^'), break, end
        if nbLines==2, varInfo=lineStr; end % save info from second line
        lineStr=fgetl(fid);
        nbLines=nbLines+1;
    end
    [token remain]=strtok(varInfo,[',-' char(32)]);
    nbParticles=str2double(token);
    token=strtok(remain,[',-' char(32)]);
    nbVars=str2double(token);
    if isnan(nbParticles) || isnan(nbVars)
        error('Wrong format in XDR file')
    end
    
    % Done with header, reopen file in binary mode
    fclose(fid);
    if (be)
        [fid msg]=fopen(filename,'rt','ieee-be'); % big endian, unlikely but just in case...
    else
        [fid msg]=fopen(filename,'rt','ieee-le');
    end
    if fid<0, error(['Could not open file because:  ' msg]), end
    
    % Read and reshape
    fseek(fid,headerBytes,'bof'); % position read head for first data item (hopefully)
    data=fread(fid,'single=>single');

    % Clean up and return
    fclose(fid);

catch exception
    if ~isempty(fopen(fid)), fclose(fid); end
    rethrow(exception)
end