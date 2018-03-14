function nplay(music)
%NPLAY  Play music.
% NPLAY plays the tune represented by the specially formatted music
% array.
%
% Syntax: nPlay(music)
%
% Arguments:
% music - n-by-2 cell array, music{:,1} contains strings and music{:,2}
% numeric scalars.
%
% Usage and output:
% nplay(music) plays a tune on the speakers using the nsound function to
% create pitch vectors for each note and MATLAB's sound function to play
% the note on the speakers. Each row of the cell array music represents one
% note to be played, and the duration to play it. The suported notes are
% those recognized by nsound. The character 'p' can appear instead of a
% note to produce silence for the specified duration. See nsound.m for more
% information on supported notes and their string representation.
%
% Examples:
% nplay({'C4',0.5;'D4',0.5;'E4',0.5})
% plays the short tune 'do-re-mi'.
%
% music={'A4',0.20;'p',0.05;'A4',0.20;'p',0.05;...
%        'G4',0.20;'p',0.05;'A4',0.20;'p',0.3;...
%        'E4',0.20;'p',0.25;...
%        'E4',0.20;'p',0.05;'A4',0.20;'p',0.05;...
%        'D5',0.20;'p',0.05;'C#5',0.20;'p',0.05;...
%        'A4',0.30};
% nplay(music)
% Plays the first few notes of Funky Town.
%
% Called m-files: nsound.m
%
% Author: Naor
%
% See also nsound, sound, nTune.

% Verify input
if (~iscell(music))||(ndims(music)>2)||(size(music,2)~=2)
    error('Argument must be an n-by-2 cell array.')
end
notes=music(:,1);
duration=[music{:,2}]';
if ~isreal(duration)
    error('Argument must be real numeric.')
end
if any(duration>4)
    error('Longest note must not exceed 4 seconds.')
end
if sum(duration)>60
    error('Music must be under one minute.')
end
if length(notes)~=length(duration)
    error('Arguments must be of same length.')
end

% Play the tunes
y=[];
for k=1:length(notes)
    y=[y nsound(notes{k},duration(k),true)];
end
sound(y)
pause(sum(duration)) % Safety feature: during playback calling sound.m again will crash MATLAB
