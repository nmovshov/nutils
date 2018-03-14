function p = hydrostatic_1layer_incompressible_pressure_profile(R,rho,G)
% Return pressure inside a small, hydrostatic, 1-layer planet.
%
%   Assuming constant density, the hydrostatic equation:
%           dp/dr = -rho(r) * g(r)
%   can be integrated to give a the pressure as a function of radial distance
%   from the center of the planet. The integration constant is fixed by
%   requiring zero pressure at the surface.
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
%   rho : numeric or preal, scalar, positive
%       Density (assumed constant) of planet.
%   G : numeric, scalar, positive, (optional)
%       Value for universal gravitational constant. The default value is in SI 
%       units, so if R is given in meters and rho is given in kg/m^3 then the
%       returned pressure is in Pa.
%
% Author: Naor Movshovitz (nmovshov at gee mail dot com)

%% Input parsing
validateattributes(R,{'numeric','preal'},{})
validateattributes(rho,{'numeric','preal'},{})
validateattributes(double(R),{'numeric'},{'vector','finite','nonnegative'})
validateattributes(double(rho),{'numeric'},{'scalar','finite','positive'})
if ~exist('G','var')
    if isa(R,'preal');
        si = setUnits;
        G = si.gravity;
    else
        G = 6.67384e-11;
    end
end
validateattributes(G,{'numeric','preal'},{})
validateattributes(double(G),{'numeric'},{'scalar','finite','positive'})

%% Function body
% Two branches, depending on what the user had in mind.
if isscalar(R)
    % User wants central pressure
    p = 2/3*pi*G*rho^2*R^2;
else
    % User wants a profile
    a = max(R);
    p = 2/3*pi*G*rho^2*(a^2 - R.^2);
end
