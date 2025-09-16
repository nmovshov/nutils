function [A,ero] = gauelim(A)
%GAUELIM Gaussian eliminate matrix by the book
%   Detailed explanation goes here

%% Input parsing and minimal assertions
if nargin == 0
    fprintf('usage:\n\t[A,e] = gauelim(A)\n')
    return
end
narginchk(1,1)
nargoutchk(0,2)
assert(length(size(A))==2,"A must be a matrix")

%% Gauss eliminate A (in place)
[m,n] = size(A);
pr = 1;
pc = 1;
while (pr < m) && (pc < n)
    if all(A(:,pc) == 0)
        pc = pc + 1;
    else
        i = pr + find(A(pr:end,pc)~=0,1) - 1;
        if i > pr
            tmp = A(i,:);
            A(i,:) = A(pr,:);
            A(pr,:) = tmp;
        end
        for i=pr+1:m
            f = A(i,pc)./A(pr,pc);
            A(i,:) = A(i,:) - f*A(pr,:);
        end
        pr = pr + 1;
        pc = pc + 1;
    end
end

%% ABYU
ero = A; % placeholder for ero list
end
