function Q = Q_star_D(target_radius, scaling_method)
% Return power-law scaled threshold specific energy for disruption, Q*D.
%
% The fraction of mass ejected from a target after a gravity regime collision
% scales with the specific energy of the impact, Q*. The scaling paramter is the
% threshold for dispersing half of the original target mass - Q*D. In the
% gravity regime, we find that Q*D(R) can be approximated by a power law:
%         Q*D(R) = B*(R/meters)^b.
% This function returns Q*D for an ice or basalt target, based on a few sources.
%
% (Note: Unlike Benz & Asphaug (1999) we do not bother separating the
% multiplicative constant from the target density, since the density is implied in
% the target type anyway.)
%
% Parameters
% ----------
% target_radius : numeric, scalar, positive
%     Target's radius in meters.
% scaling_method : string in ['MKN14_ice', 'MKN14_basalt'], (optional)
%     Power-law choice. Default is 'MKN14_ice', for power law derived from our
%     2014 Spheral++ simulations together with Benz & Asphaug 1999 data.

%% Input parsing
validateattributes(target_radius,{'numeric','preal'},{})
validateattributes(double(target_radius),{'double'},{'scalar','finite','positive'})
if ~exist('scaling_method','var') || isempty(scaling_method)
    scaling_method = 'MKN14_ice';
end
validateattributes(scaling_method,{'char'},{'vector'})

%% Function body
si = setUnits;
switch scaling_method
    case 'MKN14_ice'
        B = 0.05*si.joule/si.kg;
        b = 1.1876;
    case 'MKN14_basalt'
        B = 1.48*si.joule/si.kg;
        b = 0.9893;
    otherwise
        error('nerror:QScaling', ['Unknown scaling method. Use one of:' ...
                                  '\n\tMKN14_ice' '\n\tMKN14_basalt'])
end
Q = B*(target_radius/si.m)^b;
