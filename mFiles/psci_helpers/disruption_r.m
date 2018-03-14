function r = disruption_r(R, M, v, rho)
%DISRUPTION_R Threshold disruption size in gravity-dominated impact.
%   DISRUPTION_R(R,M,v) returns the predicted projectile radius required to make
%   an impact with speed v into a target of radius R and mass M result in
%   catastrophic disruption and dispersion. The colliding bodies are assumed to
%   be large enough for the impact to be gravity dominated. The output is a
%   2-element vector holding the range of predicted radii. The lower bound
%   assumes a head-on impact and the upper bound assumes a 45 degree impact. One
%   or both of the elements of the output may be NaN indicating no projectile
%   smaller than the target could be found. The impactor is assumed to have the
%   same bulk density as the target and both are assumed to be undifferentiated
%   and non rotating. The predicted critical impactor size is calculated from
%   the K* scaling law of Movshovitz et al. (2015).
%
%   DISRUPTION_R(R,[],v,rho) where the second argument is empty uses the 4th
%   argument rho to fill in the mass value.
%
%   Units: All arguments must be specified in SI units. Output is in meters.
%
%   See also disruption_v, isCatastrophic
%
% Author: Naor Movshovitz (nmovshov at google dot com)
%         Earth and Planetary Sciences, UC Santa Cruz

%% Input parsing (NOT bullet proof)
narginchk(3,4);
validateattributes(R,{'numeric'},{'nonempty','finite','positive','scalar'})
validateattributes(v,{'numeric'},{'nonempty','finite','positive','scalar'})
if ~isempty(M)
    validateattributes(M,{'numeric'},{'finite','positive','scalar'})
end
if nargin == 4 || isempty(M)
    validateattributes(rho,{'numeric'},{'nonempty','finite','positive','scalar'})
end

% Override mass with density if needed
if isempty(M), M = 4*pi/3*rho*R^3; end

%% Function body
% Calculate bulk density for target and projectile
rho = M/(4*pi/3*R^3);

% Define anonymous functions of r for relevant physical quantities
G = 6.674e-11;
m = @(r) 4*pi/3*rho*r.^3; % mass
mu = @(r) M*m(r)./(M + m(r)); % reduced mass
K = @(r) 0.5*mu(r)*v^2; % kinetic energy
el = @(r) (R + r)*(1 - sin(pi/4)); % geometric overlap
malpha = @(r) 1*(el(r)>2*r) + ...
    (3*r.*el(r).^2 - el(r).^3)./(4*r.^3)*(el(r)<2*r); % interacting mass fraction
K_alpha = @(r) (malpha(r)*M + m(r))./(M + m(r))*K(r); % interacting kinetic energy
U = @(r) 3/5*G*M^2/R + 3/5*G*m(r).^2./r + G*M*m(r)./(R + r);

% Solve for rlo
Clo = 2.6;
flo = @(r) Clo*U(r) - K(r);
rlo = fzero(flo, R/2); % replace with lion hunt if performance critical
if rlo > R || rlo < 0, rlo = NaN; end

% Solve for rhi
Chi = 8.4*3.5; % upper K* value times 45 degree factor
fhi = @(r) Chi*U(r) - K_alpha(r);
rhi = fzero(fhi, R/2); % replace with lion hunt if performance critical
if rhi > R || rhi < 0, rhi = NaN; end

% Return
r = [rlo, rhi];

end
