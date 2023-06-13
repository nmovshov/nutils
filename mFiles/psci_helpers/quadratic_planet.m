function a = quadratic_planet(M, R, rho0)
%QUADRATIC_PLANET Return a s.t. rho(r) = a*(r/R)^2 - a + rho0 integrates to M.
%   A quadratic has three free parameters, ax^2 + bx + c, but a quadratic
%   planetary rho(r/R) has three constraints: drho/dr(0)=0 leads to b=0;
%   rho(1)=rho0 makes c = rho0 - a, and finally int_0^R dm(r)=M fixes a.

if nargin < 3, rho0 = 0; end
a = 5/2*rho0 - 15*M/8/pi/R^3;
end
