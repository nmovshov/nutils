function sketch_impact_geometry(r, theta)
%SKETCH_IMPACT_GEOMETRY A 2D projection of colliding spheres.
%   SKETCH_IMPACT_GEOMETRY(r,theta) displays the familiar "two circles" sketch of
%   planetary impact geometry for the two defining parameters r, the
%   impactor-to-target size ratio, and theta, the impact angle. Specify r between
%   zero and one and theta in radians between 0 and pi/2.

%% Inputs
if nargin == 0
    fprintf('Usage:\n\tsketch_impact_geometry')
    fprintf('(r, theta)\n\t  r in (0,1] theta in [0,pi/2].\n')
    return
end
narginchk(2,2)
validateattributes(r,{'numeric'},{'positive','scalar','<=',1},'','r')
validateattributes(theta,{'numeric'},{'nonnegative','scalar','<=',pi/2},'','theta')

%% Start the canvas
figure;
ah = axes;
ah.Box = 'off';
axis equal
hold(ah,'on')
ah.XAxis.Visible = 'off';
ah.YAxis.Visible = 'off';

%% The target is centered on (0,0) with a radius of R=1
rectangle(ah, 'Position',[-1,-1,2,2], 'Curvature',1);

%% The impactor is centered on ((R+r)cos(theta),(R+r)sin(theta))
xp = (1 + r)*cos(theta);
yp = (1 + r)*sin(theta);
rectangle(ah, 'Position',[xp-r,yp-r,2*r,2*r], 'Curvature',1);

%% Add some helpful annotations
% Lines showing interacting mass
hline = @(y)plot(ah.XLim,[y,y],'r:');
hline(yp-r)
hline(1)

% The impact velocity vector
quiver(xp,yp,-1,0);

% The impact angle
quiver(0,0,xp,yp,'k--','showarrow','off','autoscale','off')
quiver(0,0,ah.XLim(2),0,'k--','showarrow','off','autoscale','off')
text(0.2,0.1,sprintf('\\theta=%g^\\circ',rad2deg(theta)),'fontsize',14)
end
