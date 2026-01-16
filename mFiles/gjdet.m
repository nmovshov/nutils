function d = gjdet(A)
%GJDET Matrix determinant by Gaussian elimination.
%   GJDET(A) returns the determinant of the square matrix A. The function find
%   a REF of A and returns the product of diagnoal entries. Pivoting is only
%   done if a zero is encountered in the pivot column, not for numerical
%   stability.

%% Input parsing and minimal assertions
if nargin == 0
    fprintf('usage:\n\tB = gjdet(A)\n')
    return
end
narginchk(1,1)
assert(length(size(A))==2,"A must be a matrix")
assert(size(A,1)==size(A,2),"A must be square")

[B,e] = gjref(A);
d = B(1,1);
for k=2:size(A,1)
    d = d*B(k,k);
end
for k=1:length(e)
    if e(k).contains('<-->'), d = -d; end
end

end
