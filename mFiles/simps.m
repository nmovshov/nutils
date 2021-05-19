function I = simps(x,y,evenstrat,safety)
%SIMPS Numerical integral of ordered data by extended Simpson's rule.
%   I = SIMPS(x,y) computes an approximation of the integral of y wrt x by the
%   extended Simpson rule; x and y are vectors of the same length, real and
%   finite, and assumed monotonic. For an odd N=length(x) of equally spaced
%   points the result is exact for polynomials of order 3 or less (making this
%   a 4th-order method). It is assumed that x contains equally-spaced
%   abscissas; the actual interval width that will be used is the first element
%   of diff(x).
%
%   I = SIMPS(x,y,'first|last') when N=length(x) is even (leaving an odd number
%   N-1 of subintervals) uses Simpson's rule on the first|last N-2 intervals
%   and a trapezoid rule on the last|first one.
%
%   Note: I'm using the simps(x,y) signature to make simps an easy stand in for
%   any trapz(x,y) call; but keep in mind that, unlike trapz, simps needs
%   equally spaced abscissas and will use x only to derive an appropriate
%   interval width h. A simps(y,h) would in fact be more appropriate, if
%   consistency with trapz was not a factor.

%% Minimal input control (unless in risktaker mode)
if nargin == 0
    fprintf('Usage:\n\tZ = simps(x,y,''first|last'')\n')
    return
end
narginchk(2,4)
if nargin < 3 || isempty(evenstrat), evenstrat = 'first'; end
if nargin < 4 || isempty(safety), safety = true; end
if safety
    validateattributes(x,{'numeric'},{'finite','real','vector'})
    validateattributes(y,{'numeric'},{'finite','real','vector'})
    evenstrat = validatestring(evenstrat,{'first','last'});
    nx = length(x); ny = length(y);
    assert(nx == ny,'len(x)=%d~=%d=len(y).',nx,ny)
    dx = diff(x);
    assert(abs(std(dx)/mean(x))<1e-10,'x must contain equally spaced abscissas.')
else
    nx = size(x,2);
    dx = diff(x);
end

%% Extended Simpson's rule
N = nx;
h = dx(1);
if mod(N,2) > 0
    I = (h/3)*(y(1) + 4*sum(y(2:2:N-1)) + 2*sum(y(3:2:N-2)) + y(N));
elseif isequal(evenstrat,'first')
    I = (h/3)*(y(1) + 4*sum(y(2:2:N-2)) + 2*sum(y(3:2:N-3)) + y(N-1));
    I = I + (h/2)*(y(N-1) + y(N));
else
    I = (h/3)*(y(2) + 4*sum(y(3:2:N-1)) + 2*sum(y(4:2:N-2)) + y(N));
    I = I + (h/2)*(y(1) + y(2));
end

end
