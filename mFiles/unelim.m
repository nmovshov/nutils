function A = unelim(A,moves,muls)
%UNELIM Gaussian un-eliminate matrix by random EROs.
%   UNELIM(A) returns a row-equivalent matrix after several random elementary
%   row operations.

%% Input parsing and minimal assertions
if nargin == 0
    fprintf('usage:\n\tA = unelim(A,moves=6,multipliers=[-4:4])\n')
    return
end
narginchk(1,3)
nargoutchk(0,1)
assert(length(size(A))==2,"A must be a matrix")
if ~exist("moves","var"), moves = 6; end
if ~exist("muls","var"), muls = -4:4; end

%% Uneliminate A (in place)
[m,~] = size(A);
while (moves > 0)
    rowperm = randperm(m);
    i = rowperm(1);
    j = rowperm(2);
    f = muls(randi(length(muls)));
    A(i,:) = A(i,:) - f*A(j,:);
    moves = moves - 1;
end
end
