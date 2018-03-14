%% Gravitational binding energy of a two-layer planet
clc
si = setUnits;

%% Inputs
M = 1.0*si.earth_mass; % total planet mass
alpha_c = 0.5; % core mass fraction
rho_c = 8000*si.kg/si.m^3; % core average density
alpha_m = 1 - alpha_c; % mantle mass fraction
rho_m = 3300*si.kg/si.m^3; % mantle density

%% Intermediates
r_c = ((alpha_c*M)/(4*pi/3*rho_c))^(1/3);
R = ((M - 4*pi/3*(rho_c - rho_m)*r_c^3)/(4*pi/3*rho_m))^(1/3);

%% Output
G = si.gravity;
U = G*4*pi/3*4*pi/5*(rho_c^2)*r_c^5 + ...
    G*4*pi/3*4*pi/2*(rho_c - rho_m)*rho_m*(r_c^3)*(R^2 - r_c^2) + ...
    G*4*pi/3*4*pi/5*rho_m^2*(R^5 - r_c^5)

U_ref = 3/5*G*M^2/R

W_mantle = U - 3/5*G*(alpha_c*M)^2/r_c

W_mantle_fraction = W_mantle/U
