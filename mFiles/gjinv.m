function B = gjinv(A)
%GJINV Gauss-Jordan invert matrix by the book
%   GJINV(A) returns the inverse of the regular matrix A.
%   The function applies the textbook algorithm, applying
%   Gauss-Jordan elimination steps to A and simultanously to I until the
%   original matrix is reduced to RREF.

%% Input parsing and minimal assertions
if nargin == 0
    fprintf('usage:\n\tB = gjinv(A)\n')
    return
end
narginchk(1,1)
assert(length(size(A))==2,"A must be a matrix")
assert(size(A,1)==size(A,2),"A must be square")

%% Gauss-Jordan eliminate A|I
if isa(A,'barnumber')
    I = barnumber.eye(size(A,1));
else
    I = eye(size(A,1));
end
B = [A,I];
B = gjelim(B);
B = B(:,end-2:end);

%% ABYU
end
