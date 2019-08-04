function d = sig2mahal(sig, p)
% Return the Mahalanobis distance in p dims equivalent to Z-score sig.

if nargin == 0
    fprintf('Usage:\n\td = sig2mahal(sig, p)\n')
    return
end
d = sqrt(chi2inv(1 - normcdf(sig,'upper')*2, p));
end
