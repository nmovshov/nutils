%STARTUP  Naor's startup script

% Which device am I running on?
if ispc
    mname = getenv('COMPUTERNAME');
else
    mname = getenv('HOSTNAME');
end

% Device specific preferences
switch mname
    case 'KZIN'
        set(groot,'DefaultFigurePosition',[555 290 768 576])
    case 'PAK'
        if verLessThan('matlab','8.4.0')
            set(0,'DefaultFigurePosition',[460 299 632 474])
        else
            set(groot,'DefaultFigurePosition',[460 299 632 474])
        end
    case 'NESUS'
        set(groot,'DefaultFigurePosition',[526 345 560 420])
    case 'OPUS'
        set(groot,'DefaultFigurePosition',[403 246 560 420])
    otherwise
end

% Clean up
clear mname
