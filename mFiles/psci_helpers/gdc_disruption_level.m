function dl = gdc_disruption_level(R,MRHO,r,mrho,v,theta,scaling,nominal)
%GDC_DISRUPTION_LEVEL Level of target disruption in gravity-dominated collision.
%   GDC_DISRUPTION_LEVEL(R,MRHO,r,mrho,v) returns the predicted level of
%   disruption in a collision between a target of radius R and mass or density
%   MRHO and a projectile of radius r and mass or density mrho with relative
%   impact speed v at 45 degrees impact angle using the scaling law suggested in
%   Movshovitz et al. (2015). The colliding bodies are assumed to be large
%   enough for the impact to be gravity dominated. They are also assumed to be
%   undifferentiated and non-rotating. Specify all inputs in SI units. The 2nd
%   and 4th arguments will be interpreted as mass if their numeric value is
%   greater than 10^6 and as density otherwise. The return value is the ratio of
%   impact energy to predicted threshold energy for disruption. A value greater
%   than or equal to one indicates catastrophic disruption, but this is a
%   convenient reference not a strict definition.
%
%   GDC_DISRUPTION_LEVEL(R,MRHO,r,mrho,v,theta) uses the impact angle theta,
%   specified in radians, instead of assuming a 45 degree impact.
%
%   GDC_DISRUPTION_LEVEL(R,MRHO,r,mrho,v,theta,scaling) or
%   GDC_DISRUPTION_LEVEL(R,MRHO,r,mrho,v,[],scaling) uses the scaling law
%   indicated by the string argument scaling. Currently supported values for
%   scaling are:
%     'METAL15' uses the scaling law suggested in Movshovitz et al., (2015).
%     'LS12'    uses the scaling law suggested in Leinhardt & Stewart, (2012).
%     'BA99'    uses the scaling law suggested in Benz & Asphaug, (1999).
%
%   GDC_DISRUPTION_LEVEL(...,nominal) uses the logical flag nominal to control
%   the algorithm used in METAL15 scaling. With nominal=false (default)
%   disruption level is equal to one if K/U is inside the uncertainty interval
%   [Clo,Chi], equal to K/(Clo*U) if K/U < Clo, and K/(Chi*U) if K/U > Chi. When
%   nominal=true the returned disruption level is always K/(Cnom*U) with Cnom a
%   nominal mid-point value. The parameter nominal has no effect when a scaling
%   other than 'METAL15' is specified.
%
%   GDC_DISRUPTION_LEVEL with no input arguments prints a usage messages and
%   returns.
%
%   See also disruption_r, disruption_v, isCatastrophic
%
% Author: Naor Movshovitz (nmovshov at google dot com)
%         Earth and Planetary Sciences, UC Santa Cruz

%% Input Parsing and minimal(!) assertions
% Help-only invocation
if nargin == 0, print_usage(); return, end;

% Required arguments
narginchk(5,8);

% Optional arguments
if ~exist('theta','var') || isempty(theta), theta = pi/4; end
assert(theta >= 0 && theta < pi/2, 'Specify impact angle theta in [0,pi/2).')
if ~exist('scaling','var'), scaling = 'METAL15'; end
if ~exist('nominal','var'), nominal = false; end
assert(islogical(nominal))

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
% Dispatch to subfunction based on method
switch upper(scaling)
    case 'METAL15'
        dl = metal15(R,M,r,m,v,theta,bigG,nominal);
    case 'LS12'
        dl = ls12(R,M,r,m,v,theta,bigG);
    case 'BA99'
        dl = ba99(R,M,m,v);
    case 'GETAL19'
        dl = getal19(R,M,r,m,v,theta,bigG);
    otherwise
        error('Unknown scaling method. Use one of: [METAL15 | LS12 | BA99].')
end

% Return
end

function dl = ba99(R,M,m,v)
%BA99 Disruption level according to Benz & Asphaug (1999) scaling.

% Target density determines scaling-law parameters
rho = double(M/(4*pi/3*R^3));
if rho < 2000
    % use parameters for ice
    B = 1.2e-7;
    b = 1.26;
