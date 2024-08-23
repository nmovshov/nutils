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
    case 'NESUS'
        set(groot,'DefaultFigurePosition',[526 345 560 420])
    case 'OPUS'
        set(groot,'DefaultFigurePosition',[403 246 560 420])
    case 'OLGA-SOLDRIF'
        set(groot,'DefaultFigurePosition',[488 342 560 420])
    case 'LUBAN'
        set(groot,'DefaultFigurePosition',[360 235 560 420])
    otherwise
end

% Clean up
clear mname
