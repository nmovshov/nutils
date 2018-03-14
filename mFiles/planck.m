function y=planck(T,v,type)
%PLANCK  Planck's function.
% planck(T,lambda) is the black body radiation from a surface at
% temperature T. The functions returns the "specific intensity", or
% "brightness": energy per unit time per unit area per unit wavelength per
% unit infinitesimal solid angle. In this implementation T is a scalar and
% lambda can be a vector.

% Author: Naor
% email: lazy_n@yahoo.com
% Dec. 2007

if ~exist('type','var'), type='wl'; end

if isa(T,'preal')&&isa(v,'preal')
    si=setUnits;
    h=si.planck;
    k=si.boltzmann;
    c=si.speed_of_light;
else
    h=6.626068e-34;
    k=1.380638320020747e-23;
    c=299792458;
end

switch lower(type)
    case {'wl','wavelength','lambda'}
        y=(2*h*c^2)./(v.^5).*(exp(h*c/k/T./v)-1).^-1;
    case {'frequency','freq','nu'}
        y=(2*h*v.^3)/(c^2).*(exp(h*v/k/T)-1).^-1;
end