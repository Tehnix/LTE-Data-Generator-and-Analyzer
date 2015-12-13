% Example 2.10 Correlation functions
T=1;
f=[1 4 2 0 3];
% Autocorrelation
Rf=T*xcorr(f,f)
Rf1=T*conv(f,fliplr(f))
% Cross correlation
g=[1 1 -1];
Rfg=T*xcorr(f,g)         % 0 is in the middle
Rfg1=T*conv(f,fliplr(g)) % No padding, difficult to locate 0
pause
% Correlation for periodic f
N=length(f);
ff=[f f];
Rtemporary=xcorr(f,ff)/N
Rf=Rtemporary(N:2*N-1)
% fliplr does not provide the correct indexing of periodic f
% some more complex manipulations are needed for cconv
Rf1=fliplr(cconv(f,fliplr(f),N)/N)
Rf2=cconv(f,[1 3 0 2 4],N)/N
pause
% Cross correlation for periodic f and g
gper=[1 1 -1 0 0];
gg=[gper gper];
Rtemporary=xcorr(f,gg)/N
Rfg=Rtemporary(N:2*N-1)
% fliplr does not provide the correct indexing of periodic f and g
% some more complex manipulations are needed for cconv
Rfg1=fliplr(cconv(fliplr(f),gper,N)/N)
Rfg2=cconv(f,[1 0 0 -1 1],N)/N