function v = disruption_v(R,MRHO,r,mrho,theta)
%DISRUPTION_V Threshold disruption speed in gravity-dominated impact.
%   DISRUPTION_V(R,MRHO,r,mrho) returns the predicted speed (range) required to
%   make an impact between a target of radius R and mass or density MRHO and a
%   projectile of radius r and mass or density mrho result in catastrophic
%   disruption and dispersion according to the scaling law suggested in
%   Movshovitz et al. (2015). The colliding bodies are assumed to be large
%   enough for the impact to be gravity dominated. They are also assumed to be
%   undifferentiated and non rotating. Specify all inputs in SI units. The 2nd
%   and 4th arguments will be interpreted as mass if their numeric value is
%   greater than 10^6 and as density otherwise. Output is a 2 element vector
%   holding the range of predicted speeds. The lower bound assumes a head-on
%   impact and the upper bound assumes a 45 deg impact.
%
%   DISRUPTION_V(R,MRHO,r,mrho,theta) where theta is a 1x2 vector uses the angle
%   theta(1) instead of 0 to calculate the lower bound and the angle theta(2)
%   instead of 45 deg to calculate the upper bound. Specify theta in radians. If
%   theta is a scalar then lower and upper bounds will be calculated at the same
%   impact angle.
%
%   Units: All arguments must be specified in SI units (or use dimensioned
%   variables). Output is in meters/second.
%
%   See also disruption_r, isCatastrophic, gdc_disruption_level
%
% Author: Naor Movshovitz (nmovshov at google dot com)
%         Earth and Planetary Sciences, UC Santa Cruz

%% Input Parsing and minimal(!) assertions
% Help-only invocation
if nargin == 0, print_usage(); return, end;

% Required arguments
narginchk(4,5);

% Optional arguments
if ~exist('theta','var') || isempty(theta), theta = [0,pi/4]; end
if isscalar(theta), theta = [theta, theta]; end

% Sanity check
validateattributes(R,{'numeric'},{'nonempty','finite','scalar'})
validateattributes(MRHO,{'numeric'},{'nonempty','finite','scalar'})
validateattributes(r,{'numeric'},{'nonempty','finite','scalar'})
validateattributes(mrho,{'numeric'},{'nonempty','finite','scalar'})
validateattributes(theta,{'numeric'},{'size',[1,2]})
assert(all(theta >= 0 & theta < pi/2), 'Specify impact angles in [0,pi/2).')

% Mass-or-density determined by numeric value (assume SI units)
if double(MRHO) > 1e6
    M = MRHO;
else
    M = 4*pi/3*MRHO*R^3;
end
if double(mrho) > 1e6
    m = mrho;
else
    m = 4*pi/3*mrho*r^3;
end

% Big G
if isa(R,'preal')
    si = setUnits;
    bigG = si.gravity;
else
    bigG = 6.674e-11;
end

%% Function body
U = 3/5*bigG*M^2/R + 3/5*bigG*m^2/r + bigG*M*m/(R + r);
mu = M*m/(M + m);

% Warning: Threshold impact energy depends on impact angle; division to angle
% bins is somewhat arbitrary and is likely to change when more simulation data
% becomes available.

% Lower values
C = 2.6;
if theta(1) < pi/6
    Kstar = C*U;
elseif theta(1) < pi/4
    Kstar = 2*C*U;
else
    Kstar = 3.5*C*U;
end
el = (R + r)*(1 - sin(theta(1)));
if el < 2*r
    malpha = (3*r*el^2 - el^3)/(4*r^3);
else
    malpha = 1;
end
Kstar = Kstar/((malpha*M + m)/(M + m));
vlo = sqrt(2*Kstar/mu);

% Upper values
C = 8.4;
if theta(2) < pi/6
    Kstar = C*U;
elseif theta(2) < pi/4
    Kstar = 2*C*U;
else
    Kstar = 3.5*C*U;
end
el = (R + r)*(1 - sin(theta(2)));
if el < 2*r
    malpha = (3*r*el^2 - el^3)/(4*r^3);
else
    malpha = 1;
end
Kstar = Kstar/((malpha*M + m)/(M + m));
vhi = sqrt(2*Kstar/mu);

% Return
v = [vlo, vhi];

end

function print_usage()
help(mfilename)
end
