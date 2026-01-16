function [A,ero] = gauelim(A)
%GAUELIM Gaussian eliminate matrix by the book
%   GAUELIM(A) returns a matrix in row echelon form that is row equivalent to
%   the input matrix A. Row echelon forms are not unique; the matrix returned
%   by GAUELIM(A) is the row echelon form that results from applying the
%   textbook Gaussian elimination algorithm with no unnecessary row swaps and
%   no type-2 row operations. A zero pivot is resolved by swapping the pivot
%   row with the next-lower row with a non-zero entry in the pivot column.
%
%   [A,ero] = GAUELIM(A) additionally returns a string array detailing the
%   elimination process. The string ero(k) describes the k-th row operation.

%% Input parsing and minimal assertions
if nargin == 0
    fprintf('usage:\n\t[A,e] = gauelim(A)\n')
    return
end
narginchk(1,1)
nargoutchk(0,2)
assert(length(size(A))==2,"A must be a matrix")
ero = [];
eroflag = nargout > 1;

%% Gauss eliminate A (in place)
[m,n] = size(A);
pr = 1;
pc = 1;
while (pr < m) && (pc < n)
    if all(A(pr:end,pc) == 0)
        pc = pc + 1;
    else
        i = pr + find(A(pr:end,pc)~=0,1) - 1;
        if i > pr
            tmp = A(i,:);
            A(i,:) = A(pr,:);
            A(pr,:) = tmp;
            if eroflag
                s = sprintf("R%d<-->R%d",pr,i);
                ero = [ero; s]; %#ok<AGROW>
            end
        end
        for i=pr+1:m
            f = A(i,pc)/A(pr,pc);
            A(i,:) = A(i,:) - f*A(pr,:);
            if eroflag && (f ~= 0)
                if f == 1
                    s = sprintf("R%d->R%d-R%d",i,i,pr);
                elseif f == -1
                    s = sprintf("R%d->R%d+R%d",i,i,pr);
                else
                    s = sprintf("R%d->R%d-(%s)R%d",i,i,strip(rats(f)),pr);
                end
                ero = [ero; s]; %#ok<AGROW>
            end
        end
        pr = pr + 1;
        pc = pc + 1;
    end
end

%% ABYU
end