else
    % use parameters for basalt
    B = 0.5e-7;
    b = 1.36;
end

% Equation 6 in BA99
QsD = double(B*rho*(R*100)^b);

% Compare with specific impact energy
Q = double(0.5*m/M*v^2);
dl = Q/QsD;

% Return
end

function dl = metal15(R,M,r,m,v,theta,G,nominal)
%METAL15 Disruption level according to Movshovitz et al. (2015) scaling.

U = 3/5*G*M^2/R + 3/5*G*m^2/r + G*M*m/(R + r);
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
Clo = 2.6; Chi = 8.4; Cnom = 0.5*(Clo + Chi);
if (nominal), Clo = Cnom; Chi = Cnom; end
if theta < pi/6
    Kstar_lo = Clo*U;
    Kstar_hi = Chi*U;
elseif theta < pi/4
    Kstar_lo = 2*Clo*U;
    Kstar_hi = 2*Chi*U;
else
    Kstar_lo = 3.5*Clo*U;
    Kstar_hi = 3.5*Chi*U;
end

dl = 1;
if K_alpha > Kstar_hi, dl = K_alpha/Kstar_hi; end
if K_alpha < Kstar_lo, dl = K_alpha/Kstar_lo; end

% Return
end

function dl = ls12(R,M,r,m,v,theta,G)
%LS12 Disruption level according to Leinhardt & Stewart (2012) scaling.

% Calculate reduced interacting mass
el = (R + r)*(1 - sin(theta));
if el < 2*r
    malpha = (3*r*el^2 - el^3)/(4*r^3);
else
    malpha = 1;
end
mu = M*m/(M + m);
mu_alpha = (M*m*malpha)/(M + m*malpha); % this is wrong

% Calculate Q'*_RD
if isa(R,'preal')
    si = setUnits;
    rho1 = 1000*si.kg/si.m^3;
else
    rho1 = 1000;
end
R_c1 = ((M + m)/(4*pi/3*rho1))^(1/3);
c_star = 1.9;
Q_srdge1 = c_star*4/5*pi*rho1*G*R_c1^2;
%mu_bar = 0.35; % Stewart's web calculator
mu_bar = 0.36; % LS12 and SL12
mgamma = m/M;
Q_star_RD = Q_srdge1*(0.25*(mgamma + 1)^2/mgamma)^(2/(3*mu_bar) - 1);
Q_prime_star_RD = Q_star_RD*(mu/mu_alpha)^(2 - 3*mu_bar/2); % this is wrong

% Compare to Q_RD
Q_R = 0.5*mu*v^2/(M + m);
fb = 1 - 0.5*Q_R/Q_prime_star_RD;
if (fb < 0.1)
    eta = -1.5;
    fb = (0.1/1.8^eta)*(Q_R/Q_prime_star_RD)^eta;
end
%dl = Q_R/Q_prime_star_RD;
dl = 2*(1 - fb);

% Return
end

function dl = getal19(R,M,r,m,v,theta,G)
%GETAL19 Disruption level according to Leinhardt & Stewart (2012) scaling.

% Local variables
Mtot = M + m;
mu = M*m/(M + m);
gam = m/M;
vesc = sqrt(2*G*(M + m)/(R + r));

% Kinetic energy of impact
K = 0.5*mu*v^2;

% Gravitational binding energy
Ug = 3/5*G*M^2/R + 3/5*G*m^2/r + G*M*m/(R + r);
Lambda = 0.98;

% Determine hit-and-run impacts
a = -34; b = 20; c = 9.4; d = 17.4; e = 0.86;
tetaHnR = a*log10(gam) + b*Lambda^c;
vHnR = d/rad2deg(theta) + e;
ishitandrun = (rad2deg(theta) > tetaHnR) && (v/vesc > vHnR);


% The kinetic energy scale

dl = ishitandrun;
end

function print_usage()
fprintf('gdc_disruption_level(R, MRHO, r, mrho, v, theta=pi/4, ')
fprintf('scaling=''METAL15'', nominal=false)\n')
end
