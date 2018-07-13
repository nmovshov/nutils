function alphas = sphereslice(rrat, theta, phi, gridres)
%SPHERESLICE Intersecting volume fractions of passing spheres.
%   alphas = SPHERESLICE(rrat, theta, phi=0) returns the fraction of volumes of
%   two spheres that intersects as they move across each other ina straight line.
%   The geometry is defined by rrat, the ratio of the smaller sphere's radius to
%   the larger, and the two impact angles theta and phi. If the relative motion of
%   the spheres is parallel to the x-axis and the larger one (of radius R) is
%   centered at the origin then the center of the smaller sphere (of radius r) at
%   the moment of first contact is at (R + r)*[1, sin(theta), sin(phi)]. The
%   volume fraction of the larger sphere is returned in alphas(1) and that of the
%   smaller in alphas(2).
%
%   alphas = SPHERESLICE(..., gridres=0.02)
%   The grid resolution used to test the intersecing volumes as the spheres move
%   past each other can be controlled with the gridres parameter, with values
%   normalized to the larger sphere's radius. But keep in mind that a three
%   dimensional grid will quickly consume available memory with increasing
%   resolution.

if nargin == 0 && nargout == 0, help sphereslice, return, end
narginchk(2,4)
if nargin < 3 || isempty(phi), phi = 0; end
if nargin < 4 || isempty(gridres), gridres = 0.02; end
R = 1.0;
r = rrat;

% This is our grid
gv = -1:gridres:1;
[X,Y,Z] = meshgrid(gv);

% First we slice the target with the projectile
target = @(x,y,z) x.^2 + y.^2 + z.^2 <= R^2;
T = target(X,Y,Z);
iT = false(size(T));

yp = (R + r)*sin(theta);
zp = (R + r)*sin(phi);
projectile = @(x,y,z,xp) (x - xp).^2 + (y - yp).^2 + (z - zp).^2 <= r^2;
for xp = -(R + r):gridres:(R + r)
    P = projectile(X,Y,Z,xp);
    O = T&P;
    iT = iT|O;
end
alphas(1) = sum(iT(:))/sum(T(:));

% Then we slice projectile with the target
projectile = @(x,y,z) x.^2 + y.^2 + z.^2 <= r^2;
P = projectile(X,Y,Z);
iP = false(size(P));

yt = -(R + r)*sin(theta);
zt = -(R + r)*sin(phi);
target = @(x,y,z,xt) (x - xt).^2 + (y - yt).^2 + (z - zt).^2 <= R^2;
for xt = -(R + r):gridres:(R + r)
    T = target(X,Y,Z,xt);
    O = T&P;
    iP = iP|O;
end
alphas(2) = sum(iP(:))/sum(P(:));

end
