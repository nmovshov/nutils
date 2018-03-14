function p = isCatastrophic(R,M,r,m,v,theta)
%ISCATASTROPHIC Will a given gravity-dominated impact result in disruption?
%   ISCATASTROPHIC(R,M,r,m,v,theta) returns 1 if an impact between a radius R
%   and mass M target and a radius r and mass m projectile with speed v at
%   impact angle theta is predicted to lead to catastrophic disruption (defined
%   as less than half the initial colliding mass remaining bound after impact)
%   and returns 0 is the impact is predicted to not lead to disruption. The
%   function returns 1/2 if the predicted impact outcome is within the
%   uncertainty bounds. The disruption threshold is calculated from the scaling
%   law of Movshovitz et al. (2015).
%
%   ISCATASTROPHIC(R,M,r,m,v) uses the default angle theta=pi/4.
%
%   Units: All arguments must be specified in SI units with angles in radians.
%
%   See also: disruption_v, disruption_r
%
% Author: Naor Movshovitz (nmovshov at google dot com)
%         Earth and Planetary Sciences, UC Santa Cruz

%% Input parsing (NOT bullet proof)
narginchk(5,6);
if nargin == 5, theta = pi/4; end
validateattributes(R,{'numeric'},{'nonempty','finite','positive','scalar'})
validateattributes(M,{'numeric'},{'nonempty','finite','positive','scalar'})
validateattributes(r,{'numeric'},{'nonempty','finite','positive','scalar'})
validateattributes(m,{'numeric'},{'nonempty','finite','positive','scalar'})
validateattributes(v,{'numeric'},{'nonempty','finite','positive','scalar'})
validateattributes(theta,{'numeric'},{'nonempty','finite','nonnegative','scalar'})
assert(theta < pi/2, 'Specify impact angle 0 <= theta < pi/2.')
if r > R
    tmp = R; R = r; r = tmp;
    tmp = M; M = m; m = tmp;
end

%% Function body
G = 6.674e-11;
U = 3/5*G*M^2/R + 3/5*G*m^2/r + G*M*m/(R + r);
Clo = 2.5; Chi = 11;
Kstar_lo = Clo*U;
Kstar_hi = Chi*U;
mu = M*m/(M + m);
K = 0.5*mu*v^2;
el = (R + r)*(1 - sin(theta));
if el < 2*r
    malpha = (3*r*el^2 - el^3)/(4*r^3);
else
    malpha = 1;
end
K_alpha = (malpha*M + m)/(M + m)*K;

% Threshold impact energy depends on impact angle; division to angle bins is
% somewhat arbitrary and is likely to change when more simulation data becomes
% available.
p = 1/2;
if theta < pi/6
    if K_alpha > Kstar_hi, p = 1; end
    if K_alpha < Kstar_lo, p = 0; end
elseif theta < pi/4
    if K_alpha > 2*Kstar_hi, p = 1; end
    if K_alpha < 2*Kstar_lo, p = 0; end
else
    if K_alpha > 3.5*Kstar_hi, p = 1; end
    if K_alpha < 3.5*Kstar_lo, p = 0; end
end

% Return
end

