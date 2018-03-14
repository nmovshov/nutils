%% Test driver for collision_coucome.m
clear
clc
close all
physunits off
si = setUnits;

%% Random encounters - compare with http://www.fas.harvard.edu/~planets/sstewart/resources/collision/
% Inputs
% (1) Demonstrate disagreement with Bens & Asphaug (1999) scaling law
R_target = 1000*si.km;
r_projectile = 200*si.km;
v_impact = 42*si.km/si.s;
theta_impact = deg2rad(0);

% (2) Playground ...

% Derived
rho_ice = 920*si.kg/si.m^3;
M_target = 4*pi/3*rho_ice*R_target^3;
m_projectile = 4*pi/3*rho_ice*r_projectile^3;
m_gamma = m_projectile/M_target;
M_total = M_target + m_projectile;
v_escape = sqrt(2*si.gravity*M_total/(R_target + r_projectile));

% Output
clc
[M_lr, oreg, QQs] = collision_outcome(R_target, r_projectile, v_impact, theta_impact,...
                                rho_ice, 'LS12',true);
fprintf('For V_impact/V_escape = %g and impact angle of %g degrees, M_lr/M_tot = %g.\n',...
         double(v_impact/v_escape), rad2deg(theta_impact), double(M_lr/M_total));
fprintf('The collision outcome regime is %s.\n', oreg{2})

%% Reproduce Dwyer et al. (2013) fig. 1
% keep si
% clc
