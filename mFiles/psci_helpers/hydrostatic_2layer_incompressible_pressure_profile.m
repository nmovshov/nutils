function p = hydrostatic_2layer_incompressible_pressure_profile(R,rc,rhoc,rhom,G)
% Return pressure inside a small, hydrostatic, 2-layer planet.
%
%   Assuming constant density in the two layers, the hydrostatic equation:
%           dp/dr = -rho(r) * g(r)
%   can be integrated to give a the pressure as a function of radial distance
%   from the center of the planet. The integration constants are fixed by
%   requiring zero pressure at the surface and continuity at the layer boundary.
%   
%   This function has two modes. The basic mode takes a vector R, interpreted as
%   radial distance, and returns the presure at each point in R, assuming that
%   the planet's outer radius is max(R). The second mode takes a scalar R,
%   interpreted as the planet's radius, and returns the central pressure.
%   
%   Parameters
%   ----------
%   R : numeric or preal, scalar or vector, nonnegative
%       If scalar, planet's outer radius. If vector, list of positions where 
%       pressure is to be calculated, and max(R) is planet's radius.
%   rc : numeric or preal, scalar, positive
%       Radius of core/mantle boundary.
%   rhoc : numeric or preal, scalar, positive
%       Density of inner layer (core).
%   rhom : numeric or preal, scalar, positive
%       Density of outer layer (mantle).
%   G : numeric or preal, scalar, positive, (optional)
%       Value for universal gravitational constant. The default value is in SI 
%       units, so if R and rc are given in meters and rhoc and rhoc are given in
%       kg/m^3 then the returned pressure is in Pa.
% 
% Author: Naor Movshovitz (nmovshov at gee mail dot com)

%% Input parsing
validateattributes(R,{'numeric','preal'},{})
validateattributes(rc,{'numeric','preal'},{})
validateattributes(rhoc,{'numeric','preal'},{})
validateattributes(rhom,{'numeric','preal'},{})
validateattributes(double(R),{'numeric'},{'vector','finite','nonnegative'})
validateattributes(double(rc),{'numeric'},{'scalar','finite','positive'})
validateattributes(double(rhoc),{'numeric'},{'scalar','finite','positive'})
validateattributes(double(rhom),{'numeric'},{'scalar','finite','positive'})
if ~exist('G','var')
    if isa(R,'preal')
        si = setUnits;
        G = si.gravity;
    else
        G = 6.67384e-11;
    end
end
validateattributes(G,{'numeric','preal'},{})
validateattributes(double(G),{'numeric'},{'scalar','finite','positive'})

%% Function body
a = max(R);
c2 = 4*pi/3*G*(0.5*rhom^2*a^2 - rhom*(rhoc - rhom)*rc^3/a);
c1 = 4*pi/3*G*(0.5*rhoc^2 - 1.5*rhom^2 + rhoc*rhom)*rc^2 + c2;

% Two branches, depending on what the user had in mind.
if isscalar(R)
    % User wants central pressure
    p = c1;
else
    % User wants a profile
    p = preal(NaN(size(R)));
    inner = R <= rc;
    outer = R > rc;
    p(inner) = c1 - 2*pi/3*G*rhoc^2*R(inner).^2;
    p(outer) = c2 - 4*pi/3*G*(0.5*rhom^2*R(outer).^2 - ...
                              rhom*(rhoc-rhom)*rc^3./R(outer));
end
