function y = rslogspace(a, b, n)
%RSLOGSPACE Logarithmically spaced vector of positive integer numbers
%   RSLOGSPACE(X1, X2) generates a row vector of 50 logarithmically
%   spaced integers between X1 and X2.
%
%   RSLOGSPACE(X1, X2, N) generates N points.
% 
% NOTICE!
%   The logarithmic nor linear distances between points will not be equal!

if a<=0 || b<=0 || round(a) ~= a || round(b) ~= b
    error('Both limits must be positve integers!')
end

if b < a
    error('Wrong range!')
end

if nargin == 2
    n = 50;
end

if b-a < n-1
    y = a:b;
    warning('To much points for this range!');
elseif b-a == n-1
    y = a:b;
else
    ni = n;
    al = log10(a);
    bl = log10(b);
    y = unique(round(logspace(al, bl, ni)));
    while length(y) < n
        y = unique(round(logspace(al, bl, round(ni))));
        ni = ni*1.01;
    end
    while length(y) > n
        y = unique(round(logspace(al, bl, round(ni))));
        ni = ni-1;
    end
end