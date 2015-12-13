% Example 2.17 Measurements of impulse responses
f=[-1 -1 -1 1 -1 -1 1 1 -1 1 -1 1 1 1 1];
N=length(f);
T=1;
hknown=[-1 4 -2 -1]/T;
g=T*conv([f f],hknown);
g=g(N+1:2*N)
% g=[2 -6 -2 -2 8 -4 -4 6 4 -8 6 -6 4 2 0];
A=(N+1)/N;              % S_f for an m-sequence is (N+1)/N^2
h=xcorr(g,[f f])/A/T/N  % (2.33), periodic correlation from Example 2.10
h=h(N:2*N-1)
pause
% Alternative solution in frequency domain
F=fft(f)/N;           % (2.2)
G=fft(g)/N;
SfgConj=G.*conj(F)
h=ifft(SfgConj/(A/N))/T % just above (2.33)
pause
% More direct solution, but with division
H=G./F;      % (2.10)
h=ifft(H)/T