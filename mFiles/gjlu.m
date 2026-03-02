function [L,U] = gjlu(A)
%GJLU Decompose matrix to LU by the book
%   [L,U] = GJLU(A) returns a lower-triangular matrix L and an upper-triangular
%
%   The decomposition follows the textbook algorothm, with no pivoting, making
%   it an unstable algorithm when applied to matrices of real numbers. If a
%   zero pivot is encoutnered the algorithm stops with an error.

%% Input parsing and minimal assertions
if nargin == 0
    fprintf('usage:\n\t[L,U] = gjlu(A)\n')
    return
end
narginchk(1,1)
nargoutchk(2,2)
assert(length(size(A))==2,"A must be a matrix")
assert(size(A,1)==size(A,2),"A must be square")

%% Gauss eliminate A (in place)
n = size(A,1);
pr = 1;
pc = 1;
U = A;
L = eye(n);
if isa(A,'barnumber'), L = barnumber.eye(n); end
while (pr < n) && (pc <= n)
    if all(U(pr:end,pc) == 0)
        pc = pc + 1;
    elseif U(pr,pc) == 0
        error("LU decomposition is not possible; try PLU instead")
    end
    for i=pr+1:n
        f = U(i,pc)/U(pr,pc);
        U(i,:) = U(i,:) - f*U(pr,:);
        L(i,pc) = f;
    end
    pr = pr + 1;
    pc = pc + 1;
end

%% ABYU
end
