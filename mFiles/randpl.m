function X = randpl(alpha, xmin, xmax, sample_size)
% Draw sample from a power law probability distribution.
%
% Return sample_size random variables drawn from a power-law (a.k.a Pareto)
% distribution:
%   PDF: p(x)dx = alpha*xmin^alpha*x^(-alpha-1) if 0<xmin<=x, 0 otherwise.
%   CDF: p(X<=x) = 1 - (xmin/x)^alpha if 0<xmin<=x, 0 otherwise.
% 
% Algorithm: This function uses inverse transform sampling.
%
% Author: Naor Movshovitz (nmovshov at gee mail dot com)

% Minimal input validation and default assignments
if ~exist('xmax', 'var'), xmax = []; end
if ~exist('sample_size', 'var'), sample_size = [1 1]; end
validateattributes(alpha, {'numeric'}, {'scalar','positive'},'','alpha');
validateattributes(xmin, {'numeric'}, {'scalar','positive'},'','xmin');
if ~isempty(xmax)
    validateattributes(xmax, {'numeric'}, {'scalar','positive','>',xmin},'','xmax');
end
validateattributes(sample_size, {'double'}, {'vector','integer','positive'},'','sample_size');
if length(sample_size) == 1, sample_size = [sample_size,1]; end

% Return inverse transform sampling
if isempty(xmax) || isinf(xmax)
    U = rand(sample_size);
    X = xmin./U.^(1/alpha);
else
    U = rand(sample_size);
    X = ((xmax^alpha - U*xmax^alpha + U*xmin^alpha)/(xmax*xmin)^alpha).^(-1/alpha);
end
