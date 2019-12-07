function py_addpath(newdir)
%PY_ADDPATH Add directory to python module path.

if nargin == 0
    fprintf('Usage:\n\tpy_addpath(directory_name)\n')
    return
end
validateattributes(newdir, {'char'}, {'row'})

if isfolder(newdir)
    path = py.sys.path;
    path.append(newdir);
else
    error('%s does not exists or is not a valid directory name.', newdir)
end
end
