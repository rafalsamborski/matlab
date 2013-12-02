function P = rspowerdb(S)

%---------------------------------------------------------------
%                (C) Rafal Samborski, 2009-10-19      

P = 10*log10(sum(S.^2)/length(S));