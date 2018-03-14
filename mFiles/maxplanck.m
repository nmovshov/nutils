function y=maxplanck(T,type)
%MAXPLANCK  Location of maximum in Planck's distribution.
% MAXPLANCK(T)
% or
% MAXPLANCK(T,'lambda') returns the wavelength of maximum radiation output
% from a black body at temperature T.
% MAXPLANCK(T,'nu') returns instead the frequency of maximum output.

% Author: Naor Movshovitz
% email: lazy_n@yahoo.com
% JAN 2007

if ~exist('type','var'), type='wl'; end

switch lower(type)
    case {'wl','wavelength','lambda'}
        if isa(T,'preal')
            si=setUnits;
            y=(2898*si.micron*si.K)./T;
        else
            y=2898e-6./T;
        end
    case {'nu','freq','frequency'}
        if isa(T,'preal')
            si=setUnits;
            y=(5.879e10*si.Hz/si.K)*T;
        else
            y=(5.879e10)*T;
        end
end