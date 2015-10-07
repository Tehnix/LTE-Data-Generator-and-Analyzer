% Example 2.7 Linear system
T=2;            % For test of equations
f=[1 2 1];
h=[1 -1]/T;
g=conv(f,h)*T   % (2.12)
pause
% Frequency approach, periodic signals:
N=4;
F=fft([f 0])/N  % (2.2)
H=fft([h 0 0])*T% (2.11), dimensionless H
G=F.*H          % (2.6)&(2.12)
g=ifft(G)*N     % (2.2)
pause
% Frequency approach, non periodic:
F=T*fft([f 0])   % (2.3)
H=T*fft([h 0 0]) % (2.11), dimensionless H
G=F.*H           % (2.12)
g=ifft(G)/T      % (2.3)
