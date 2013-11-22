function a = rsstr2double(b)
%RSSTR2DOUBLE Convert string to double-precision value (several times
%   faster than STR2DOUBLE)
% 
% Syntax:
% a = rsstr2double(b)
% 

if ischar(b)
    b = cellstr(b);
end

if ~iscellstr(b)
    error('Wrong type of argument!')
end

a = cell2mat(textscan(sprintf('%s,', b{:}), '%f', length(b), 'Delimiter', ',', 'EmptyValue', NaN));