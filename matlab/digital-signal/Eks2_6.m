clear all
% Example 2.6 Convolution of sequences
% Finite signals, (2.5)
T=1;
f=[1 1 2 1 3];
g=[1 1 -1];
c=T*conv(f,g)
c=T*conv(g,f)
pause
% Periodic f with period N, (2.6)
N=length(f);
c=cconv(f,g,N)
% Without cconv:
% One extra period of f needed for f(m) to cover g(l-m)
c=T*conv(g,[f f])
% Relevant portion of periodic convolution starts at N+1:
c=c(N+1:2*N)
pause
% Long pulse gl
gl=[1 1 -1 -2 -3 -4 -5];
c=cconv(f,gl,N)
% Without cconv: More periods of f needed to cover gl
nperiod=ceil((length(gl)-1)/N);
c=T*conv(gl,repmat(f,1,nperiod+1))
% Relevant portion of periodic convolution starts after nperiod*N:
c=c(nperiod*N+1:nperiod*N+N)
pause
% Periodic f and g, (2.7)
% Take a gper with period N
gper=[1 1 -1 -1 1]
c=cconv(gper,f,N)/N
% Without cconv: Two periods of f needed to cover gper
c=conv(gper,[f f])/N
% Relevant portion of periodic convolution starts at N+1:
c=c(N+1:2*N)