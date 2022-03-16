function T = anders1989()
%ANDERS1989 Table 2 from Anders and Grevesse, 1989.
%   T = ANDERS1989() returns the relative abundances of elements in the solar
%   atmosphere according to table 2 in the review by Anders and Grevesse, 1989.
%   The quoted data is abundance on a logarithmic scale relative to hydrogen.
%   In addition the returned table holds convenient transformations to numbers
%   ratios and mass fractions.
%
%   Full reference: Anders, E., & Grevesse, N. (1989). Abundances of the
%                   elements: Meteoritic and solar. Geochimica et Cosmochimica
%                   Acta, 53(1), 197–214. doi:10.1016/0016-7037(89)90286-X

Z = (1:28)'; % Atomic number, we go up to Ni
CS = {'H';'He';'Li';'Be';'B';'C';'N';'O';'F';'Ne';'Na';'Mg';'Al';'Si';'P';...
    'S';'Cl';'Ar';'K';'Ca';'Sc';'Ti';'V';'Cr';'Mn';'Fe';'Co';'Ni'};
dex = [12, 10.99, 1.16, 1.15, 2.6, 8.56, 8.05, 8.93, 4.56, 8.09, 6.33, 7.58,...
    6.47, 7.55, 5.45, 7.21, 5.50, 6.56, 5.12, 6.36, 3.10, 4.99, 4.00, 5.67,...
    5.39, 7.67, 4.92, 6.25]'; % Abundances on "dex" (log N_H=12) scale
el2H = 10.^(dex - 12); % element abundance ratios to hydrogen
A = [1.008, 4.0026, 6.94, 9.0122, 10.81, 12.011, 14.007, 15.999, 18.998,...
    20.18, 22.99, 24.305, 26.982, 28.085, 30.974, 32.06, 35.45, 39.95,...
    39.098, 40.078, 44.956, 47.867, 50.942, 51.996, 54.938, 55.845, 58.933,...
    58.693]'; % standard atomic weight
Zi = (el2H.*A)/sum(el2H.*A); % mass fractions (metals)

T = table(Z,A,dex,el2H,Zi,'RowNames',CS);
