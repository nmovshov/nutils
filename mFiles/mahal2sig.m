function z = mahal2sig(d, p)
% Return z-score equivalent of Mahalanobis distance d in p dims.

if nargin == 0
    fprintf('Usage:\n\td = mahal2sig(d, p)\n')
    return
end
z = -norminv(chi2cdf(d.^2,p,'upper')/2);
end
