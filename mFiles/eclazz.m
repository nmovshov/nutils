function labels = eclazz(data, prox)
%ECLAZZ  Partition a set (tree) into equivalence classes (connected components).
% 
%  Numerical Recipes (3rd edition) contains an efficient non-recursive 
%  algorithm due to D. Eardley [1] for partitioning a set into equivalence 
%  classes without holding a tree structure or an adjacency matrix. The
%  algorithm works by going over all pairs of elements and labeling them to
%  a common ancestor if they pass the given proximity test. This method
%  will partition the set according to the equivalence relation that results
%  from expanding the proximity relation to be transitive. This function is an
%  m-language implementation of the NR3 c++ function.
%
% Inputs:
%  prox: function handle to a boolean function of two arguments of the same type
%  as data. prox(data{i},data{j}) returns true if the i-th and j-th elements of data
%  are neighbors, false otherwise. **No checks will be made on the validity of prox.**
%  data: 1D cell array containing the set to be partitioned.
% Outputs:
%  labels: 1D array of integer labels. labels(i) is the integer label of the
%  equivalence class that contains data{i}.
%
% Author: Naor Movshovitz.
% References: [1] Numerical Recipes (3rd edition) ch 8.6.

%% minimal input filter
narginchk(2,2)
assert(isa(prox,'function_handle'))
assert(isscalar(prox))
assert(iscell(data))
assert(isvector(data))

%% initialize output array for speed
%eqcls=uint32(zeros(size(data))); % int classes don't support NaN
labels=nan(size(data)); % is uint32 better or worse or nothing?

%% The NR algorithm (with the book's exact, and useless, comments)
labels(1)=1;
for j=2:length(data) % Loop over first element of all pairs.
    labels(j)=j;
    for k=1:j-1      % Loop over second element of all pairs.
        labels(k)=labels(labels(k)); % Sweep it up this much.
        if prox(data{j},data{k}), labels(labels(labels(k)))=j; end % Good exercise for the reader to figure out why this much ancestry is necessary!
    end
end
for j=1:length(data)
    labels(j)=labels(labels(j)); % Only this much sweeping is needed finally.
end
